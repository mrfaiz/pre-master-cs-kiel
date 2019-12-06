> {-# LANGUAGE GADTSyntax #-}

> module Functional.Exercise.Exercise1 where
>
> import qualified Functional.Lecture.DataAndFunctions as Data
> import qualified Functional.Lecture.MoreData         as Data


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

> xyAxis1 :: Data.Coordinate
> xyAxis1 = Data.XYAxis 10 10

> xyAxis2 :: Data.Coordinate
> xyAxis2 = Data.XYAxis 23 20
    
2) Implement a function `eqDirection :: Direction -> Direction -> Bool` that yields `True` if the both arguments are the same and `False` otherwise.
   The data type `Bool` is predefined as follows in Haskell.

   ```
   data Bool where
     True  :: Bool
     False :: Bool
   ```

> eqDirection :: Data.Direction -> Data.Direction -> Bool
> eqDirection Data.Up Data.Up = True
> eqDirection Data.Down Data.Down = True
> eqDirection Data.Left Data.Left = True
> eqDirection Data.Right Data.Right = True
> eqDirection _ _ = False

3) Implement a function `isVertical :: Direction -> Bool`. Such functions with result type `Bool` are often called predicates. The function shoud yield `True` for vertical direction and `False` otherwise.

> isVertical :: Data.Direction -> Bool
> isVertical Data.Up = True
> isVertical Data.Down = True
> isVertical _ = False

4) Declare a data type for an imaginary token tile that might be moved on a coordination system. The data type `Token` should be defined analogue to `Direction` defined in the lecture: the data type `Token` should have at least four different nullary constructors and can represent a total of four values only.
   Also write a function `prettyToken :: Token -> String` that yields a pretty(!) string representation for a token.
A
          *
        *   *
      *       *
   * * * * * * *
 *               *
*                  *
   
          *\n        *   *\n      *       *\n   * * * * * * *\n *               *\n*                    *

T
***********
    *         
    *                  
    *
    *

Z
* * * * * *
        *
      *
    *
  *
* * * * * *


E
* * * * * *
*
*
* * * * * *
*
*
* * * * * *

> data Token where -- Declare me!
>  A :: Token
>  E :: Token
>  T :: Token
>  Z :: Token 

> prettyToken :: Token -> String
> prettyToken A = "          *\n        *   *\n      *       *\n   * * * * * * *\n *               *\n*                 *"
> prettyToken T = "***********\n*         \n*                  \n*\n*"
> prettyToken E = "* * * * * *\n*\n*\n* * * * * *\n*\n*\n* * * * * *"
> prettyToken Z = "* * * * * *\n        *\n      *\n    *\n *\n* * * * * *";

5) Given the following data type.

> data Type1 where
>   C1 :: Bool -> Data.One -> Type1
>   C2 :: Data.Direction -> Bool -> Type1
>  deriving Show

How many values of type `Type1` can you construct? Define one constant function for each of these values.

> func :: Type1
> func = C1 True Data.OneC

> func2 :: Type1
> func2 False = C2 Data.Up True