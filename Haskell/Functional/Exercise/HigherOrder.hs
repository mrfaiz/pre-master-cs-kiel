{-# LANGUAGE GADTSyntax #-}

module Functional.Exercise.HigherOrder where
import qualified Functional.Lecture.DataAndFunctions as Data
import           Functional.Lecture.Recursion

moveInYDirByUnit :: Integer -> Data.Direction -> Data.Coordinate -> Data.Coordinate
moveInYDirByUnit unit Data.Up (Data.XYAxis x y)   = Data.XYAxis x (y+unit)
moveInYDirByUnit unit Data.Down (Data.XYAxis x y) = Data.XYAxis x (y-unit)
moveInYDirByUnit unit _         dir               = dir

moveInXDirectionByUnit :: Integer -> Data.Direction -> Data.Coordinate -> Data.Coordinate
moveInXDirectionByUnit unit Data.Left (Data.XYAxis x y)  = Data.XYAxis (x + unit) y 
moveInXDirectionByUnit unit Data.Right (Data.XYAxis x y) = Data.XYAxis (x - unit) y
moveInXDirectionByUnit unit _          coord             = coord

data MathOperations where
    Add :: MathOperations 
    Sub :: MathOperations

updateXDirection :: MathOperations -> Integer -> Data.Direction-> Data.Coordinate -> Data.Coordinate
updateXDirection operation unit dir (Data.XYAxis x y) = Data.XYAxis (xNew operation) y
 where 
    xNew Add = x + unit
    xNew Sub = x- unit 

updateWithHO :: (Integer -> Integer) -> Data.Coordinate -> Data.Coordinate
updateWithHO hoFuntion (Data.XYAxis x y) = Data.XYAxis (hoFuntion x) y

exHO1 :: Data.Coordinate
exHO1 = updateWithHO hOF (Data.XYAxis 33 22)
 where 
    hOF value = value + 5

exHO2 :: Data.Coordinate
exHO2 = updateWithHO lamdaF (Data.XYAxis 44 33)
 where 
    lamdaF x = x - 3

updateBothAxis :: (Integer->Integer) -> (Integer -> Integer) -> Data.Coordinate -> Data.Coordinate
updateBothAxis upX upY (Data.XYAxis x y) = Data.XYAxis (upX x) (upY y)

updateBoth1 :: Data.Coordinate
updateBoth1 = updateBothAxis updateX updateY (Data.XYAxis 44 33)
 where 
    updateX x = x + 5
    updateY y = y + 3

updateBoth2 :: Data.Coordinate
updateBoth2 = updateBothAxis id id (Data.XYAxis 44 33)

updateBothLamda :: Data.Coordinate
updateBothLamda = updateBothAxis (\x -> x +5 ) id (Data.XYAxis 44 33)


update :: (Integer->Integer) -> (Integer->Integer) -> Data.Coordinate -> Data.Coordinate
update updateX updateY (Data.XYAxis x y) = Data.XYAxis (updateX x) (updateY y)

moveByDirectionUnit :: Integer-> Data.Direction -> Data.Coordinate -> Data.Coordinate
moveByDirectionUnit stepUnit dir coord = update updateX1 updateY1 coord
 where 
    updateX1 x = upX1 dir x
    updateY1 y = upY2 dir y 

    upX1 Data.Right x = x + stepUnit
    upX1 Data.Left  x = x - stepUnit
    upX1 _          x = x

    upY2 Data.Up   y = y + stepUnit
    upY2 Data.Down y = y - stepUnit
    upY2 _         y = y

exCoordinates :: CoordMap
exCoordinates = ACoord (Data.XYAxis 12 13)
                    (ACoord (Data.XYAxis 14 15) 
                        (ACoord (Data.XYAxis 16 17)
                            (ACoord (Data.XYAxis 18 19) EmptyC)))

incXCoords :: CoordMap -> CoordMap
incXCoords EmptyC                        = EmptyC
incXCoords (ACoord (Data.XYAxis x y) cm) = ACoord (Data.XYAxis (x + 1) y) (incXCoords cm)

incXCoordsLamdaF :: CoordMap -> CoordMap
incXCoordsLamdaF EmptyC            = EmptyC
incXCoordsLamdaF (ACoord coord cm) = ACoord (updateBothAxis (\x -> x + 1) id coord) (incXCoordsLamdaF cm)

applyLamda :: (Data.Coordinate -> Data.Coordinate) -> CoordMap -> CoordMap
applyLamda f EmptyC = EmptyC
applyLamda f (ACoord coord cm) = ACoord (f coord) (applyLamda f cm)

example1 :: CoordMap
example1 = applyLamda incX exCoordinates
 where 
    incX coord = updateBothAxis (\x -> x+1 ) (\y -> y + 1) coord

replace :: (Data.Coordinate -> Bool) -> CoordMap -> CoordMap
replace pred EmptyC            = EmptyC
replace pred (ACoord (Data.XYAxis x y) cm) = 
    if pred (Data.XYAxis x y)
        then (ACoord (Data.XYAxis (x * 100) y) (replace pred cm))
        else (ACoord (Data.XYAxis x y) (replace pred cm))

