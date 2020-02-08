{-# LANGUAGE GADTSyntax #-}

module Functional.Practise.Polymorphism where

data List a where
    Nil  :: List a
    Cons :: a -> List a -> List a
    deriving Show

arrayList :: List Integer
arrayList = Cons 23 Nil