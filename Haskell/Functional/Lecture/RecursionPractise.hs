{-# LANGUAGE GADTSyntax #-}

module Functional.Lecture.RecursionPractise where

data StringList where
    Nil :: StringList
    List :: String -> StringList -> StringList
  deriving (Show,Eq)

emptyList :: StringList
emptyList = Nil

list1 :: StringList
list1 = List "Name1" emptyList 

list2 :: StringList
list2 = List "Name2" list1 

listLetters :: StringList
listLetters = List "A" (List "B" (List "C" (List "D" (List "E" (List "F" emptyList)))))

hasValue :: String -> StringList -> Bool
hasValue input Nil = False
hasValue input (List val list) = (input == val) || (hasValue input list)

replaceAString :: String -> String -> StringList -> StringList
replaceAString input byString Nil = Nil
replaceAString input byString (List val list) = 
    if (input == val)
        then List byString (replaceAString input byString list)
        else List val (replaceAString input byString list)

deleteString :: String -> StringList -> StringList
deleteString input Nil = Nil
deleteString input (List val lst) =
  if (input == val)
    then deleteString input lst
    else List val (deleteString input lst)

addIntoFront :: String ->StringList -> StringList
addIntoFront input (List val lst) = List input (List val lst)

addIntoRear :: String ->StringList -> StringList
addIntoRear input Nil = Nil
addIntoRear input (List val lst) =
  if (lst == Nil)
    then List val (List input Nil)
    else List val (addIntoRear input lst)

    
