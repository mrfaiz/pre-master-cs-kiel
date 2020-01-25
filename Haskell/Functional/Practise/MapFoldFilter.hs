{-# LANGUAGE GADTSyntax #-}
module Functional.Practise.MapFoldFilter where 

data Coordinate where 
    XYAxis :: Integer -> Integer -> Coordinate
 deriving Show

data CoordMap where
    EmptyC :: CoordMap
    ACoord :: Coordinate -> CoordMap -> CoordMap
 deriving Show

coordMap1 :: CoordMap
coordMap1 = ACoord (XYAxis 1 2) (ACoord (XYAxis 2 3) (ACoord (XYAxis 4 5) (ACoord (XYAxis 6 7) EmptyC)))

foldCoord :: (Coordinate -> Integer) -> Integer -> CoordMap -> Integer
foldCoord fCoord vEmpty EmptyC = vEmpty
foldCoord fCoord vEmpty (ACoord coord cm) = fCoord coord + (foldCoord fCoord vEmpty cm)

mapFCoord :: (Coordinate -> (Integer,Integer)) -> CoordMap -> [] ((,) Integer Integer)
mapFCoord fCoord EmptyC = []
mapFCoord fCoord (ACoord (XYAxis x y) cm) = (x,y) : mapFCoord fCoord cm

tupleToCoordMap :: []((,) Integer Integer) -> CoordMap
tupleToCoordMap [] = EmptyC
tupleToCoordMap ((a,b):xs) = ACoord (XYAxis a b) (tupleToCoordMap xs)

filterCoords :: (Coordinate -> Bool) -> CoordMap -> CoordMap
filterCoords f EmptyC = EmptyC
filterCoords f (ACoord coord cm) = 
    if (f coord)
        then ACoord coord (filterCoords f cm)
        else filterCoords f cm

data Tree a where
    Leaf :: a -> Tree a 
    Node :: Tree a -> Tree a -> Tree a 
    deriving Show

treeALeaf :: Tree Int
treeALeaf = Leaf 1

treeEx :: Tree Int
treeEx = Node (Node treeALeaf (Node (Leaf 2) (Leaf 3))) (Node (Node (Leaf 4) (Leaf 5)) (Node (Leaf 6) (Leaf 7)))

listToTree :: [] Int -> Tree Int
listToTree [x]    = Leaf x
listToTree (x:xs) = Node (Leaf x) (listToTree xs)

treeToList :: Tree a -> [] a 
treeToList (Leaf a)          = [a]
treeToList (Node left right) = (treeToList left) ++ treeToList right

foldTree :: (a -> b) -> (b -> b -> b) -> Tree a -> b
foldTree leafF nodeF (Leaf a) = leafF a 
foldTree leafF nodeF (Node l r) = nodeF (foldTree leafF nodeF l) (foldTree leafF nodeF r)

treeToArray :: Tree Int -> [] Int
treeToArray  t = foldTree fL fN t
 where 
     fL n = [n] 
     fN   = (++)

applyHOFuniction :: (Integer -> Integer) -> CoordMap -> CoordMap
applyHOFuniction f EmptyC = EmptyC
applyHOFuniction f (ACoord (XYAxis x y) cm) =  ACoord (XYAxis (f x) (f y)) (applyHOFuniction f cm)

