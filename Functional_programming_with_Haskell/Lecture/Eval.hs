{-# LANGUAGE GADTSyntax #-}

module Functional.Lecture.Eval where

{-
predefined in Haskell as follows

(||) :: Bool -> Bool -> Bool
(||) True   _ = True
(||) False  b = b

-}

boolLoop :: Bool
boolLoop = boolLoop

{-
data [] a where
  []  :: [] a
  (:) :: a -> [] a -> [] a

data (,) a b where
  (,) :: a -> b -> (,) a b
-}

trues :: [] Bool
trues = True: trues

nats :: [] Int
nats = nats' 0
 where
   nats' i = i : nats' (i+1)

--            [a]  -> [(a,Bool)]
assignTrue :: [] a -> [] ((,) a Bool)
assignTrue []           = []
assignTrue (val : list) = (val, True) : assignTrue list

numberedList :: [] a -> [] ((,) a Int)
numberedList list = numberedList' 0 list
 where
  numberedList' i []           = []
  numberedList' i (val : list) = (val,i) : numberedList' (i+1) list

zipList :: [] a -> [] b -> [] ((,) a b)
zipList [] _                          = []
zipList _ []                          = []
zipList (valA : listA) (valB : listB) = (valA, valB) : zipList listA listB

numberedListZip :: [] a -> [] ((,) a Int)
numberedListZip listA = zipList listA nats

numberedList2 :: [] a -> [] ((,) a Int)
numberedList2 list = zipList list (makeList 0 (length list))

makeList :: Int -> Int -> [] Int
makeList start end = if start <= end
                       then start : makeList (start + 1) end
                       else []

assignTrueZip :: [] a -> [] ((,) a Bool)
assignTrueZip listA = zipList listA trues

takeList :: Int -> [] a -> [] a
takeList 0 listA          = []
-- takeList 1 (val : listA) = val : []
-- takeList 2 (val1 : val2 : listA) = val1 : val2 : []
takeList n (val1 : listA) = val1 : takeList (n - 1) listA

-- [2^0, 2^1, 2^2 ...]
exponents :: [] Int
exponents = exponents' 0
 where
  exponents' pow = 2^pow : exponents' (pow+1)

-- exponentsInt :: [] Int
-- exponentsInt = exponents' 0
--  where
--   exponents' pow = 2^pow : exponents' (pow+1)

{-
data Maybe a where
  Nothing :: Maybe a
  Just    :: a -> Maybe a
-}

indexAt :: [] a -> Int -> Maybe a
indexAt [] _         = Nothing
indexAt (val:list) 0 = Just val
indexAt (val:list) n = indexAt list (n-1)

pow2 :: Int -> Maybe Int
pow2 pow = indexAt exponents pow


countElem :: [] Int -> Int -> Int
countElem [] elemToFind = 0
countElem (val:list) elemToFind = if val == elemToFind
                                    then 1 + countElem list elemToFind
                                    else countElem list elemToFind

indicesForElem :: [] Int -> Int -> [] Int
indicesForElem list elem = help (zip list nats) elem
 where
   -- help :: [] ((,) Int Int) -> Int -> [] Int
   help [] elemToFind = []
   help ((val,index):list) elemToFind = if val == elemToFind
                                          then index : help list elemToFind
                                          else help list elemToFind

hasElem :: [] Int -> Int -> Bool
hasElem [] _ = False
hasElem (val:list) elemToFind =
  (val == elemToFind) || (hasElem list elemToFind)

lengthList :: [] a -> Int
lengthList []         = 0
lengthList (val:list) = 1 + lengthList list

lenghtListFold :: [] a -> Int
lenghtListFold list = foldList eF cF list
 where
  -- eF :: Int
  eF = 0
  -- cF :: a -> Int -> Int
  cF val res = 1 + res

sumList :: [] Int -> Int
sumList []         = 0
sumList (val:list) = val + sumList list

sumListFold :: [] Int -> Int
sumListFold list = foldList eF cF list
 where
  -- eF :: Int
  eF = 0
  -- cF :: Int -> Int -> Int
  cF val res = val + res

productList :: [] Int -> Int
productList []         = 1
productList (val:list) = val * productList list

productListFold :: [] Int -> Int
productListFold list = foldList eF cF list
 where
  -- eF :: Int
  eF = 1
  -- cF :: Int -> Int -> Int
  cF val res = val * res


foldListInt :: b -> (Int -> b -> b) -> [] Int -> b
foldListInt emptyF consF [] = emptyF
foldListInt emptyF consF (val:list) = consF val (foldListInt emptyF consF list)
--                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--                                                     :: b

foldList :: b -> (a -> b -> b) -> [] a -> b
foldList emptyF consF []         = emptyF
foldList emptyF consF (val:list) = consF val (foldList emptyF consF list)
--                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--                                                     :: b

{-
Intuitively,

  foldList elem f [1,2,3,4]
= foldList elem f (1 : (2 : (3 : (4 : []))))
= f 1 (f 2 (f 3 (f 4 elem)))
= (1 `f` (2 `f` (3 `f` (4 `f` elem))))

  foldList 1 (*) (1 : (2 : []))
=
  1 * (2 * 1)

-}

hasElemFold :: [] Int -> Int -> Bool
hasElemFold list elemToFind = foldList eF cF list
 where
  eF = False
  cF val res = (val == elemToFind) || res

{-

  foldList 1 (\val res -> val * res) [1,2]
= {- foldList-Definition, rule 2, with bindings  val ~> 1, list ~> [2]
                                        emptyF ~> 1, consF ~> \val res -> val * res -}
  (\val res -> val * res) 1 (foldList 1 (\val res -> val * res) [2])
= {- evaluate anonymous function, with bindings
            val ~> 1,
            res ~> (foldList 1 (\val res -> val * res) [2]) -}
  1 * (foldList 1 (\val res -> val * res) [2])
= {- foldList-Definition, rule 2, with bindings
                val ~> 2, list ~> [], emptyF ~> 1, consF ~> \val res -> val * res -}

  1 * ((\val res -> val * res) 2 (foldList 1 (\val res -> val * res) []))
= {- evaluate anonymous function, with bindings
            val ~> 2,
            res ~> (foldList 1 (\val res -> val * res) []) -}
  1 * (2 * (foldList 1 (\val res -> val * res) []))
= {- foldList-Definition. rule 1, with bindings
            emptyF ~> 1, consF ~> \val res -> val * res -}
  1 * (2 * 1)
= 1 * 2
= 2
-}

data List a where
  Nil  :: List a 
  Cons :: a ->  List a-> List a
  deriving Show

list1 :: List String
list1 = Cons "2123" Nil

take1:: Int -> [] a -> [] a
take1 _ []     = []
take1 0 _      = []
take1 n (x:xs) = x:take1 (n-1) xs 

listAppend :: [] a -> [] a -> [] a 
listAppend [] ys     = ys 
listAppend (x:xs) ys = x:listAppend xs ys

loop :: Int
loop = loop

data LeafLabeledTree a where 
  Leaf :: a -> LeafLabeledTree a
  Node :: LeafLabeledTree a -> LeafLabeledTree a -> LeafLabeledTree a 
  deriving Show 

makeTree :: LeafLabeledTree Int
makeTree =  Node (Node (Node (Leaf 1) (Leaf 2)) (Node (Leaf 3) (Leaf 4))) (Node (Node (Leaf 5) (Leaf 6)) (Node (Leaf 7) (Leaf 8)))


foldTree :: (a->b) -> (b ->b -> b) -> b -> LeafLabeledTree a -> b
foldTree fL fN vEmtyp (Leaf x) = (fL x) 
foldTree fL fN vEmtyp (Node left right) = fN (foldTree fL fN vEmtyp left) (foldTree fL fN vEmtyp right)

mapTree :: LeafLabeledTree Int -> [] Int
mapTree tree = foldTree fL sumFunction [] tree
 where 
   fL x = [x]
   sumFunction = (++)

sumTree :: LeafLabeledTree Int ->  Int
sumTree tree = foldTree id sumFunction 0 tree
 where 
   sumFunction = (+)


listToTree :: [] Int -> LeafLabeledTree Int
listToTree [] = error "need minimum two value"
listToTree [x] = (Leaf x)
listToTree (x:xs) = Node (Leaf x) (listToTree xs)

f:: Int -> Int
f x = x*2

t:: (a -> a) -> a -> a 
t f x = f ( f x )

t2:: (a -> a) -> (a -> a) 
t2 f x =  f (f x)

data Tree a b where
   Tip :: a-> Tree a b 
   Branch :: (Tree a b) -> b -> (Tree a b) -> Tree a b
   deriving Show

data1 :: Tree String () 
data1 = Branch (Tip "Hallo") () (Tip "Welt")


data2 :: Tree Int String
data2 = Branch (Tip 1) "String" (Tip 1)
