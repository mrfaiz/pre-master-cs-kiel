{-# LANGUAGE GADTSyntax #-}

module Functional.Lecture.Poly where

{-

> data CoordMap where
>   EmptyC :: CoordMap
>   ACoord :: Coordinate -> CoordMap -> CoordMap

> data Row where
>   EmptyR :: Row
>   ARow   :: Token -> Row -> Row

> data Field where
>   EmptyF :: Field
>   AField :: Row -> Field -> Field

> data IntList where
>   Nil  :: IntList                           -- nil; nihil (nothing)
>   Cons :: Integer -> IntList -> IntList

-- type Field = [[Token]]

-}

data BoolList where
  EmptyB :: BoolList
  -- SingletonB :: Bool -> BoolList
  ABool :: Bool -> BoolList -> BoolList

-- here, `a` is type variable
-- similar to generics in Java     List<A>
data List a where
  Nil   :: List a
  Cons  :: a -> List a -> List a
 deriving Show
-- something like a "type function" (type constructor)
-- List :: TYPE -> TYPE
-- Bool :: TYPE
-- Integer :: TYPE

const43 :: Integer
const43 = 43

intList :: (List Integer)
intList = Cons 42 (Cons 12 Nil)

intList3 :: Integer -> (List Integer)
intList3 n = Cons n (Cons n (Cons n Nil))

boolList :: List Bool
boolList = Cons True (Cons False (Cons True Nil))

lengthList :: List a -> Integer
lengthList Nil             = 0
lengthList (Cons val list) = 1 + lengthList list

-- mapCoordMap   :: (Coordinate -> Coordinate) -> CoordMap -> CoordMap
-- mapList ::       (a          -> a         ) -> List a   -> List a

-- mapCoordToInt :: (Coordinate -> Integer)  -> CoordMap -> IntList
mapList ::        (a          -> b         ) -> List a   -> List b
mapList f Nil              = Nil
mapList f (Cons elem list) = Cons (f elem) (mapList f list)

-- mapList (\n -> even n) (Cons 13 intList)
-- (Cons 13 intList) :: List Integer
-- even :: Integer -> Bool

-- mapList :: (a -> b) -> List a -> List b
-- because of the usage of `Cons 13 intList`, I know the second argument needs to be
--  of type `List Integer`

-- mapList :: (a -> b) -> List a -> List b   { List a -> List Integer, a -> Integer }
-- mapList :: (Integer -> b) -> List Integer -> List b
-- because of the usage `\n -> even n`, I know the function we use as first argument
--  needs to be of type `Integer -> Bool`

-- mapList :: (Integer -> b) -> List Integer -> List b   { b -> Bool }
-- mapList :: (Integer -> Bool) -> List Integer -> List Bool

{-

λ> mapList (\b -> if b then 42 else 0) boolList
Cons 42 (Cons 0 (Cons 42 Nil))
λ> boolList
Cons True (Cons False (Cons True Nil))
λ> mapList (\n -> even n) intList
Cons True (Cons True Nil)
λ> intList
Cons 42 (Cons 12 Nil)
λ> mapList (\n -> even n) (Cons 13 intList)
Cons False (Cons True (Cons True Nil))

-}
-- can we have a even more generic type signature?
-- the only valid definition of `mapList2`
mapList2 :: (a          -> b         ) -> List c   -> List d
mapList2 fAtoB Nil               = Nil
mapList2 fAtoB (Cons cVal cList) = Nil
         -- fAtoB :: a -> b
         -- cVal  :: c
         -- cList :: List c

-- wrongList :: List Integer
-- wrongList = Cons False (Cons 42 Nil)
         -- ^^^^^^^^^^^^^^^^^^^^^^
         -- :: List Bool
         -- False :: Bool
         -- (Cons 42 Nil) :: List Bool   <- no, it's `List Integer`


-- filterCoordMap :: (Coordinate -> Bool) -> CoordMap -> CoordMap

filterList :: (a -> Bool) -> List a -> List a
filterList pred Nil = Nil
filterList pred (Cons elem list) = if pred elem
                                     then Cons elem (filterList pred list)
                                     else filterList pred list

--   filterList (\b -> b) (Cons True (Cons False (Cons True Nil)))
--   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- = if (\b -> b) True
--     then Cons True (filterList (\b -> b) (Cons False (Cons True Nil)))
--     else filterList (\b -> b) (Cons False (Cons True Nil))
-- = Cons True (filterList (\b -> b) (Cons False (Cons True Nil)))
--              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- = Cons True (if (\b -> b) False
--                then Cons False (filterList (\b -> b) (Cons True Nil))
--                else filterList (\b -> b) (Cons True Nil))
-- = Cons True (filterList (\b -> b) (Cons True Nil))
-- = Cons True (Cons True (filterList (\b -> b) Nil))
-- = Cons True (Cons True Nil)


{-
λ> filterList (\b -> b) boolList
Cons True (Cons True Nil)
λ> (\b -> b) 42
42
λ> (\b -> b) True
True
λ> (\b -> b) (Cons 42 Nil)
Cons 42 Nil
λ> even 42
True
λ> (\b x y -> if b then x else y) True 42 12
42
λ> (\b x y -> if b then x else y) False 42 12
12
λ> (\b -> b) False
False
λ> filterList (\n -> n > 12) intList
Cons 42 Nil
λ> intList
Cons 42 (Cons 12 Nil)

-}

-- In Haskell the list data type actually looks like the following
--
-- data [] a where
--  []  :: [] a                    -- like `Nil`
--  (:) :: a -> [] a -> [] a       -- like `Cons`

-- `map` (and `filter`) are also predefined in Haskell
-- map :: (a -> b) -> [] a -> [] b
-- map f [] = []
-- map f ((:) elem list) = (:) (f elem) (map f list)
-- map f (elem : list) = (f elem) : (map f list)

-- also allowed, instead of writing `[] a`, we can write `[a]`
-- map :: (a -> b) -> [a] -> [b]

-- Cons True (Cons True (Cons False Nil))  :: List Bool
-- True : (True : (False : []))                :: [] Bool
-- [True, True, False]

-- data Coordinate where
--  XYAxis :: Integer -> Integer -> Coordinate
--
-- xCoord :: Coordinate -> Integer
-- xCoord (XYAxis x y) = x
--
-- yCoord :: Coordinate -> Integer
-- yCoord (XYAxis x y) = y


-- predefined in Haskell
--
-- data (,) a b where
--  (,) :: a -> b -> (,) a b
--
-- (,) :: TYPE -> TYPE -> TYPE

-- I can also write it `(a,b)` instead of `(,) a b`   (on type-level)
-- I can also write `(True, 42)` insteaf of `(,) True 42`   (on value-level)

type Coordinate = (,) Integer Integer
type CoordMap = [Coordinate]
-- `token` is a type variable
type Field token = [[token]]
-- Field :: TYPE -> TYPE

-- fst :: (a,b) -> a
-- fst (x,y) = x
--
-- snd :: (a,b) -> b
-- snd (x,y) = y

-- predefined in Haskell
--
-- data Either a b where
--   Left  :: a -> Either a b
--   Right :: b -> Either a b

intOrBool1 :: Either Integer Bool
intOrBool1 = Left 42

intOrBool2 :: Either Integer Bool
intOrBool2 = Right True
