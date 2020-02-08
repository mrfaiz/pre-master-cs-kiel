{-# LANGUAGE GADTSyntax #-}

module Functional.Lecture.HO where

import qualified Functional.Lecture.DataAndFunctions as Data
import           Functional.Lecture.Recursion

{-
   moveByDirection :: Direction -> Coordinate -> Coordinate
   moveByDirection Down  (XYAxis x y) = XYAxis x (dec y)
   moveByDirection Up    (XYAxis x y) = XYAxis x (inc y)
   moveByDirection Left  (XYAxis x y) = XYAxis (dec x) y
   moveByDirection Right (XYAxis x y) = XYAxis (inc x) y
-}

moveByDirAndUnit :: Integer -> Data.Direction -> Data.Coordinate -> Data.Coordinate
moveByDirAndUnit stepUnit Data.Down  (Data.XYAxis x y) =  Data.XYAxis x (y - stepUnit)
moveByDirAndUnit stepUnit Data.Up    (Data.XYAxis x y) =  Data.XYAxis x (y + stepUnit)
moveByDirAndUnit stepUnit Data.Left  coord =  updateXCoordinateByUnit2 stepUnit coord
moveByDirAndUnit stepUnit Data.Right coord =  updateXCoordinateByUnit stepUnit coord

updateXCoordinateByUnit :: Integer -> Data.Coordinate -> Data.Coordinate
updateXCoordinateByUnit stepUnitX (Data.XYAxis x y) =  Data.XYAxis (x + stepUnitX) y

updateXCoordinateByUnit2 :: Integer -> Data.Coordinate -> Data.Coordinate
updateXCoordinateByUnit2 stepUnitX (Data.XYAxis x y) = Data.XYAxis (x - stepUnitX) y

data AddOrSub where
  Add :: AddOrSub
  Sub :: AddOrSub
  Mult :: AddOrSub

updateXCoordinateByUnitGen :: AddOrSub -> Integer -> Data.Coordinate -> Data.Coordinate
-- updateXCoordinateByUnitGen Add stepUnit (Data.XYAxis x y) =
--   Data.XYAxis (x + stepUnit) y
-- updateXCoordinateByUnitGen Sub stepUnit (Data.XYAxis x y) =
--   Data.XYAxis (x - stepUnit) y

updateXCoordinateByUnitGen addOrSub stepUnit (Data.XYAxis x y) = Data.XYAxis (newXValue addOrSub) y
 where newXValue Add  = x + stepUnit
       newXValue Sub  = x - stepUnit
       newXValue Mult = x * stepUnit

updateXCoordinateByUnitHO :: (Integer -> Integer) -> Data.Coordinate
                           -> Data.Coordinate
updateXCoordinateByUnitHO update (Data.XYAxis x y) =
  Data.XYAxis (update x) y
  --           update :: Integer -> Integer

usageEx1 :: Data.Coordinate
usageEx1 = updateXCoordinateByUnitHO updateFun (Data.XYAxis 14 25)
 where
   updateFun x = x + 42

usageEx2 :: Data.Coordinate
usageEx2 = updateXCoordinateByUnitHO updateFun (Data.XYAxis 14 25)
 where
   updateFun x = x - 42

usageEx3 :: Data.Coordinate
usageEx3 = updateXCoordinateByUnitHO updateFun (Data.XYAxis 14 25)
 where
   updateFun x = if x == 42 then 42 else x + 42

usageEx4 :: Data.Coordinate
usageEx4 = updateXCoordinateByUnitHO updateFun (Data.XYAxis 42 25)
 where
   updateFun x = if x == 42 then 42 else x + 42

-- let's use an "anonymous function" instead of a local function
--  defintion; sometimes we call these function "lambda functions"
usageEx5 :: Data.Coordinate
usageEx5 = updateXCoordinateByUnitHO
             (\ x -> if x == 42 then 42 else x + 42)
             -- x :: Integer
             (Data.XYAxis 42 25)

{-
 \
 / \
-}

updateCoordinate :: (Integer -> Integer)
                 -> (Integer -> Integer)
                 -> Data.Coordinate
                 -> Data.Coordinate
updateCoordinate updateX updateY (Data.XYAxis x y) =
  Data.XYAxis (updateX x) (updateY y)
  -- updateX :: Integer -> Integer
  -- updateY :: Integer -> Integer

-- The function `(\n -> n)` is predefined as `id`
--
-- id x = x

moveByDirAndUnitHO :: Integer -> Data.Direction -> Data.Coordinate
                 -> Data.Coordinate
moveByDirAndUnitHO stepUnit dir coord =
  -- updateCoordinate (\x -> updateX dir x) (\y -> updateY dir y) coord
  updateCoordinate updateX' updateY' coord
  -- updateCoordinate updateXCase updateYCase coord

 where
   -- updateXCase :: Integer -> Integer
   -- updateXCase x = case dir of
   --                   Data.Left  -> x - stepUnit
   --                   Data.Right -> x + stepUnit
   --                   _          -> x
   -- updateX' :: Integer -> Integer
   updateX' x = updateX dir x
   updateY' y = updateY dir y
   -- updateY :: Data.Direction -> Integer -> Integer
   updateY Data.Up   y = y + stepUnit
   updateY Data.Down y = y - stepUnit
   updateY _         y = y
   -- updateX :: Data.Direction -> Integer -> Integer
   updateX Data.Left x  = x - stepUnit
   updateX Data.Right x = x + stepUnit
   updateX _          x = x

yield42 :: Integer -> Integer
yield42 _ = 42

incXCoordMap :: CoordMap -> CoordMap
incXCoordMap EmptyC            = EmptyC
incXCoordMap (ACoord coord cm) =
  ACoord (updateCoordinate (\x -> x + 1) id coord)
         (incXCoordMap cm)

incYCoordMap :: CoordMap -> CoordMap
incYCoordMap EmptyC            = EmptyC
incYCoordMap (ACoord coord cm) =
  ACoord (updateCoordinate id (\x -> x + 1) coord)
         (incYCoordMap cm)

incXYCoordMap :: CoordMap -> CoordMap
incXYCoordMap EmptyC            = EmptyC
incXYCoordMap (ACoord coord cm) =
  ACoord (updateCoordinate (\x -> x + 1) (\x -> x + 1) coord)
         (incXYCoordMap cm)

mapCoordMap :: (Data.Coordinate -> Data.Coordinate)
            -> CoordMap
            -> CoordMap
mapCoordMap f EmptyC            = EmptyC
mapCoordMap f (ACoord coord cm) = ACoord (f coord) (mapCoordMap f cm)
                                     -- f :: Data.Coordinate
                                     --   -> Data.Coordinate

usageMapEx1 :: CoordMap
usageMapEx1 = mapCoordMap incX exCoordMap
 where
   -- incX :: Data.Coordinate -> Data.Coordinate
   incX coord = updateCoordinate (\x -> x + 1) id coord



exCoordMap :: CoordMap
exCoordMap = ACoord (Data.XYAxis 12 23)
                    (ACoord (Data.XYAxis 13 24)
                            (ACoord (Data.XYAxis 12 22) EmptyC))

-- Data.XYAxis (x+1) id
-- Data.XYAxis :: Integer -> Integer -> Data.Coordinate
-- id :: Integer -> Integer

-- mapCoordMap (\x -> Data.XYAxis (x+1) id) exCoordMap
--  x :: Data.Coordinate
--  (+) :: Integer -> Integer -> Integer

{-
> filterXCoord :: Integer -> CoordMap -> CoordMap
> filterXCoord xCoord EmptyC            = EmptyC
> filterXCoord xCoord (ACoord (XYAxis xCoord2 yCoord2) cm) =
>   if xCoord == xCoord2
>      then ACoord (XYAxis xCoord2 yCoord2) (filterXCoord xCoord cm)
>      else filterXCoord xCoord cm
-}

filterYCoord :: Integer -> CoordMap -> CoordMap
filterYCoord yCoord EmptyC            = EmptyC
filterYCoord yCoord (ACoord (Data.XYAxis xCoord2 yCoord2) cm) =
  if yCoord == yCoord2
     then ACoord (Data.XYAxis xCoord2 yCoord2) (filterYCoord yCoord cm)
     else filterYCoord yCoord cm

-- we usually call functions that yield `Bool` _predicates_
filterCoordMap :: (Data.Coordinate -> Bool) -> CoordMap -> CoordMap
filterCoordMap pred EmptyC = EmptyC
filterCoordMap pred (ACoord coord cm) =
  -- pred :: Data.Coordinate -> Bool
  if pred coord
     then ACoord coord (filterCoordMap pred cm)
     else filterCoordMap pred cm

{-
Some example calls of the higher-order functions using lambda functions (anonymous functions)

λ> filterCoordMap (\(Data.XYAxis xC yC) -> xC == 24) exCoordMap
EmptyC
λ> filterCoordMap (\(Data.XYAxis xC yC) -> yC == 24) exCoordMap
ACoord (XYAxis 13 24) EmptyC
λ> filterCoordMap (\(Data.XYAxis xC yC) -> even xC) exCoordMap
ACoord (XYAxis 12 23) (ACoord (XYAxis 12 22) EmptyC)
λ> :t even
even :: Integral a => a -> Bool
λ> even 12
True
λ> even 13
False
λ> exCoordMap
ACoord (XYAxis 12 23) (ACoord (XYAxis 13 24) (ACoord (XYAxis 12 22) EmptyC))
λ> filterCoordMap (\(Data.XYAxis xC yC) -> odd yC) exCoordMap
ACoord (XYAxis 12 23) EmptyC
λ> mapCoordMap id exCoordMap
ACoord (XYAxis 12 23) (ACoord (XYAxis 13 24) (ACoord (XYAxis 12 22) EmptyC))
-}
