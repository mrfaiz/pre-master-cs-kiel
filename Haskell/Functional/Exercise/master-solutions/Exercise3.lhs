> {-# LANGUAGE GADTSyntax #-}
>
> module Functional.Exercise.Exercise3 where
>
> import Functional.Lecture.Recursion
> import qualified Functional.Exercise.Exercise2 as Ex
        
1) Given the following function definitions, give an equivalent definition using lambda functions.

> func1 :: Bool -> Integer -> Integer -> Integer
> func1 b n m = if not b then n else m
>
> func2 :: Integer -> Integer
> func2 n = n + n
>
> func3 :: Integer -> Integer -> Integer
> func3 n m = n + m * m

> func1Lambda :: Bool -> Integer -> Integer -> Integer
> func1Lambda = \ b n m -> if not b then n else m
>
> func2Lambda :: Integer -> Integer
> func2Lambda = \ n -> n + n
>
> func3Lambda :: Integer -> Integer -> Integer
> func3Lambda = \ n m -> n + m * m

For example, for the function

> func :: Integer -> Bool -> Integer
> func n b = if b then n else 42

an equivalent definition using a lambda function looks as follows.

> funcLambda :: Integer -> Bool -> Integer
> funcLambda = \n b -> if b then n else 42

2) Given the `IntList` type from the lecture notes about "Recursion".

    data IntList where
      Nil  :: IntList
      Cons :: Integer -> IntList -> IntList

   Define the following higher-order functions `mapList` and `filterList` that follow the same abstraction pattern as the functions we defined for `CoordMap` in the lecture.

> mapList :: (Integer -> Integer) -> IntList -> IntList
> mapList f Nil = Nil
> mapList f (Cons i list) = Cons (f i) (mapList f list)
>
> filterList :: (Integer -> Bool) -> IntList -> IntList
> filterList p Nil = Nil
> filterList p (Cons i list) = if p i then Cons i (filterList p list) else filterList p list
  
3) Using these definitions of `mapList` and `filterList`, define the following functions that increment all `Integer` values of a given `IntList` and keep the `Integer`-values that are greater than 5, respectively.

> incList :: IntList -> IntList
> incList iList = mapList func iList
>  where func x = x + 1

> greater5List :: IntList -> IntList
> greater5List iList = filterList pred iList
>  where pred x = x > 5

The functions should behave as follows.

    > incList (Cons 1 (Cons 2 (Cons 3 Nil)))
    Cons 2 (Cons 3 (Cons 4 Nil))
    > greater5List (Cons 2 (Cons 12 (Cons 5 Nil))
    Cons 12 Nil

In a second step use lambda functions instead of a local function definition.

> incList' :: IntList -> IntList
> incList' iList = mapList (\x -> x + 1) iList

> greater5List' :: IntList -> IntList
> greater5List' iList = filterList (\x -> x > 5) iList

4) Given the `Field` data type from the last exercises.

    data Token where
      Blank :: Token
      Block :: Token
                                   
    data Row where
      EmptyR :: Row
      ARow   :: Token -> Row -> Row

    data Field where
      EmptyF :: Field
      AField :: Row -> Field -> Field

We implemented functions `replaceTokenInRow` and `replaceTokenInField`. Reimplement these functions using the higher-order helper functions `mapRow` and `mapField`. In order to avoid name clashes we imported the corresponding module qualified by using `Ex`.

> mapRow :: (Ex.Token -> Ex.Token) -> Ex.Row -> Ex.Row
> mapRow f Ex.EmptyR = Ex.EmptyR
> mapRow f (Ex.ARow t row) = Ex.ARow (f t) (mapRow f row)
>
> mapField :: (Ex.Row -> Ex.Row) -> Ex.Field -> Ex.Field
> mapField f Ex.EmptyF = Ex.EmptyF
> mapField f (Ex.AField row field) = Ex.AField (f row) (mapField f field)
>
> replaceTokenInRow :: Ex.Token -> Ex.Row -> Ex.Row
> replaceTokenInRow tok row = mapRow (\_ -> tok) row
>
> replaceTokenInField :: Ex.Token -> Ex.Field -> Ex.Field
> replaceTokenInField tok field = mapField (\row -> replaceTokenInRow tok row) field

<<<------------- Exercises corresponding to lecture on 16/12/19 ------------->>>

5) Now that we know about polymorphic structures, let us redefine the `Field` type as follows.

> -- type Field token = [[token]]
> type Field token = [] ([] token)

Here, instead of reusing the `Token`s defined in the last exercise, we use a type parameter in order to use the type synonym `Field` with abritrary values.
Reimplement the function `replaceTokenInField` once more using the predefined higher-order function `map` that works an arbitrary lists; note that for this concrete example, we reuse `Ex.Token`.

> replaceToken :: Ex.Token -> Field Ex.Token -> Field Ex.Token
> replaceToken tok field = map (\row -> map (\t -> tok) row) field

6) We also redefined `CoordMap` using polymorphic lists and pairs.

> -- type Coord  = (Int,Int)
> type Coord = (,) Int Int
> -- type Coords = [Coord]
> type Coords = [] Coord

Based on this type synonym we define a type to represent `Coordinate`s as keys and arbitrary tokens as values in order to describe the positions of such tokens. A list of such pairs describes a figure.

> -- type Figure token = [(Coord, token)]
> type Figure token = [] ((,) Coord token)

Here, we again use a type parameter `token` to use `Figure` with an abitrary type.
Using this type, we can visualise, for example, the following figure.

> exFigure1 :: Figure Ex.Token
> exFigure1 = [ ((2,1), Ex.Block), ((2,5), Ex.Block), ((3,2), Ex.Block), ((3,4), Ex.Block)
>             , ((4,3), Ex.Block), ((5,2), Ex.Block), ((6,1), Ex.Block) ]

   5 |  #
   4 |    # 
   3 |      #
   2 |    #   #
   1 |  #       #
      _ _ _ _ _ _
      1 2 3 4 5 6

Define a function `lookupCoord` that checks if a given figure contains the specific coordinate: if yes the function should yield the associated token and `Nothing` otherwise.

> lookupCoord :: Coord -> Figure token -> Maybe token
> lookupCoord coord ((figCoord,tok) : figs) = if coord == figCoord then Just tok else lookupCoord coord figs

7) Define a function `blocks` that yields a figure with only `Ex.Block`-values at the coordinates given as first argument.

> blocks :: Coords -> Figure Ex.Token
> blocks coords = map (\coord -> (coord,Ex.Block)) coords

Using this function we can redefined `exFigure1` as follows.

> exFigure1' = blocks [(2,1), (2,5), (3,2), (3,4), (4,3), (5,2), (6,1)]
