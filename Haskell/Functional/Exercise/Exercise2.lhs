> {-# LANGUAGE GADTSyntax #-}

> module Functional.Exercise.Exercise2 where
>
> import qualified Functional.Lecture.DataAndFunctions    as Data
> import qualified Functional.Lecture.MoreData            as Data
> import           Functional.Lecture.FunctionDefinitions

We implemented the following type synonym for a `Integer`-bound.

    type Bounds = (Integer,Integer)
          
1) Implement a function `moveWithinBounds` that yields a coordinate based on a given bound, direction and coordinate. The new coordinate differs from the given coordinate in the y-component (or x-component) with respect to the given direction. If the resulting change in that component does not adhere with the given bounds, the new coordinate is identical to the given one.

> moveWithinBounds :: Data.Bounds -> Data.Bounds -> Data.Direction -> Data.Coordinate -> Data.Coordinate
> moveWithinBounds xBounds yBounds dir coords = error "moveWithingBounds: Implement me"

2) Evaluate the following expression step-by-step, specifying the demanded argument as well as the applied rule as done in the lecture, for the constant function `boolEx4`.

    ```
    boolEx4 = False && (True || True)
    ```

    boolEx4
    ^^^^^^^
  = <FILL IN STEPS HERE>

3) Consider the following `Bool`ean expressions in Haskell. Note that the operator `(==>)` is defined in the lecture notes.

   
   a) True || False && True ==> not False
   b) False ==> True ==> True
   c) False && True ==> True || False ==> True || not False

   A) Give the fully parenthesised versions of the following `Bool`ean expressions in Haskell with respect to their precedences.
   B) Give the prefix version for each expression: that is, execlusively use the prefix notation for function applications.
   
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

   Can you give an alternative implementation (or choose one from the lecture) that will terminate for one of the example that won't terminate for `impl`?

<<<------------- Exercises corresponding to lecture on 9/12/19 ------------->>>
   
5) Implement a function `prettyField` that prints each `Row` of the field in one line seperated by one whitespace,
     and the columns seperated by newlines.

    > prettyField :: Field -> String
    > prettyField = error "prettyField: Implement me!"

6) Last but not least, we want to implement a function that generates a field with respect to the given bounds
     for the x- as well as y-axis; all positions should be filled with the given token.

    > fieldWithBounds :: Bounds -> Bounds -> Token -> Field
    > fieldWithBounds (minX, maxX) (minY, maxY) t = error "fieldWithBounds: Implement me"
