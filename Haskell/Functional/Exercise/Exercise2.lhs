> {-# LANGUAGE GADTSyntax #-}

> module Functional.Exercise.Exercise2 where
>
> import qualified Functional.Lecture.DataAndFunctions    as Data
> import qualified Functional.Lecture.MoreData            as Data
> import           Functional.Lecture.FunctionDefinitions as Data

We implemented the following type synonym for a `Integer`-bound.

    type Bounds = (Integer,Integer)
          
1) Implement a function `moveWithinBounds` that yields a coordinate based on a given bound, direction and coordinate. The new coordinate changes by one unit (that is, plus 1 or minus 1) from the given coordinate in the y-component (or x-component) with respect to the given direction. If the resulting change in that component does not adhere with the given bounds, the new coordinate is identical to the given one.

example : moveWithinBounds (50,-50) (50,-50) Data.Up (Data.XYAxis 15 16)

> checkIfCoordIsInBounds ::  Data.Bounds -> Data.Bounds -> Data.Coordinate -> Bool
> checkIfCoordIsInBounds (xMax, xMin) (yMax, yMin) (Data.XYAxis x y) = if (((x <= xMax) && (x >= xMin)) && ((y <= yMax) && (y >= yMin))) then True else False

> moveWithinBounds :: Data.Bounds -> Data.Bounds -> Data.Direction -> Data.Coordinate -> Data.Coordinate
> moveWithinBounds (xMax, xMin) (yMax, yMin) dir (Data.XYAxis x y) = 
>    if (checkIfCoordIsInBounds (xMax, xMin) (yMax, yMin) (Data.moveByDirection dir (Data.XYAxis x y)))
>      then (Data.moveByDirection dir (Data.XYAxis x y)) 
>      else (Data.XYAxis x y)

2) Evaluate the following expression step-by-step, specifying the demanded argument as well as the applied rule as done in the lecture, for the constant function `boolEx4`.

    ```
    boolEx4 = False && (True || True)
    ```

    boolEx4
    ^^^^^^^
    = { definition of `boolEx4` }
      False && (True || True)
   = { definition of `(&&)`: second rule `False` with `_` bound to `False` }
      False

3) Consider the following `Bool`ean expressions in Haskell. Note that the operator `(==>)` is defined in the lecture notes.

   
   a) True || False && True ==> not False
   b) False ==> True ==> True
   c) False && True ==> True || False ==> True || not False

   A) Give the fully parenthesised versions of the following `Bool`ean expressions in Haskell with respect to their precedences.
   B) Give the prefix version for each expression: that is, execlusively use the prefix notation for function applications.
   
   parentheised version
   ~~~~~~~~~~~~~~~~~~~~
   a) (True || (False && True)) ==> (not False)   : True
   b) False ==> (True ==> True) : True
   c) (False && True) ==> ((True || False) ==> (True || (not False)))  : True

   prefix notation
   ~~~~~~~~~~~~~~~
    a) (==>) (True || (False && True)) (not False)
    b) (==>) False  ((==>)True True)
    c) (==>) (False && True) ((==>) (True || False)  (True || (not False))) 

4) Given the following definition of an implication on Boolean values as well as a non-terminating constant `boolLoop`

 impl :: Bool -> Bool -> Bool
 impl True  True  = True
 impl True  False = False
 impl False _     = True

> impl :: Bool -> Bool -> Bool
> impl True  x  = x
> impl False _  = True

> boolLoop :: Bool
> boolLoop = boolLoop
  
   ```

   which of the following expression will terminate, which of them won't? Try to explain why this is the case.

   a) impl (impl (False && True) False) boolLoop
   b) boolLoop ==> True
   c) False ==> boolLoop

   Explanation
   ~~~~~~~~~~~
   a) impl (impl (False && True) False) boolLoop
   b) boolLoop ==> True
   c) False ==> boolLoop

   Can you give an alternative implementation (or choose one from the lecture) that will terminate for one of the example that won't terminate for `impl`?
  
  c) False ==> boolLoop

<<<------------- Exercises corresponding to lecture on 9/12/19 ------------->>>

First we define a data type for `Token`s as follows.

> data Token where
>   Blank :: Token
>   Block :: Token
>   deriving (Show, Eq)
                                        
Consider now the following data type that is a list-like structure like we have seen for `CoordMap` but for `Token`.

> data Row where
>   EmptyR :: Row
>   ARow   :: Token -> Row -> Row
>   deriving Show

> valueRow :: Row
> valueRow = ARow Blank (ARow Block (ARow Block EmptyR))

> rowValue5 :: Row
> rowValue5 = ARow Blank (ARow Block (ARow Block (ARow Blank (ARow Block EmptyR))))

5) Implement a function `prettyRow` that prints each `Token` of the row seperated by one whitespace.

> prettyRow :: Row -> String
> prettyRow EmptyR = " "
> prettyRow (ARow Blank next) = "b " ++ prettyRow next
> prettyRow (ARow Block next) = "blk " ++ prettyRow next

> prettyRowCase :: Row -> String
> prettyRowCase EmptyR = " "
> prettyRowCase (ARow tkn nextRow) = case tkn of 
>                                     Blank -> "Blank" ++ (prettyRowCase nextRow)
>                                     Block -> "Block" ++ (prettyRowCase nextRow)

On top of these rows, we define a data type `Field` that consists of none or several `Row`s.

--ARow   :: Token -> Row -> Row

> data Field where
>   EmptyF :: Field
>   AField :: Row -> Field -> Field
>   deriving Show

> fieldValue1 :: Field
> fieldValue1 = EmptyF 

> fieldValue2 :: Field
> fieldValue2 = AField rowValue5 fieldValue1

> fieldValue3 :: Field
> fieldValue3 = AField rowValue5 fieldValue1

> fieldValue6 :: Field
> fieldValue6 = AField (ARow Blank rowValue5) fieldValue2

 fieldValue = AField (ARow Blank (ARow Block ( ARow Block (ARow Blank EmptyR)))) (AField (ARow Blank (ARow Block EmptyR)) EmptyF)

6) Next we want to implement a function that replaces all `Token` that match the first argument with a `Blank`.
     Define this functionality for `Row` first and then for `Field`; reuse the function for `Row` for the latter!

> replaceTokenInRow :: Token -> Row -> Row
> replaceTokenInRow _ EmptyR = EmptyR
> replaceTokenInRow Blank row = row
> replaceTokenInRow Block (ARow _ row) = ARow Blank (replaceTokenInRow Block row)

 replaceTokenInRow Block (ARow Blank row) = replaceTokenInRow Block row
 
  
  if 1 ==  1
     then (ARow tkn2 (replaceTokenInRow iToken nextRow))
     else (replaceTokenInRow iToken nextRow)
AField :: Row -> Field -> Field

> replaceTokenInField :: Token -> Field -> Field
> replaceTokenInField _ EmptyF = EmptyF
> replaceTokenInField Blank field = field
> replaceTokenInField Block (AField row field) = AField (replaceTokenInRow Block row) (replaceTokenInField Block field)

replaceTokenInField Block (AField (ARow _ row) field) = AField (ARow Blank (replaceTokenInRow Block row)) replaceTokenInField 


replaceTokenInField Block (AField (ARow _ row) field) = AField (ARow Blank replaceTokenInRow (Block row)) replaceTokenInField (ARow Blank replaceTokenInRow (Block row) field)

replaceTokenInField = error "replaceTokenInField: Implement me!"

7) Last but not least, we want to implement a function to check if a field has a given token.

> eqToken :: Token -> Token -> Bool
> eqToken Blank Blank = True
> eqToken Block Block = True
> eqToken _ _         = False

> eqToken2 :: Token -> Token -> Bool
> eqToken2 t1 t2 = t1 == t2

> hasToken :: Token -> Field -> Bool
> hasToken _ EmptyF = False
> hasToken iToken (AField row nextField) = (hasTokenInRow iToken row) || (hasToken iToken nextField)

> hasTokenInRow :: Token -> Row -> Bool
> hasTokenInRow _ EmptyR = False
> hasTokenInRow token (ARow tk nextRow) = (eqToken token tk) || (hasTokenInRow token nextRow)
