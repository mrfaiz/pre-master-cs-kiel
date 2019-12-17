> {-# LANGUAGE GADTSyntax #-}

> module Functional.Lecture.Recursion where
>
> import           Functional.Lecture.DataAndFunctions

 # Recursion 101
    
In this lecture we want to mainly look in to recursive data types.
   However, before we start with recursive definitions of data types, we recap recursive function definitions as we haven't seen them in Haskell yet.
   Given the following formula we can sum up the first $n$ `Integer`-values.

> gaussSumFormula :: Integer -> Integer
> gaussSumFormula n = (n * (n+1)) `div` 2

When Gauss came up with this formula, he was tired of adding all the numbers individually.
    Without the formula, we would, for example, perform the following calculation for the first 5 numbers.

        5 + 4 + 3 + 2 + 1

    For the first 6 numbers it looks like follows.

        6 + 5 + 4 + 3 + 2 + 1

    And, hopefully without surprises, for 4 numbers it looks like follows.

        4 + 3 + 2 + 1

We observe that the schema for 4 numbers occurs in the schema for 5 numbers and both occur in the scheme for 6.
   The implementation that follows this intuitive schema, thus, is a recursive function!

> gaussSumRec :: Integer -> Integer
> gaussSumRec 0 = 0
> gaussSumRec n = n + gaussSumRec (n - 1)

The second rule of the definition is the recursive case: we add the number we are currently add to the result of the recursive call.
    The recursive call is then sum of all values for the given input value incremented by one.
    We can use `0` as base case, since we want to add up all numbers until we reach `1` and adding `0` does not do any harm, so we stop the recursion once we reach `0`.
    Thus, the first rule matches for `0` and yields `0` as result.
    Note that we do not handle negative input!
    We can overcome this issue by yielding `0` for all values that are smaller than `0` as follows.

> gaussSum :: Integer -> Integer
> gaussSum n = if n < 0 then 0 else gaussSumRec n


 # Recursive data types

We have seen some data types already that were either sum or product types or a mix of both.
   In addition to such types, we can also define recursive data types!
   That is, the type we're just defining is used as an argument of one of its constructors.
   One prominent example of such a recursive data types is a list-like structure.
   Consider the following data type a for list of `Integer` values.

> data IntList where
>   Nil  :: IntList
>   Cons :: Integer -> IntList -> IntList
>  deriving Show

The constructor `Nil` is a derived from the latin word _nihil_ that can be translated with _nothing_; that is, the `Nil`-constructor marks the end of the list.
    The second constructor, `Cons`, has two arguments: the first argument is the `Integer` value we store at the head-position of the list and the second argument represents the remaining list.
    That is, we can constructor the following exemplary values.

> aListEx1 :: IntList
> aListEx1 = Nil
>
> aListEx2 :: IntList
> aListEx2 = Cons 32 Nil
>
> aListEx3 :: IntList
> aListEx3 = Cons 32 (Cons 12 Nil)

Note that we use the constructor `Nil` in order to stop the construction of the `IntList`-value when us the `Cons`-constructor.
     Similar to the base case in the context of recursion function, we have a base constructor like `Nil` for recursive data types like `IntList`.
  
Building upon our exemplary data types from last week, we can define a data type that contains coordinates as follows.

> data CoordMap where
>   EmptyC :: CoordMap
>   ACoord :: Coordinate -> CoordMap -> CoordMap
>  deriving Show

While `EmptyC` is the base constructor that represents and empty structure, we use `ACoord` to add `Coordinate` in front of a `CoordMap`.
      Let's again define multiple exemplary values of type `CoordMap`.

> coordVal1 :: CoordMap
> coordVal1 = EmptyC
> 
> coordVal2 :: CoordMap
> coordVal2 = ACoord aCoordinate aCoordinateMap
>   where
>     -- aCoordinate :: Coordinate
>     aCoordinate    = XYAxis xCoord yCoord
>     -- xCoord :: Integer
>     xCoord         = 12
>     -- yCoord :: Integer
>     yCoord         = 43
>     -- aCoordinateMap :: CoordMap
>     aCoordinateMap = EmptyC
> 
> coordVal3 :: CoordMap
> coordVal3 = ACoord (XYAxis 12 43) EmptyC
> 
> coordVal4 :: CoordMap
> coordVal4 = ACoord (XYAxis 12 43) (ACoord (XYAxis 13 42) (ACoord (XYAxis 14 42) EmptyC))
> 
> coordVal5 :: CoordMap
> coordVal5 = ACoord (XYAxis 1 2) coordVal4

> coordVal6 :: CoordMap
> coordVal6 = ACoord (XYAxis 1 2) coordVal5

Here the definitions `coordVal2` and `coordVal3` represent the same value; the latter defines the value without any additional (constant) helper functions.

The next functions we based on `CoordMap` will traverse the whole structure; that is, due to the recursive nature of `CoordMap` these functions will be recursive as well.
    For example, we can define a function that counts the number of `Coordinate` values that occur in a `CoordMap`.
    In order to implement this functionality, we need to count the number of `ACoord`-constructors, as values of type `Coordinate` occur only in combination with that constructor.
    
> countCoordMap :: CoordMap -> Integer
> countCoordMap EmptyC = 0
> countCoordMap (ACoord _ cm) = 1 + countCoordMap cm

Since we want to count the number of `ACoord`-constructors, we yield `0` in case of `EmptyC`.
    Otherwise we need to add `1` for every `ACoord`-constructor we encounter when traversing the given `CoordMap`.
    In order to traver the whole structure, we make a recursive call on the second argument of `ACoord`, which is the remaining `CoordMap`.
    Note that we do not need to take into account how the `Coordinate` actually looks like (we ignore the first argument in case of `ACoord`).

Next, we define a function that checks if a given `CoordMap` contains a specific `Coordinate`.
      We yield `True` if we find the value and `False` otherwise.

> hasCoord :: Coordinate -> CoordMap -> Bool
> hasCoord coord EmptyC              = False
> hasCoord coord1 (ACoord coord2 cm) = eqCoordinate coord1 coord2 || hasCoord coord1 cm
>                                   -- (eqCoordinate coord1 coord2) || (hasCoord coord1 cm)

If the `Coordinate` we search for does not occur in the given `CoordMap`, we will traverse the whole structure and finally see the `EmptyC`.
    Thus, we yield `False` in cae of `EmptyC`.
    Moreover, in case of `ACoord coord2 cm` we do not traverse the remaining `CoordMap` `cm` if its first argument `coord2` is the coordinate we are searching for )`coord1`).
    Similar to the equality we defined for `Direction` in `Functional.Exercise.Exercise1`, we need a function to check if two `Coordinate`s are equal.
    Here, we can use the equality operator `(==)` on `Integer` values.

> eqCoordinate :: Coordinate -> Coordinate -> Bool
> eqCoordinate (XYAxis x1 y1) (XYAxis x2 y2) = x1 == x2 && y1 == y2
>                                           -- (x1 == x2) && (y1 == y2)

We can also define a function that traverses a `CoordMap` and decides (based on a condition), if the `Coordinate` should be kept or discarded.
    Here, we define `filterXCoord` that keeps all `Coordinate`s with x-coordinates that match the first argument.

> filterXCoord :: Integer -> CoordMap -> CoordMap
> filterXCoord xCoord EmptyC            = EmptyC
> filterXCoord xCoord (ACoord (XYAxis xCoord2 yCoord2) cm) =
>   if xCoord == xCoord2
>      then ACoord (XYAxis xCoord2 yCoord2) (filterXCoord xCoord cm)
>      else filterXCoord xCoord cm

Again, `EmptyC` is the base case, but we also have nothing to filter, because `EmptyC` does not hold any data.
    In the second rule we have a nested pattern match: we do not only match on `ACoord` but also on `XYAxis xCoord2 yCoord2` in order to gain access to `xCoord2`.
    Based on this value for the x-axis, we then check if it equivalent to the given value `xCoord`.
    If the x-coordinate is the value we are searching for, we construct a `CoordMap` that contains the entire `Coordinate`, that is, `XYAxis xCoord2 yCoord2` as first coordinate.
    The remaining `CoordMap` is given by a recursive call on the second argument of the input `ACoord`.
    I the check reveals that the x-coordinate does not match with the one we are looking for, we ignore the `Coordinate` completely and continue with the recursive call on the reamining `CoordMap` `cm`.

Hopefully, we have already observed that `ACoord` can be read as" add a `Coordinate` in front of `CoordMap`.
    We can, for example, define a function `addCoord11` that shows this behaviour in a more obvious way: it adds the `XYAxis 1 1` as `Coordinate` to the given `CoordMap`.

> addCoord11 :: CoordMap -> CoordMap
> addCoord11 cm = ACoord (XYAxis 1 1) cm

The function `addCoord11` basically uses the constructor `ACoord` to construct a new value based on the given `CoordMap` passes as argument.

If we, however, want to combine two `CoordMap`, we cannot solely used `ACoord` but need to define a recursive function to do the job.
   Let's define such a function `combineCoordMap` that takes two `CoordMap`s as arguments and yields a combined `CoordMap`.
   Intuitively, we want to combine these `CoordMap`s by putting all `Coordinate`s from the first input in front of the second input.

> combineCoordMap :: CoordMap -> CoordMap -> CoordMap
> combineCoordMap EmptyC             cm2 = cm2
> combineCoordMap (ACoord coord cm1) cm2 = ACoord coord (combineCoordMap cm1 cm2)

We defined the function via pattern matching over the first argument.
   In case of recursive data types like `CoordMap`, one often says that such a definition is "inductively on its first argument".
   Here, The function takes two `CoordMap`s as argument and recursively adds each `Coordinate` occurring in the first `CoordMap` to resulting `CoordMap` until the first `CoordMap` is `EmptyC`.

Let us take a look at the evaluation of exemplary call of `combineCoordMap` to get a better feeling for the implementation.

      combineCoordMap (ACoord (XYAxis 12 43) EmptyC) (ACoord (XYAxis 13 42) EmptyC)
    = {- second rule for `combineCoordMap` with bindings
             coord ~ (XYAxis 12 43) , m1 ~ EmptyC , and cm2 ~ (ACoord (XYAxis 13 42) EmptyC)
      -}
      ACoord (XYAxis 12 43) (combineCoordMap EmptyC (ACoord (XYAxis 13 42) EmptyC))
    = {- first rule for `combineCoordMap` with binding
             cm2 ~ (ACoord (XYAxis 13 42) EmptyC)
      -}
      ACoord (XYAxis 12 43) (ACoord (XYAxis 13 42) EmptyC)
