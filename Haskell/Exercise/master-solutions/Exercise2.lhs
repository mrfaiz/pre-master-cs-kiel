> {-# LANGUAGE GADTSyntax #-}

> module Functional.Exercise.Exercise2 where
>
> import qualified Functional.Lecture.DataAndFunctions    as Data
> import qualified Functional.Lecture.MoreData            as Data
> import           Functional.Lecture.FunctionDefinitions

We implemented the following type synonym for a `Integer`-bound.

    type Bounds = (Integer,Integer)
          
1) Implement a function `moveWithinBounds` that yields a coordinate based on a given bound, direction and coordinate. The new coordinate changes by one unit (that is, plus 1 or minus 1) from the given coordinate in the y-component (or x-component) with respect to the given direction. If the resulting change in that component does not adhere with the given bounds, the new coordinate is identical to the given one.

> moveWithinBounds :: Data.Bounds -> Data.Bounds -> Data.Direction -> Data.Coordinate -> Data.Coordinate
> moveWithinBounds xBounds yBounds dir coords =
>    if Data.xCoord newCoords `Data.inBounds` xBounds && Data.yCoord newCoords `Data.inBounds` yBounds
>      then newCoords
>      else coords
>  where newCoords = Data.moveByDirection dir coords

2) Evaluate the following expression step-by-step, specifying the demanded argument as well as the applied rule as done in the lecture, for the constant function `boolEx4`.

    ```
    boolEx4 = False && (True || True)
    ```

    boolEx4
    ^^^^^^^
  = { definition of `boolEx4`}
    False && (True || True)
    ^^^^^^^^^^^^^^^^^^^^^^^
  = { definition for `(&&)`: second rule without binding any variables }
    False


3) Consider the following `Bool`ean expressions in Haskell. Note that the operator `(==>)` is defined in the lecture notes.

   
   a) True || False && True ==> not False
   b) False ==> True ==> True
   c) False && True ==> True || False ==> True || not False

   A) Give the fully parenthesised versions of the following `Bool`ean expressions in Haskell with respect to their precedences.

   a) (True || (False && True)) ==> (not False)
   b) False ==> (True ==> True)
   c) (False && True) ==> ((True || False) ==> (True || (not False)))

   B) Give the prefix version for each expression: that is, execlusively use the prefix notation for function applications.

   a) (==>) ((||) True  ((&&) False True))  (not False)
   b) (==>) False ((==>) True True)
   c) (==>) ((&&) False True) ((==>) ((||) True False) ((||) True (not False)))

   
4) Given the following definition of an implication on Boolean values as well as a non-terminating constant `boolLoop`

   ```
   impl :: Bool -> Bool -> Bool
   impl True  True  = True
   impl True  False = False
   impl False _     = True

   boolLoop :: Bool
   boolLoop = boolLoop
   ```

   which of the following expression will terminate, which of them won't? Try to explain why this is the case.

   a) impl (impl (False && True) False) boolLoop
   b) boolLoop ==> True
   c) False ==> boolLoop

   a) won't terminate: first parameter evaluates to `True` and therefore the second argument needs to be evaluated
   b) won't terminate: first argument needs to be evaluated
   c) terminates: `imp` does not evaluate its second argument if the first argument is `False`


   Can you give an alternative implementation (or choose one from the lecture) that will terminate for one of the example that won't terminate for `impl`?

    ```
    impl :: Bool -> Bool -> Bool
    impl True x = x
    impl False_ = True
    ```

    Using this version of the implementation example a) terminates.

    ```
    impl :: Bool -> Bool -> Bool
    impl _ True  = True
    impl x False = not x
    ```

    With this version of `impl`, example b) terminates.


<<<------------- Exercises corresponding to lecture on 9/12/19 ------------->>>

First we define a data type for `Token`s as follows.

> data Token where
>   Blank :: Token
>   Block :: Token
                                        
Consider now the following data type that is a list-like structure like we have seen for `CoordMap` but for `Token`.

> data Row where
>   EmptyR :: Row
>   ARow   :: Token -> Row -> Row

5) Implement a function `prettyRow` that prints each `Token` of the row seperated by one whitespace.

> prettyRow EmptyR = ""
> prettyRow (ARow t rs) = prettyToken t ++ " " ++ prettyRow rs
>  where
>    prettyToken Blank = " "
>    prettyToken Block = "#"

On top of these rows, we define a data type `Field` that consists of none or several `Row`s.

> data Field where
>   EmptyF :: Field
>   AField :: Row -> Field -> Field

6) Next we want to implement a function that replaces all `Token` that match the first argument with a `Blank`.
     Define this functionality for `Row` first and then for `Field`; reuse the function for `Row` for the latter!

> replaceTokenInRow :: Token -> Row -> Row
> replaceTokenInRow t EmptyR = EmptyR
> replaceTokenInRow t (ARow _ row) = ARow t (replaceTokenInRow t row)

> replaceTokenInField :: Token -> Field -> Field
> replaceTokenInField t EmptyF = EmptyF
> replaceTokenInField t (AField row field) = AField (replaceTokenInRow t row) (replaceTokenInField t field)

7) Last but not least, we want to implement a function to check if a field has a given token.

> hasToken :: Token -> Field -> Bool
> hasToken t EmptyF = False
> hasToken t (AField row field) = hasTokenRow row || hasToken t field
>  where
>   hasTokenRow EmptyR = False
>   hasTokenRow (ARow tok row) = eqToken t tok || hasTokenRow row
>
> eqToken :: Token -> Token -> Bool
> eqToken Blank Blank = True
> eqToken Block Block = True
> eqToken _     _     = False

6) Implement a function `prettyField` that prints each `Row` of the field in one line seperated by one whitespace,
     and the columns seperated by newlines.

> prettyField :: Field -> String
> prettyField EmptyF = ""
> prettyField (AField rs f) = prettyRow rs ++ "\n" ++ prettyField f
     
7) Last but not least, we want to implement a function that generates a field with respect to the given bounds
     for the x- as well as y-axis; all positions should be filled with the given token.

> fieldWithBounds :: Data.Bounds -> Data.Bounds -> Token -> Field
> fieldWithBounds (minX, maxX) (minY, maxY) t =
>   repColumn (maxY - minY) (repRow (maxX - minX) t)
>  where
>    repColumn :: Integer -> Row -> Field
>    repColumn 0 v = EmptyF
>    repColumn n v = AField v (repColumn (n-1) v)
>    repRow :: Integer -> Token -> Row
>    repRow 0 v = EmptyR
>    repRow n v = ARow v (repRow (n-1) v)
