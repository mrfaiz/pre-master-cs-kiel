> {-# LANGUAGE GADTSyntax #-}
>
> module Functional.Exercise.Exercise5 where
>
> import Functional.Lecture.InputOutput (getNumber)
> import Functional.Lecture.MoreData (inBounds)

1. In Haskell `String`s are list of `Char`s. The following definitions should transform the given string "HelloWorld" such that it yields the string specified by the comment above. You are only allow to use generic list functions like `map`, `foldr`, `filter`, but no manual pattern matching, for the implementation.

> -- str1 "HelloWorld" = "HelloWorld!"
> str1 :: String -> String
> str1 = error "str1: Implement me!"
>
> -- str2 "HelloWorld" = "GfoopXpsme"
> str2 :: String -> String
> str2 = error "str2: Implement me!"
>
> -- str3 "HelloWorld" = "HllWrld"
> str3 :: String -> String
> str3 = error "str3 : Implement me!"
  
2. Implement a function `getInBounds :: Int -> Int -> IO Int` that reads a number from the user. If the value is not within the given bounds, the user needs to try again to type in a number that meets the bounds. The implementation should additionally behave as illustrated below.

   $> getInBounds 12 16
   Please type in a number between 12 and 16.
   131
   The number does not meet the given bounds, please try again.
   13s
   The input is not a number. Please type in a number between 12 and 16.
   13

Hint: You should reuse `getNumber` and `inBounds` that we defined in previous lectures.

> getInBounds :: Int -> Int -> IO Int
> getInBounds = error "getInBounds: Implement me!"

3. Implement a more general function `geStringtWithCondition :: (String -> Bool) IO String` that reads a string from the user and only yield this value if the string obeys to the corresponding prediate. If the predicate does not hold, the user should be informed to try it again.

> getStringWithCondition :: (String -> Bool) -> IO String
> getStringWithCondition pStr = error "getWithCondition: Implement me!"

4. Implement an interactive number guessing game. The game `guessNumber` expects the "secret number" as argument and gives feedback for each guess and the game is completed, if the guessed number matches the secret. Otherwise the user gets feedback if the guess was "too small" or "too large".
Hint: Reuse the function `getNumber` from the lecture.

> guessNumber :: Int -> IO ()
> guessNumber = error "guessNumber: Implement me!"

A round might look like this! Note, that this is a two-player game: the user starting the game shouldn't be the one guessing the numbers ; )
  
     $> guessNumber 421
     Let's try to guess the number!
     12
     Your guess is too small. Try again.
     100
     Your guess is too small. Try again.
     200
     Your guess is too small. Try again.
     300
     Your guess is too small. Try again.
     400
     Your guess is too small. Try again.
     500
     Your guess is too large. Try again.
     450
     Your guess is too large. Try again.
     425
     Your guess is too large. Try again.
     413
     Your guess is too small. Try again.
     420
     Your guess is too small. Try again.
     422
     Your guess is too large. Try again.
     421
     Congrats, you guessed the number!
