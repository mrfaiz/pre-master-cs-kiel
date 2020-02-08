> {-# LANGUAGE GADTSyntax #-}
>
> module Functional.Lecture.Folding where
>
> import Functional.Lecture.DataAndFunctions
> import Functional.Lecture.Recursion

 # Folding function

The last remaining functions `countCoordMap` and `hasCoord` we have seen in the lecture can be generalised as well.

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
    Intuitively, we replace all occurrences of the constructors of the type to fold by functions.
    Here, we have two arguments that determine how to behave in case we see a specific constructor and we need to know how to behave for each of the constructors that might occur.
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


We can generalise the above folding functions by using type variables: instead of having a function that folds a `CoordMap` into a `Bool` as well as one that folds into an `Integer`, we can define a more general function that folds a `CoordMap` to an arbitrary type `b`.

That is, we want to define a function `CoordMap -> b`, so we need to consider the following subsitutions based on the constructors of `CoordMap`.

The substitution
    CoordMap { CoordMap |-> b }
yields
    Bool
and the substitution
    Coordinate -> CoordMap -> CoordMap { CoordMap |-> b }
yields
    Coordinate -> b -> b.

Again, adding these functions to the type signature yields the final type of `foldCoord`.

> foldCoord :: b -> (Coordinate -> b -> b) -> CoordMap -> b
> foldCoord vEmpty fACoord EmptyC = vEmpty
> foldCoord vEmpty fACoord (ACoord coord cm) = fACoord coord (foldCoord vEmpty fACoord cm)

Last but not least, we observe that the functions `foldCoordToInt` and `foldCoordToBool` are specialisations of `foldCoord`.

     > foldCoordToInt :: Integer -> (Coordinate -> Integer -> Integer) -> CoordMap -> Integer
     > foldCoordToInt vEmpty fACoord cm = foldCoord vEmpty fACoord cm

     > foldCoordToBool :: Bool -> (Coordinate -> Bool -> Bool) -> CoordMap -> Bool
     > foldCoordToBool vEmpty fACoord cm = foldCoord vEmpty fACoord cm
