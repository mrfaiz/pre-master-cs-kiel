> {-# LANGUAGE GADTSyntax #-}
>
> module Functional.Lecture.IO where
>
> import Data.Char (isDigit)

 # Quick remark on `Char` and `String`

We haven't used characters and strings so far.
   We write a value of type `Char` by using single quotations.

> aChar :: Char
> aChar = 'a'
>
> eightChar :: Char
> eightChar = '8'
>
> questionMarkChar :: Char
> questionMarkChar = '?'

For `String`, on the other hand, we use double quotation marks.

> abcString :: String
> abcString = "abc"
>
> eightNineTenString :: String
> eightNineTenString = "8910"
>
> questionString :: String
> questionString = "Hello World?"

The handy thing about `String`s in Haskell is that the usage of (double) quotation marks is just syntactic sugar: `String` is just a type synonym for `[Char]`.
    The "handy" part about this fact is that we can reuse all list functions to work with `String`s!

    $> ['a','b','c']
    "abc"
    $> head "abc"
    'a'
    $> length "abc"
    3
    $> map (\c -> 'x') "abc"
    "xxx"
    $> foldr (\c res -> if c == 'b' then 'x':res else c:res) [] "abc"
    "axc"
    $> foldr (\c res -> if c == 'b' then 'x' else c:res) [] "abc"
    "ax"

 # Input/Output

Haskell is a pure functional languae: functions have no side effects, every variable binding is immutable.
    The integration of an impure feature like input and output interactions with the user (or a system like a web-server) is, thus, handled differently than in other languages.
    In Haskell, impure behaviour (like input and output) has to be explictly stated in the type signature.
    For input and output interactions Haskell uses a type called `IO`.

      data IO a  -- (we're not interested in the concrete implementation)
    
`IO` is a type constructor (a type function) like `[]` or `Maybe` and, thus, expects a type as argument.
    Every function that interacts via input or output with the user, has a resulting type `IO a`, where `IO` indicates that a side effect occurs and the type parameter `a` indicates that the function also yields a result that we can make use of.

Haskell provides the following functions to output text on the terminal.

      putChar  :: Char -> IO ()
      putStr   :: String -> IO ()
      putStrLn :: String -> IO ()


    $> putChar 'a'
    a$> putString "Hello"
    Hello$> putStrLn "Hello"
    $>

The predefined functions `putChar` and `putString` directly print their given argument (a `Char` and a `String`, respectively) on the console, while `putStrLn` adds a newline following the given `String` argument.
    All of these function have the return type `IO ()`, where `()` can be think of as `void` in Java: there is no information we actually have from this return value, the only value of that type is `()` (here, the type and the constructor have the same name!).

    > data () where
    >   () :: ()
    
    However, since all our function need to have a return type, we use `()` if there is no meaningfun value to yield.
    Note, that the return value `()` does not show up in the output: GHCi does not not print the value `()` when we compute a function in an IO-context.
    That is, when we compute a function with return type `IO ()`, GHCi does not print the return value `()`.

Instead of passing a literatl string directly, we can use pure functions like `reverse` to transform the the input string first.

> putReversedStr :: String -> IO ()
> putReversedStr str = putStr ("Reversed string: " ++ reverse str)

    $> putReversedStr "Hello"
    olleH$>

Let's say we want to define a function `putAllStr` that takes a list of strings and prints all these strings, seperated by a newline, on the console.
    
> putAllStr :: [String] -> IO ()
> putAllStr strs = putStr (foldr (\str res -> str ++ "\n" ++ res) "" strs)

In this first version we folded the lists of strings into one string by adding a new line after each string element.
   Alternatively, we can output each element of the list seperately using `putStrLn`.
   In order to combine multiple output commands we can use the predefined combinator

     (>>) :: IO a -> IO b -> IO b

   that executes its first and second IO action in sequence.
   The return type of whole application is determined by the second argument.
   Furthermore, we do not care about the result of the first IO action.
   In case of using `putStrLn`, the return value `()` is not of interest anyway.

> putAllStr2 :: [String] -> IO ()
> putAllStr2 [str]      = putStrLn str
> putAllStr2 (str:strs) = putStrLn str >> putAllStr2 strs

    $> λ> putAllStr ["Hello", "World"]
    Hello
    World
    $> λ> putAllStr2 ["Hello", "World"]
    Hello
    World
  
The resulting type is `IO ()`, because the second argument that determines the resulting type is of type `IO ()` as well.
  
      putStrLn str >> putAllStr2 strs
      ^^^^^^^^^^^^    ^^^^^^^^^^^^^^^
        :: IO ()        :: IO ()
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
             :: IO ()

Besides printing strings on the console, we can also get user input.

      getChar :: IO Char
      getLine :: IO String

    $> getChar
    x
    'x'
    $> getString
    Hello
    "Hello"

Note that the IO actions `getChar` and getString` have to be terminated by user input: both actions wait as long as the user types in the input.
    In case of `getString` we need to terminate the input with the "enter"-key.
Furthermore, the last output comes from the REPL: 'x' and "Hello" are the results when evaluating `getChar` and `getString`, respectively.

Using the combinator `(>>)`, we can define a function that waits for user input and specifies what input is wanted by a given string.


> getStringWithQuestion :: String -> IO String
> getStringWithQuestion question = putStrLn question >> getLine

    $> getStringWithQuestion "Please type a word."
    Please type a word.
    Hello
    "Hello"

As a further adjustment, we can add a final output that thanks the user for the input.

> getStringWithQuestionPolite :: String -> IO ()
> getStringWithQuestionPolite question = putStrLn question >> getLine >> putStrLn "Thank You!"

    $> getStringWithQuestionPolite "Please type a word!"
    Please type a word!
    Test
    Thank You!

Note that the return types of both functions differ: in case of `getStringWithQuestion` the last IO action is `getLine` of type `IO String`, while in case of `getStringWithQuestionPolite` the last IO action is `putStrLn "Thank You"` of type `IO ()`.
    As the last action determines the final return type, the former is of type `IO String` and the latter of type `IO ()`.

      putStrLn question >> getLine
      ^^^^^^^^^^^^^^^^^    ^^^^^^^
        :: IO ()           :: IO String
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                :: IO String


      putStrLn question >> getLine >> putStrLn "Thank You"
      ^^^^^^^^^^^^^^^^^    ^^^^^^^    ^^^^^^^^^^^^^^^^^^^^
        :: IO ()           :: IO String   :: IO ()
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                       :: IO ()

Now we can print something to the console, read some user input and combine these actions.
    The real interesting use-case for input/output is, although, processing the input of the user.
    Fortunately, Haskell provides an additional operator

      (>>=) :: IO a -> (a -> IO b) -> IO b

    to execute an IO action (first argument) and then process the result of that action with a given function (second argument).
    The only catch here is, that once we executed one IO action in our program, we can never escape the `IO` type anymore.
    As `IO` signals side effects this restriction is a good thing: if our program calls a function with a side effect, we want that the signalising `IO` type is propagated to the final return type as well.

Using the operator above (usually called "bind"), we can define a function that waits for user input and outputs the reversed string.
    
> getPutReversed :: IO ()
> getPutReversed = putStrLn "Please type a word!" >> getLine >>= (\str -> putReversedStr str >> putStr "\n")
> --            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^    ^^^^^^^              ^^^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^
> --               :: IO ()                       :: IO String            :: IO ()              :: IO ()
> --                                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                                                                                  :: IO ()
> --                                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> --                                                                     :: String -> IO ()
> --                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> --                                                               :: IO ()

    $> getPutReversed
    Please type a word!
    Hello World!
    Reversed string: !dlroW olleH

Let's say we want to read input from the user and return the reversed string, that is, we do not want to print it on the console as above.
    In this case, we define a function with return type "IO String", that is, we want to reverse the string we read from the user using `getLine` and yield it as result.
    In order to "lift" a pure value, like a `String`, into the IO-context, we can use the function `pure`.

      pure :: a -> IO a
    
> getReversed :: IO String
> getReversed = getLine >>= (\str -> pure (reverse str))

We can test the behaviour of the `getReversed` function by printing the resulting value using `putStrLn`.
    Due to the behaviour of the REPL concerning `IO`, we can also see the resulting value when computing `getReversed` itself.
    
    $> getReversed >>= \str -> putStrLn str
    Test
    tseT
    $> λ> getReversed
    Test
    "tseT"

As a more practical example, we implement a funtion `getDigit` that reads character from the user, checks if it is a digit and yields the digit, otherwise the user is asked again to provide a digit as input.
    The helper function `digitToInt` converts a character to numeric value.
    Note that this helper function is only partially defined: it yields a run-time error for all inputs that are not digits.
    Therefore, it is crucial that we use the function `digitToInt` only after checking the character using `isDigit` first.
    Here, `isDigit` is predefined in the module `Data.Char` that Haskell provides.

> getDigit :: IO Int
> getDigit = getChar >>= (\c -> if isDigit c
>                                 then pure (digitToInt c)
>                                 else putStrLn "This input is not a digit, please try again" >> getDigit)
>
> digitToInt :: Char -> Int
> digitToInt '0' = 0
> digitToInt '1' = 1
> digitToInt '2' = 2
> digitToInt '3' = 3
> digitToInt '4' = 4
> digitToInt '5' = 5
> digitToInt '6' = 6
> digitToInt '7' = 7
> digitToInt '8' = 8
> digitToInt '9' = 9


    $> getDigit
    1
    1
    λ> getDigit
    a
    This input is not a digit, please try again
    b
    This input is not a digit, please try again
    6
    6

Note that in case of an input that meets the predicate `isDigit`, the first number is the input typed by the user and the second is the output of the REPL that prints the result of the whole computation `getDigit`.
    As `getDigit` is of type `IO Int`, it has some potential side effects (here reading input and printing statements like "This input ...") and also yields a value of type `Int`.
    Note, however, that we can only process the resulting `Int` value by using `>>=` since it's used in an IO-context.
    
Instead of just reading one character, we can also read a whole string and try to interpret it as number.
    The helper function `allDigit` is our predicate that checks if all characters are digits and the function `numberToInt` converts a string into a numeric value.
    Once again, its crucial that we checked the string we want to convert for validity first.

> getNumber :: IO Int
> getNumber = getLine >>= (\str ->
>              if allDigit str
>                then pure (numberToInt str)
>                else putStrLn "This input is not a number, please try again!" >> getNumber)
> 
> allDigit :: String -> Bool
> allDigit []     = False
> allDigit [c]    = isDigit c
> allDigit (c:cs) = isDigit c && allDigit cs
>                   
> numberToInt :: String -> Int
> numberToInt str = foldr (\(c, tens) acc -> (digitToInt c) * tens + acc)
>                         0
>                         (zip (reverse str) (powerOfTens 0))
>  where powerOfTens n = 10^n : powerOfTens (n+1)

    $> getNumber
    Hello?
    This input is not a number, please try again
    123
    123

Instead of using the tedious to define functions `digitToInt` and `numberToInt`, Haskell provides a function `read` that is the counterpart of the function `show`.
    We have implicitely used `show` before when we compute functions in the REPL: Haskell will use the `show` function to print a value.
    Remember that we need to annotate `deriving Show` for every data type we're defining in order for Haskell to print its constructors in the REPL.
    That is, `show` converts a value into a `String`, whereas `read` converts a `String` into a value.
    Note, however, that this conversion might fail at run-time and that the conversion that Haskell tries to perform depends on the type we want the value to have.

    $> read "12a" + 2
    *** Exception: Prelude.read: no parse
    $> read "12" + 2
    14
    $> not (read "12")
    *** Exception: Prelude.read: no parse
    $> not (read "True")
    False

In the first two examples we want to convert the string into a number, because we're using it as first argument to `(+)`.
   The last two examples expect an argument of type `Bool`, that is, Haskell will try to convert the given string into a value of type `Bool`, like `True` or `False`.

The other way around, we use `show` to convert values into a string in order to use them as argument of `putStrLn` and `putStr` to print them on the console.

    $> getNumber >>= (\n -> putStrLn n)
    <interactive>:7:31: error:
    • Couldn't match type ‘Int’ with ‘[Char]’
      Expected type: String
        Actual type: Int
    • In the first argument of ‘putStrLn’, namely ‘n’
      In the expression: putStrLn n
      In the second argument of ‘(>>=)’, namely ‘(\ n -> putStrLn n)’
    $> getNumber >>= (\n -> putStrLn ("The number is " ++ n ++ "."))
    <interactive>:11:52: error:
    • Couldn't match expected type ‘[Char]’ with actual type ‘Int’
    • In the first argument of ‘(++)’, namely ‘n’
      In the second argument of ‘(++)’, namely ‘n ++ "."’
      In the first argument of ‘putStrLn’, namely
        ‘("The number is " ++ n ++ ".")’
    $> getNumber >>= (\n -> putStrLn ("The number is " ++ show n ++ "."))
    123
    The number is 123.

The first two tries fail with compile-time errors: `putStrLn` as well as `++` expect a `String` (i.e., `[Char]`) as arguments, but we provide a value of type `Int`.
    That is, in the last example we convert `n` into a string by using `show`.
