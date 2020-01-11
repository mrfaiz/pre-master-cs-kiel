> {-# LANGUAGE GADTSyntax #-}
>
> module Functional.Lecture.HigherOrder where
>
> import Functional.Lecture.DataAndFunctions
> import Functional.Lecture.Recursion

 # Higher-Order functions
  
In the last lecture we defined a function `filterXCoord` that takes a `CoordMap` and keeps specific `Coordinate` values with respect to the given first argument.

    > filterXCoord :: Integer -> CoordMap -> CoordMap
    > filterXCoord xCoord EmptyC            = EmptyC
    > filterXCoord xCoord (ACoord (XYAxis xCoord2 yCoord2) cm) =
    >   if xCoord == xCoord2
    >      then ACoord (XYAxis xCoord2 yCoord2) (filterXCoord xCoord cm)
    >      else filterXCoord xCoord cm

There are more similar functions that might be useful to define.
    For example, we can also discard and keep `Coordinate`s based on their y-component.

> filterYCoord :: Integer -> CoordMap -> CoordMap
> filterYCoord yCoord EmptyC                               = EmptyC
> filterYCoord yCoord (ACoord (XYAxis xCoord2 yCoord2) cm) =
>   if yCoord == yCoord2
>      then ACoord (XYAxis xCoord2 yCoord2) (filterYCoord yCoord cm)
>      else filterYCoord yCoord cm

Instead of filtering some of the `Coordinate`s, we can add a value to the x-component, y-component or both.

> incXCoord :: Integer -> CoordMap -> CoordMap
> incXCoord incX EmptyC                             = EmptyC
> incXCoord incX (ACoord (XYAxis xCoord yCoord) cm) =
>   ACoord (XYAxis (xCoord + incX) yCoord) (incXCoord incX cm)
>
> incYCoord :: Integer -> CoordMap -> CoordMap
> incYCoord incY EmptyC                             = EmptyC
> incYCoord incY (ACoord (XYAxis xCoord yCoord) cm) =
>   ACoord (XYAxis xCoord (yCoord + incY)) (incYCoord incY cm)
>
> incCoord :: Integer -> Integer -> CoordMap -> CoordMap
> incCoord incX incY EmptyC                             = EmptyC
> incCoord incX incY (ACoord (XYAxis xCoord yCoord) cm) =
>   ACoord (XYAxis (xCoord + incX) (yCoord + incY)) (incCoord incX incY cm)

Of course, we can define functions to decrease the coordinate components analogue.

> decXCoord :: Integer -> CoordMap -> CoordMap
> decXCoord decX EmptyC                             = EmptyC
> decXCoord decX (ACoord (XYAxis xCoord yCoord) cm) =
>   ACoord (XYAxis (xCoord - decX) yCoord) (decXCoord decX cm)
>
> decYCoord :: Integer -> CoordMap -> CoordMap
> decYCoord decY EmptyC                             = EmptyC
> decYCoord decY (ACoord (XYAxis xCoord yCoord) cm) =
>   ACoord (XYAxis xCoord (yCoord - decY)) (decYCoord decY cm)
>
> decCoord :: Integer -> Integer -> CoordMap -> CoordMap
> decCoord decX decY EmptyC                             = EmptyC
> decCoord decX decY (ACoord (XYAxis xCoord yCoord) cm) =
>   ACoord (XYAxis (xCoord - decX) (yCoord - decY)) (decCoord decX decY cm)

All these 6 function definitions look quite a like.
    We can highlight these similiarities even more by defining the following functions...

> incXY :: Integer -> Integer -> Coordinate -> Coordinate
> incXY incX incY (XYAxis xCoord yCoord) = XYAxis (xCoord + incX) (yCoord + incY)
>
> decXY :: Integer -> Integer -> Coordinate -> Coordinate
> decXY decX decY (XYAxis xCoord yCoord) = XYAxis (xCoord - decX) (yCoord - decY)

...and refactor the above definitions using these functions instead.

> incXCoord' :: Integer -> CoordMap -> CoordMap
> incXCoord' incX EmptyC            = EmptyC
> incXCoord' incX (ACoord coord cm) = ACoord (incXY incX 0 coord) (incXCoord' incX cm)
>
> incYCoord' :: Integer -> CoordMap -> CoordMap
> incYCoord' incY EmptyC            = EmptyC
> incYCoord' incY (ACoord coord cm) = ACoord (incXY 0 incY coord) (incYCoord' incY cm)
>
> incCoord' :: Integer -> Integer -> CoordMap -> CoordMap
> incCoord' incX incY EmptyC            = EmptyC
> incCoord' incX incY (ACoord coord cm) = ACoord (incXY incX incY coord) (incCoord' incX incY cm)
>
> decXCoord' :: Integer -> CoordMap -> CoordMap
> decXCoord' decX EmptyC            = EmptyC
> decXCoord' decX (ACoord coord cm) = ACoord (decXY decX 0 coord) (decXCoord' decX cm)
>
> decYCoord' :: Integer -> CoordMap -> CoordMap
> decYCoord' decY EmptyC            = EmptyC
> decYCoord' decY (ACoord coord cm) = ACoord (decXY 0 decY coord) (decYCoord' decY cm)
>
> decCoord' :: Integer -> Integer -> CoordMap -> CoordMap
> decCoord' decX decY EmptyC            = EmptyC
> decCoord' decX decY (ACoord coord cm) = ACoord (decXY decX decY coord) (decCoord' decX decY cm)


  ## Map function

We can do one additional step of refactoring: instead of defining the same schema again and again, we abstract the concrete function we use in all these definitions and add an additional functional argument instead.
   In Haskell, functions are so called _first class citizens_, that is, we can pass functions as arguments and yield functions as results the same as we are used to with other values, like `Bool`, `Integer`, `Coordinates` etc.
   The above schema is usually called a _map_ping function: we map the value the data structure contains to a new value, but keeping the general structure the same: that is, we have a function that traverses a `CoordMap` and finally yields a `CoordMap`.

> mapCoordMap :: (Coordinate -> Coordinate) -> CoordMap -> CoordMap
> mapCoordMap f EmptyC            = EmptyC
> mapCoordMap f (ACoord coord cm) = ACoord (f coord) (mapCoordMap f cm)

Here, the function we pass is of type `Coordinate -> Coordinate`, because `Coordinate`s are the values of the structure `CoordMap` that we want to map to different values.
    Using the function `mapCoordMap` we can refactor the above functions -- here, we'll do it for two of them.

> incCoordWithMap :: Integer -> Integer -> CoordMap -> CoordMap
> incCoordWithMap incX incY cm = mapCoordMap f cm
>  where
>   -- f :: Coordinate -> Coordinate
>   f coord = incXY incX incY coord
>
> decYCoordWithMap :: Integer -> CoordMap -> CoordMap
> decYCoordWithMap decY cm = mapCoordMap f cm
>  where
>   -- f :: Coordinate -> Coordinate
>   f coord = decXY 0 decY coord

We need to apply `mapCoordMap` to a function that describes the mapping for each value: each `Coordinate` is mapped to a new `Coordinate` using the same schema; the second argument is the `CoordMap`.
   In case of `incCoord`, we use the function `incXY` applied to the value `incX` and `incY` in order to increase each component fo the `Coordinate` by the given value.
   For `decYCoordWithMap` we pass `0`and `decY` as argument as we do not want to change the x-component.
   In order to illustrate that we pass a function as argument, the above definitions use a local function `f` that determines the behaviour.


 ## Filter function

Another prominent schema is the one we can abstract from the `filterX` and `filterY` example above.
    Thus, we define a more general function that takes the condition we use in order to decide, whether to keep or discard a `Coordinate`, as functional argument.
    A functional argument that yields a `Bool` as results is usually called a _predicate_.

> filterCoord :: (Coordinate -> Bool) -> CoordMap -> CoordMap
> filterCoord pred EmptyC = EmptyC
> filterCoord pred (ACoord coord cm) =
>   if pred coord
>     then ACoord coord (filterCoord pred cm)
>     else filterCoord pred cm

The general scheme becomes clear: based on the `Bool` that results from applying the predicate `pred` to a `Coordinate`, we decide whether to keep the `Coordinate` and traverse the remaining structure or to just traverse the remaining structure, discarding the current `Coordinate`.
    We can define `filterXCoord` and `filterYCoord` using `filterCoord` as follows.

> filterXCoordWithFilter :: Integer -> CoordMap -> CoordMap
> filterXCoordWithFilter xCoord cm = filterCoord pred cm
>  where
>   -- pred :: Coordinate -> Bool
>   pred (XYAxis xC yC) = xCoord == xC
>
> filterYCoordWithFilter :: Integer -> CoordMap -> CoordMap
> filterYCoordWithFilter yCoord cm = filterCoord pred cm
>  where
>   -- pred :: Coordinate -> Bool
>   pred (XYAxis xC yC) = yCoord == yC

Using these more general scheme, it becomes more natural to, for example, define a function that keeps all `Coordinate`s with x-components greater than 5.

> keepXGreaterThan5 :: CoordMap -> CoordMap
> keepXGreaterThan5 cm = filterCoord pred cm
>  where
>   -- pred :: Coordinate -> Bool
>   pred (XYAxis xCoord yCoord) = xCoord > 5

Instead of always defining a local function we can instead use _anonymous functions_ (also called _lambda functions_).

> filterXCoordWithFilterLambda :: Integer -> CoordMap -> CoordMap
> filterXCoordWithFilterLambda xCoord cm = filterCoord (\(XYAxis xC yC) -> xCoord == xC) cm
>
> filterYCoordWithFilterLambda :: Integer -> CoordMap -> CoordMap
> filterYCoordWithFilterLambda yCoord cm = filterCoord (\(XYAxis xC yC) -> yCoord == yC) cm
>
> keepXGreaterThan5Lambda :: CoordMap -> CoordMap
> keepXGreaterThan5Lambda cm = filterCoord (\(XYAxis xC yC) -> xC > 5) cm

> incCoordWithMapLambda :: Integer -> Integer -> CoordMap -> CoordMap
> incCoordWithMapLambda incX incY cm = mapCoordMap (\coord -> incXY incX incY coord) cm
>
> decYCoordWithMapLambda :: Integer -> CoordMap -> CoordMap
> decYCoordWithMapLambda decY cm = mapCoordMap (\coord -> decXY 0 decY coord) cm

Note that we can use lambda functions like ordinary functions; the following example uses a unary and binary lambda function, respectively, and applies it to the corresponding number of arguments.

     > (\x -> if x then 42 else 14) True
     42
     > (\x -> if x then 42 else 14) False
     14
     > (\x y -> if x then 42 else y) True 14
     42
     > (\x y -> if x then 42 else y) False 14
     14

Here we need to use parentheses for the lambda functions in order to explictely mark the end of the right-hand side of the function.
     Otherwise an expression like

     \x -> if x then 42 else 14 True

     reads as if we apply `14` to `True`, which, of course, makes no sense.
