> {-# LANGUAGE GADTSyntax #-}

> module Functional.Exercise.Exercise1 where
>
> import qualified Functional.Lecture.DataAndFunctions as Data
> import qualified Functional.Lecture.MoreData         as Data

> import Prelude hiding (Left, Right)

In the lecture on Monday (25/11/19) we have seen the following type for `Direction`s

    data Direction where
      Up    :: Direction
      Down  :: Direction
      Left  :: Direction
      Right :: Direction
     deriving Show

as well as for XY-coordinates.

   data Coordinate where
     XYAxis :: Integer -> Integer -> Coordinate
    deriving Show

Due to the _qualified import_ above, we can only use these types, constructors and associated functions with the prefix `Data.`.

1) Define two values of type `XYAxis`.

> xyAxis1 :: Coordinate
> xyAxis1 = XYAxis 10 20

> xyAxis2 :: Coordinate
> xyAxis2 = XYAxis 20 30
    
2) Implement a function `eqDirection :: Direction -> Direction -> Bool` that yields `True` if the both arguments are the same and `False` otherwise.
   The data type `Bool` is predefined as follows in Haskell.

   ```
   data Bool where
     True  :: Bool
     False :: Bool
   ```

> eqDirection :: Direction -> Direction -> Bool
> eqDirection  Up Up = True 
> eqDirection  Down Down = True
> eqDirection  Left Left = True 
> eqDirection  Right Right = True
> eqDirection  _ _ = False 
 

3) Implement a function `isVertical :: Direction -> Bool`. Such functions with result type `Bool` are often called predicates. The function shoud yield `True` for vertical direction and `False` otherwise.

> isVertical :: Direction -> Bool
> isVertical Up = True
> isVertical Down = True
> isVertical _ = False

4) Declare a data type for an imaginary token tile that might be moved on a coordination system. The data type `Token` should be defined analogue to `Direction` defined in the lecture: the data type `Token` should have at least four different nullary constructors and can represent a total of four values only.
   Also write a function `prettyToken :: Token -> String` that yields a pretty(!) string representation for a token.

Circle ::
  ..
.    .
.    .
  ..
Rectangle
--------
.      .
.      .
.      .
--------

> data Token where
>     Rectangle :: Token
>     Block :: Token
>     Circle :: Token
>     Triangle :: Token

5) Given the following data type.

> data Type1 where
>   C1 :: Bool -> Data.One -> Type1
>   C2 :: Data.Direction -> Bool -> Type1

How many values of type `Type1` can you construct? Define one constant function for each of these values.
> prettyToken :: Token -> String
> prettyToken Circle = "  ..\n.    .\n.    .\n  ..\n"
> prettyToken Rectangle = "\n--------\n.      .\n.      .\n.      .\n--------"

<<<<------ Exercises for lecture on Monday (2/12/19) ------>>>>

We implemented the following type synonym for a `Integer`-bound.

    type Bounds = (Int,Int)
          
5) Implement a function `moveWithinBounds` that yields a coordinate based on a given bound, direction and coordinate. The new coordinate differs from the given coordinate in the y-component (or x-component) with respect to the given direction. If the resulting change in that component does not adhere with the given bounds, the new coordinate is identical to the given one.

> moveWithinBounds :: Bounds -> Bounds -> Direction -> Coordinate -> Coordinate
> moveWithinBounds xBounds yBounds dir (XYAxis x y) =
>   error "moveWithinBounds: Implement me!"

6) Given the following data types.

> data Type1 where
>   C1 :: Bool -> One -> Type1
>   C2 :: Direction -> Bool -> Type1
>  deriving Show

> value1 :: Type1
> value1 = C1 True OneC

C1 False OneC
C2 Up True
C2 Up False
C2 Down True

> data Type2 a where
>   C21 :: a -> One -> Type2 a
>   C22 :: a -> Direction -> Type2 a

   a) How many values of type `Type1` can you construct?
   b) List all values of type `Type2 Bool`; how many values did you define?
   c) How many values of type `Type2 One` can you define?

7) The following data types are predefined in Haskell and are often called
    _sum type_ and _product type_. Which one is the _sum type_, which the
    _product type_ and why are they called like this?

    ```
    data Either a b where
      Left  :: a -> Either a b
      Right :: b -> Either a b

    data (,) a b where
      (,) :: a -> b -> (,) a b
    ```

