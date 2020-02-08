{-# LANGUAGE GADTSyntax #-}

module Functional.Lecture.InputOutput where

import           Data.Char (isDigit)

-- predefined in Haskell
--
-- data IO a

-- also predefined are some functions to output messages for the user
--
-- putChar  :: Char   -> IO ()
-- putStr   :: String -> IO ()
-- putStrLn :: String -> IO ()

-- predefined "Unit"-type in Haskell
--
-- data () where
--   () :: ()

aChar :: Char
aChar = 'a'

nineChar :: Char
nineChar = '9'

questionmarkChar :: Char
questionmarkChar = '?'

abcString :: String
abcString = "abc"

questionString :: String
questionString = "Hello World?"

numberString :: String
numberString = "910"

-- a `String` is just a type synonym for a list for `Char`s (predefined in Haskell as)
-- type String = [] Char

-- predefined functions for interacting with input from the user
--
-- getChar :: IO Char
-- getLine :: IO String

-- predefined function to combine IO actions
--
-- (>>) :: IO a -> IO b -> IO b

putReversedStr :: String -> IO ()
putReversedStr str = putStr ("Reversed String: " ++ reverse str)

putBothStrings :: String -> IO ()
putBothStrings str = putStr str          -- IO ()
                     >>
                     putStr " "          -- IO ()
                     >>
                     putReversedStr str  -- IO ()

putBothStrings2 :: String -> IO ()
putBothStrings2 str = putStr (str ++ " " ++ reverse str)

getStringWithQuestion :: String -> IO String
getStringWithQuestion question = putStrLn question       -- IO ()
                                 >>
                                 getLine                 -- IO String


getStringWithQuestionPolite :: String -> IO ()
getStringWithQuestionPolite question = putStrLn question       -- IO ()
                                       >>
                                       getLine                 -- IO String
                                       >>
                                       putStrLn "Thank You!"   -- IO ()

-- predefined combinator to actually do something with the result of an IO action,
--  we usually call this function "bind"
--
-- (>>=) :: IO a -> (a -> IO b) -> IO b

getReversed :: IO ()
getReversed = putStrLn "Please type a word" >>     -- IO ()
              getLine >>= (\str ->                 -- IO String
              putReversedStr (str) >>              -- IO ()
              putStr "\n")                         -- IO ()

-- getReversed :: IO ()
-- getReversed =
--   putStrLn "Please type a word!" >> getLine >>= (\str -> putReversedStr (str) >> putStr "\n")
--                                                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--                                                             :: IO ()
--                                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--                                                     :: String -> IO ()

{-
  $> getReversed
  Please type a word!
  Hello
  Reversed String: olleH
  "olleH"
-}

getCombined :: IO ()
getCombined = getLine >>= (\str1 ->
              getLine >>= (\str2 ->
              putStrLn ("Combined: " ++ str1 ++ str2)))

-- predefined combinator to "lift" a value into the IO type
--
--    pure :: a -> IO a

getDigit :: IO Int
getDigit = getChar >>= (\c ->      -- c :: Char , getChar :: IO Char
           if isDigit c then pure (digitToInt c)
                        else putStrLn "This input is not a digit, please try again" >> getDigit)
                        --   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                        --     :: IO Int
                             --  putStrLn :: String -> IO ()
                             --  getDigit :: IO Int
                             --  putStrLn "..." >> getDigit    :: IO Int

-- predefined in Haskell in Data.Char
-- isDigit :: Char -> Bool
-- isDigit '0' = True
-- isDigit '1' = True
-- isDigit '2' = True

getNumber :: IO Int
getNumber = getLine >>= (\str ->
            if allDigit str then pure (numberToInt str)
                            else putStrLn "This input is not a number, please try again" >> getNumber)


-- "123"   -- reverse the string -> "321"
-- 3 * 1 + 2 * 10 + 1 * 100
-- 1 * 100 + 2 * 10 + 3 * 1
--

numberToInt :: String -> Int
numberToInt str = foldr (\(c, tens) acc -> (digitToInt c) * tens + acc)
                        0
                        (zip (reverse str) powerOfTens)

powerOfTens :: [Int]
powerOfTens = help 0
 where help n = 10^n : help (n+1)


getPowerOfTens :: IO [Int]
getPowerOfTens = getNumber >>= (\n -> pure (take n powerOfTens))

-- writeFile :: FilePath -> String -> IO ()
-- readFile :: FilePath -> IO String

lilProgram :: IO ()
lilProgram = writeFile "Tens.txt" (show (take 42 powerOfTens))

exampleString :: [] String 
exampleString = ["Welcome! Enter a number :","123"]

writeIntoFileExampleArray :: IO ()
writeIntoFileExampleArray = writeFile "example.txt" "123"

readFileString :: IO () 
readFileString = readFile "example.txt" >>= (\str -> putStrLn str >> getLine >>= (\str2 -> if str2==str then putStrLn "Successfule" else putStrLn "not Match!"))

lilProgram2 :: IO ()
lilProgram2 = readFile "Tens.txt" >>= (\str -> writeFile "TensReverse.txt" (show (reversedList str)))
  where reversedList str = reverse (read str :: [Int])

--lilProgram3 :: [Int]
--lilProgram3 = readFile "Tens.txt" >>= (\str -> reversedList str)
  --where reversedList str = reverse (read str :: [Int])

allDigit :: String -> Bool
allDigit []     = False
allDigit [c]    = isDigit c
allDigit (c:cs) = isDigit c && allDigit cs

--   allDigit ['1','2']
-- = isDigit '1' && allDigit ['2']
-- = isDigit '1' && isDigit '2'
-- = True

digitToInt :: Char -> Int
digitToInt '0' = 0
digitToInt '1' = 1
digitToInt '2' = 2
digitToInt '3' = 3
digitToInt '4' = 4
digitToInt '5' = 5
digitToInt '6' = 6
digitToInt '7' = 7
digitToInt '8' = 8
digitToInt '9' = 9

-------------------------

nats :: [Int]
nats = nats' 1
 where nats' n = n : nats' (n+1)


getIntInRange :: Int -> Int -> IO Int
getIntInRange min max = putStr ("Enter a number from "++ show min ++" to "++show max++" : ") >> getNumber >>= (\n -> 
  if n>=min && n<=max 
    then pure n 
    else putStrLn ("Not in Range from "++ show min ++" to "++show max++". Try again ") >> getIntInRange min max)

displayMenu :: [String] -> IO ()
displayMenu str = putStrLn (foldr(\(index,name) res -> ("\n ("++ show index++") "++ name) ++ res) "\n" (zip nats str))
-- displayMenu ["Hangman", "Guess a Number", "Rock, Paper, Scissors"]

data TwoPlayer where
 A :: TwoPlayer
 B :: TwoPlayer
 deriving Show

data GameResult where
 Win :: TwoPlayer -> GameResult
 Lose :: TwoPlayer -> GameResult
 Draw :: GameResult
 deriving Show

values :: [( String , IO GameResult )]
values = [("Hangman", return (Win A)),("Guess a Number", return (Win B)),("Rock, Paper, Scissors", return (Win A))]

getFromList :: String ->  [( String , IO GameResult )] -> IO GameResult
getFromList _ [] = return Draw
getFromList str ((name, io):rest)= if str == name then io else getFromList str rest

getGameNameByIndex :: Int -> String
getGameNameByIndex n = ["Hangman", "Guess a Number", "Rock, Paper, Scissors"] !! (n-1)


--printMessage :: 

--menu :: [( String , IO GameResult)] -> IO ()
--menu games = putStrLn (" Which   game  do  you   want  to  play ?"++ show (Win A)) >>  displayMenu ["Hangman", "Guess a Number", "Rock, Paper, Scissors"] >> 

getLineExample :: IO String 
getLineExample = getLine >>= (\str -> return (reverse str))

getLineExample2 :: IO String 
getLineExample2 = getLine >>= return.reverse



data Exp a b  where
   Lit :: a -> Exp a b
   Binary :: Exp a b -> b -> Exp a b -> Exp a b
   deriving Show

value1 :: Exp Int Bool
value1 = Binary (Lit 2) False (Lit 3)