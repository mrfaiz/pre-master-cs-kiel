{-# LANGUAGE GADTSyntax #-}

module Functional.Practise.PreviousQuestions where 

data BTree a where 
    Empty :: BTree a
    Node  :: BTree a -> a -> BTree a -> BTree a
    deriving Show

data BTree2 a where 
    Empty :: BTree2 a
    Node  :: BTree2 a -> a -> BTree2 a -> BTree2 a
    deriving Show

leaf :: BTree Int
leaf = Node Empty 1 Empty

leaf3 :: BTree Int
leaf3 = Node Empty 3 Empty

node1 :: BTree Int
node1 = Node leaf 2 leaf3

foldBtree :: (b->a->b->b) -> b -> BTree a -> b
foldBtree f vEmpty Empty = vEmpty
foldBtree f vEmpty (Node leftT v rightT) = f (foldBtree f vEmpty leftT) v (foldBtree f vEmpty rightT)

sumTree :: BTree Int -> Int
sumTree node1 = foldBtree func func0 node1
 where
     func a b c = a + b + c
     func0 = 0

getNumber :: IO Int
getNumber = getLine >>= return