> {-# LANGUAGE GADTSyntax #-}

> module Functional.Exercise.Exercise1 where
>
> import Functional.Lecture.DataAndFunctions
> import Functional.Lecture.MoreData
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

1) Define two values of type `XYAxis`.

> xyAxis1 :: Coordinate
> xyAxis1 = XYAxis 31 123

> xyAxis2 :: Coordinate
> xyAxis2 = XYAxis 42 1337
    
2) Implement a function `eqDirection :: Direction -> Direction -> Bool` that yields `True` if the both arguments are the same and `False` otherwise.
   The data type `Bool` is predefined as follows in Haskell.

   ```
   data Bool where
     True  :: Bool
     False :: Bool
   ```

> eqDirection :: Direction -> Direction -> Bool
> eqDirection Up    Up    = True
> eqDirection Down  Down  = True
> eqDirection Left  Left  = True
> eqDirection Right Right = True

3) Implement a function `isVertical :: Direction -> Bool`. Such functions with result type `Bool` are often called predicates. The function shoud yield `True` for vertical direction and `False` otherwise.

4) Declare a data type for an imaginary token tile that might be moved on a coordination system. The data type `Token` should be an enumeration with at least four different nullary constructors. Also write a function `prettyToken :: Token -> String` that yields a pretty(!) string represetation for a token.

> data Token = Star | Circle | Block | Cross
>
> prettyToken :: Token -> String
> prettyToken Star   = "*"
> prettyToken Circle = "O"
> prettyToken Block  = "#"
> prettyToken Cross  = "+"
   
<<<<------ Exercises for lecture on Monday (2/12/19) ------>>>>

5) Given the following data type.

> data Type1 where
>   C1 :: Bool -> One -> Type1
>   C2 :: Direction -> Bool -> Type1

How many values of type `Type1` can you construct? Define a constant function for each of these values.

We can construct 10 different values of type `Type1`.

> tVal1 :: Type1
> tVal1 = C1 True OneC
>
> tVal2 :: Type1
> tVal2 = C1 False OneC
>
> tVal3 :: Type1
> tVal3 = C2 Right True
>
> tVal4 :: Type1
> tVal4 = C2 Left True
>
> tVal5 :: Type1
> tVal5 = C2 Up True
>
> tVal6 :: Type1
> tVal6 = C2 Down True
>
> tVal7 :: Type1
> tVal7 = C2 Right False
>
> tVal8 :: Type1
> tVal8 = C2 Left False
>
> tVal9 :: Type1
> tVal9 = C2 Up False
>
> tVal10 :: Type1
> tVal10 = C2 Down False
