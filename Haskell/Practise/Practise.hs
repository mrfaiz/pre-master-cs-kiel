{-# LANGUAGE GADTSyntax #-}

module Functional.Practise.Practise where 

take2 :: Int -> [] a -> [] a
take2 0 _      = []
take2 _ []     = []
take2 n (x:xs) = x : take2 (n-1) xs

zip2 :: [] a -> [] b -> [] ((,) a b)
zip2 _ []          = []
zip2 [] _          = []
zip2 (x:xs) (y:ys) = (x,y): zip2 xs ys

fib :: Int -> Int
fib 0 = 1
fib 1 = 1 
fib n = fib (n-2) + fib (n-1)

---  Dyanamic Programmming 
---- factorial

fact :: Integer -> Integer
fact 0 = 1
fact 1 = 1
fact n = n * fact (n-1)

factMem :: Int -> Int
factMem n = factorials !! n

factorials :: [Int]
factorials = 0:1:2: map(\n -> n * factMem(n-1)) [3..]

fibM :: Int -> Integer
fibM n = fibs !! n

fibs :: [Integer]
fibs = 0: 1: map(\n -> fibM(n-2)+ fibM (n-1))[2..]


allFibNumbers :: Int -> [] Int
allFibNumbers n = help (-1)
 where
     help m = 
         if(n>0)
             then (
                 if (m==(n-1)) 
                     then [] 
                     else  (fib(m+1):(help (m+1))))
                     else []

combineWithInt :: [] a -> [] ((,) a Int)
combineWithInt list = help 0 list
 where 
     help n [] = []
     help n (x:xs) = (x,n): help (n+1) xs

makeList :: Int -> Int -> [] Int
makeList start end = if end>=start 
    then (start : makeList (start+1) end) 
    else []

makePowerlist :: [] Int
makePowerlist = makePowerlist' 0
 where
     makePowerlist' n = 2^n : makePowerlist' (n+1)

infiniteIntList :: [Int]
infiniteIntList = infiniteIntList' 0
 where
     infiniteIntList' n = n : infiniteIntList' (n+1)

indicesOfElemements :: [] Int -> Int -> [] Int
indicesOfElemements list elemToFind = indicesOfElemements' (zip2 list infiniteIntList)
 where
     indicesOfElemements' [] = []
     indicesOfElemements' ((value,index):xs) = if value == elemToFind then (index: indicesOfElemements' xs) else indicesOfElemements' xs

hasElement :: [] Int -> Int -> Bool
hasElement [] _ = False
hasElement (x:xs) elemToFind = (x == elemToFind) || (hasElement xs elemToFind)

gaussFormulaWithDynamicProgramming :: Int -> Int
gaussFormulaWithDynamicProgramming v = gaussFormulaWithDynamicProgramming' !! v

gaussFormulaWithDynamicProgramming' :: [Int]
gaussFormulaWithDynamicProgramming' = 0:map(\n -> (div (n*(n+1)) 2)) [1..]


data Tree a where
    Leaf :: a -> Tree a
    Node :: Tree a -> Tree a -> Tree a
    deriving Show

singleNode :: Tree Int
singleNode = Leaf 1

treeLeft :: Tree Int
treeLeft = Node (Node (Node (Leaf 1) (Leaf 2)) (Leaf 3)) ( Node (Leaf 4) (Leaf 5))

treeRight :: Tree Int
treeRight = Node (Node (Leaf 8) (Leaf 9)) (Node (Leaf 10)(Leaf 11))

tree :: Tree Int
tree = Node treeLeft treeRight

hasNode :: Tree Int -> Int -> Bool
hasNode (Leaf value) find = (if value==find then True else False)
hasNode (Node left right) find = (hasNode left find ) || (hasNode right find)

mapTree :: (a->b) -> Tree a -> Tree b 
mapTree fLeaf (Leaf value) = Leaf (fLeaf value)
mapTree fLeaf (Node left right) = Node (mapTree fLeaf left) (mapTree fLeaf right)

foldTree :: (a-> b) -> (b -> b -> b) -> Tree a -> b
foldTree fLeaf fNode (Leaf value) = fLeaf value
foldTree fLeaf fNode (Node left right) = fNode ( foldTree fLeaf fNode left) (foldTree fLeaf fNode right) 

sumTree :: Tree Int -> Int
sumTree t = foldTree id (\n m -> (n+m)) tree

makeArray :: Tree Int -> [Int]
makeArray t = foldTree fL fN t
 where 
     fL x = [x]
     fN = (++)

-- Gaurded function

gaurd1 :: Int -> Bool
gaurd1 n | even n = True
         | otherwise = False        

gaurd2AndOperation :: Bool -> Bool -> Bool
gaurd2AndOperation a b | a == b    = b 
                       | otherwise = False

gaurded3firstChar :: [Char] -> Char -> Bool
gaurded3firstChar (x:xc) c | x == c    = True
                           | otherwise = False

loop :: a 
loop = loop

loop2 = loop2

repeatData :: [Int]
repeatData = help 0
 where 
     help n = n : help (n+1)

const2 :: a -> (b -> a) 
const2  a = \_ -> a

add2 :: Int -> (Int -> Int) 
add2 x = (\y -> x+y)

odds :: [Int]
odds = help 0
 where 
     help  n = (2*n +1): help (n+1)

odds2 :: Int -> [Int]
odds2 n = map f [0..n-1]
 where 
     f x = 2*x +1

sum2 :: [Int] -> Int
sum2 [] = 0
sum2 (x:xs) = x + sum2 xs


nOdds :: Int -> [Int]
nOdds n = map(\x -> (2*x)+1) [0..n-1]

sum3 :: [Int] -> Int
sum3 = foldl (+) 0

{-
foldl :: Foldable t => (b -> a -> b) -> b -> t a -> b

foldl f initVal [] = foldedOutpurt
---------
Example foldl (\x y -> x+y) 1 [1,2,3]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
f (f (f 1 1) 2) 3)

foldr
^^^^
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
foldr f 0 [1,2,3]

f(1 (f 2 (f 3 0)))

-}

halve :: [a] -> ([a],[a]) 
halve [] = ([],[])
halve lst = (take (div (length lst) 2) lst , drop ( div (length lst) 2) lst)

--  (take (div (length l) 2) l , drop ( div (length l) 2) l)

take3rdElement :: [Int] -> Int
take3rdElement lst = head (tail (tail lst))

take3rdElement2 :: [Int] -> Int
take3rdElement2 lst = lst !! 2

safeTail :: [] Int -> [] Int
safeTail lst = if (length lst) == 0 then [] else (tail lst)

safeTail2 :: [] Int -> [Int]
safeTail2 lst | (length lst) == 0 = []
              | otherwise         = tail lst

firsts :: [(x,y)] -> [x]
firsts ps = [x | (x,_) <- ps]

factors :: Int -> [Int]
factors n = [x| x <- [1..n], (n `mod` x) == 0]

exponentiation :: Int -> Int -> Int
exponentiation _ 0 = 1
exponentiation b e = b * (exponentiation b (e-1))


decimalTobin :: Int -> [Int]
decimalTobin n = reverse (decimalTobin' n)
 where
     decimalTobin' :: Int -> [Int]
     decimalTobin' 0 = []
     decimalTobin' n = n `mod` 2 : decimalTobin' (div n 2)

bin2Dec :: [Int] -> Int
bin2Dec []     = 0
bin2Dec (x:xs) = x*(2^(length xs)) + bin2Dec xs

data List a where
    NoElem :: List a 
    OneMoreElem :: a -> List a -> List a 
    deriving Show

list1 :: List Int 
list1 = OneMoreElem 1 (OneMoreElem 2 (OneMoreElem 3 NoElem))

list2 :: List Int
list2 = OneMoreElem 3 (OneMoreElem 4 (OneMoreElem 5 NoElem))

prepend :: List a -> List a -> List a
prepend list1 NoElem                  = list1 
prepend list1 (OneMoreElem elm2 rest) = OneMoreElem elm2 (prepend list1 rest)