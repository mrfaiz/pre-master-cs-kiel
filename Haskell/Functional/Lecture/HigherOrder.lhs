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
  
 ## Folding function

The last remaining functions `countCoordMap` and `hasCoord` we have seen on Monday can be generalised as well, but for now only in a restricted way.

    > countCoordMap :: CoordMap -> Integer
    > countCoordMap EmptyC = 0
    > countCoordMap (ACoord _ cm) = 1 + countCoordMap cm
    
    > hasCoord :: Coordinate -> CoordMap -> Bool
    > hasCoord coord EmptyC              = False
    > hasCoord coord1 (ACoord coord2 cm) = eqCoordinate coord1 coord2 || hasCoord coord1 cm
    > 
    > eqCoordinate :: Coordinate -> Coordinate -> Bool
    > eqCoordinate (XYAxis x1 y1) (XYAxis x2 y2) = x1 == x2 && y1 == y2

The general scheme here is to traverse a `CoordMap` but instead of processing only the `Coordinate`s that occur within the structure, we yield a new structure (of potentially different type) that can take the structure of the original `CoordMap` as well as the `Coordinate`s occurring within the structure into account.
The following function is a general scheme to _fold_ a `CoordMap` into a `Bool` value.
  
> foldCoordToBool :: Bool -> (Coordinate -> Bool -> Bool) -> CoordMap -> Bool
> foldCoordToBool vEmpty fACoord EmptyC            = vEmpty
> foldCoordToBool vEmpty fACoord (ACoord coord cm) = fACoord coord (foldCoordToBool vEmpty fACoord cm)

The idea of a folding function is to abstract the recursive behaviour of functions like `hasCoord`: the function `foldCoordToBool` takes over the recursion that we otherwise implement again and again ourselves.
    Here, we have to arguments that determine how to behave in case we see a specific constructor and we need to know how to behave for each of the constructors that might occur.
    In case of `CoordMap` there are two different constructors that might occur.
    For the `EmptyC`-case we do not have any arguments that we need to consider, we only need to know which value of type `Bool` to yield: thus, we have an argument `vEmpty` that we use in case of the pattern `EmptyC`.
    In case of `ACoord` we have two arguments to consider: the coordinate `coord` and the remaining coordinates `cm`.
    That is, the function we supply to handle `ACoord` needs to handle the `Coordinate` that occurs as argument.
    The second argument of the funcction `fACoord` is, however, not of type `CoordMap` which resembles the second argument of the constructor.
    Instead we process the remaining `CoordMap` using a recursive call: we know that the function `foldCoordToBool` can transform a `CoordMap` into a `Bool`, so let's use this function to proceed.
    That is, the expression `foldCoordToBool vEmpty fACoord cm` yields a value of type `Bool`.
    Now the function `fACoord` comes into play again: the can apply the function to `coord` and the result of the recursive computation in order to yield the final `Bool`ean value.

    We can rearrange some code in the implementation of `hasCoord` and `foldCoordToBool` in order to reveal their resemblence as well as the general scheme of a folding function like `foldCoordToBool`.

    > hasCoord :: Coordinate -> CoordMap -> Bool
    > hasCoord coord EmptyC              = False
    > hasCoord coord1 (ACoord coord2 cm) = eqCoordinate coord1 coord2 || recResult
    >  where recResult = hasCoord coord1 cm

    > foldCoordToBool :: Bool -> (Coordinate -> Bool -> Bool) -> CoordMap -> Bool
    > foldCoordToBool vEmpty fACoord EmptyC            = vEmpty
    > foldCoordToBool vEmpty fACoord (ACoord coord cm) = fACoord coord recResult
    >  where recResult = foldCoordToBool vEmpty fACoord cm

Furthermore, we give a variant of `hasCoord` that uses the folding function.

> hasCoordWithFold :: Coordinate -> CoordMap -> Bool
> hasCoordWithFold coord1 cm = foldCoordToBool vEmpty fACoord cm
>  where
>    vEmpty                   = False
>    fACoord coord2 recResult = eqCoordinate coord1 coord2 || recResult

That is, instead of reimplementing the recursive behaviour ourselves, `foldCoordToBool` undertakes this task for us: we only need to specify how to handle the constructor `EmptyC` and how to process the `Coordinate` occurring in the `ACoord`-constructor as well as the recursive result that origins from processing the second argument of `ACoord`.
    
In case of folding a structure into a `Bool` (like above), we know that we want to have a function of type `CoordMap -> Bool`.

    foldCoordToBool ::                                         CoordMap -> Bool

The additional arguments needed to define such a folding function can be derived from the structure of `CoordMap`.
Recall the constructors of `CoordMap`.

    > :t EmptyC
    EmptyC :: CoordMap
    > :t ACoord
    ACoord :: Coordinate -> CoordMap -> CoordMap

If we want to define a folding function for a data type, we inspect the types of its constructors.
Since we want fold a `CoordMap` into a `Bool`, we need to supply functions that tell us how to behave in case we see one of these constructors.
That is, we supply an argument on how to behave in case of `EmptyC` and how to behave in case of `ACoord`.
In general, we just need to add the types of the constructors as functional arguments and replace all occurrences of type `CoordMap` with `Bool`, since we want to fold a `CoordMap` into a Bool.

The substitution
    CoordMap { CoordMap |-> Bool }
yields
    Bool
and the substitution
    Coordinate -> CoordMap -> CoordMap { CoordMap |-> Bool }
yields
    Coordinate -> Bool -> Bool.

Adding these functions to the type signature yields the final type of `foldCoordToBool`.

    foldCoordToBool :: Bool -> (Coordinate -> Bool -> Bool) -> CoordMap -> Bool


We can also define a function that _fold_s a `CoordMap` into an `Integer` value in order to refactor `countCoordMap`.

> foldCoordToInt :: Integer -> (Coordinate -> Integer -> Integer) -> CoordMap -> Integer
> foldCoordToInt vEmpty fACoord EmptyC            = vEmpty
> foldCoordToInt vEmpty fACoord (ACoord coord cm) = fACoord coord (foldCoordToInt vEmpty fACoord cm)
>
> countCoordMapWithFold :: CoordMap -> Integer
> countCoordMapWithFold cm = foldCoordToInt vEmpty fACoord cm
>  where
>   vEmpty      = 0
>   fACoord _ v = 1 + v
