{-# LANGUAGE GADTSyntax #-}

module Functional.Practise.PlayWithCollections where

double x = x + x

sumNumbers :: [Int] -> Int
sumNumbers [] = 0
sumNumbers (v:next) = v + sumNumbers next