This file is a _literate Haskell_ file.
In ordinary Haskell files we write multi-line comments by sourounding the comment with `{- -}`.
As in literate Haskell files everything is a comment by default, code needs to be explicitly marked.
We mark code using a `> ` as prefix -- the so-call Bird-style (because, apperently, `>`
    looks like the beak a bird).

For the _Functional Programming_ part of the lecture, we are using Haskell as language of choice.
Please install a recent version of GHC and use an editor with Haskell syntax highlighting;
    especially the teaching assistants in the lab will be very pleased with such a setup ; )

    https://www.haskell.org/downloads/#platform

In the lecture I'll always have the code we're developing to the right,
    and a running REPL-session (REPL: read-eval-print-loop) on the left-hand side.
You can start such a REPL-session using `ghci` and loading the file you want to interact with.

$> ghci
GHCi, version 8.6.5: http://www.haskell.org/ghc/  :? for help
Prelude> :l DataAndFunctions.lhs

The command `:l <FileName>.hs` or `:l `<FileName>.lhs` loads and compiles the
    Haskell-file with the specified name.
For reloading, that is, if we changed or added definitions to our
    file, we can simply use the command `:r`.

For didactic purposes, we'll always use the following so called "language extension" that you need to include in all your files.
In this case, the surrounding parentheses are part of the declaration!

> {-# LANGUAGE GADTSyntax #-}

Given a small exemplary code snippet in Java, we will see how to define a similary setup in Haskell.

```
    public class DataAndFunction {

        private static Integer inc(Integer i) {

            return (i + 1);
        }

        public static void main (String[] args) {

            System.out.println(DataAndFunction.inc(42));
        }
    }
```

Instead of defining a class to encapsulate a variety of functions, we define a `module` in Haskell.
The module needs to have the same name as the file we save the code in.

> module Functional.Lecture.DataAndFunctions where

As we use the names `Left` and `Right` later, we need to hide predefined constructors of the same name

> import           Prelude hiding (Left, Right)

The static function `inc` in Java specified that it takes one `Integer` argument as input and yields an `Integer`.
The body then yields the input argument incremented by one.
In Haskell we write the following code.


> --   Integer input    Integer output
> --        |            |
> --        v            v
> inc :: Integer -> Integer
> inc i = i + 1


Defining and using functions
-----------------------------

The first line is called a _type signature_,
    it specifies the number as well as associated types of the input arguments as well as the type of the result.
Each argument is seperated by an arrow symbol `->`, the last type specifies the type of the resulting value.
That is, for a binary function (a function with two arguments) we have two arrows, while a unary function has only one.

The second line is called _a rule_ (or the definition).
On the left-hand side of the definition we introduce a variable `i` that is specified to be of type `Integer`.
We then increment the given value `i` by one as result of the function.

In the Java example the statement `return i + 1` indicates that the value `i + 1` is yieled as result.
In this lecture, we won't see any `return`-statements like you're probably used to from other languages.

<SPOILER ALERT: in the last week of the lecture, we will indeed
see that `return` is a predefined function in Haskell that can
be pretty useful!>


We can also define function with more, or even less, arguments.
The following function definitions have arity 1, 2 and 0.
The function `dec` has one argument like `inc`,
  the function `plus` is a renaming of the primitive function `+` for addition and expects two arguments,
  and the function `fortytwo` is a constant, which does not have any arguments.

> dec :: Integer -> Integer
> dec i = i - 1

> plus :: Integer -> Integer -> Integer
> plus n m = n + m

> fortytwo :: Integer
> fortytwo = 42

Predefined functions like `+` and `-` are used as operators:
    we write the application in _infix notation_.
For functions like the above, `inc`, `dec` and `plus`, we use so-called juxtaposition:
    the arguments of the function are passed seperated by (at least one) whitespace.

λ> inc 42
43
λ> dec 42
41
λ> plus 1 2
3

It is also okay to use parentheses for each _individual_ argument.

λ> inc (42)
43
λ> dec (42)
41
λ> plus (42) (1337)
1379

Especially for a binary function like `plus`,
  it is important to understand that we cannot use one pair of parentheses around both arguments,
  which looks a bit like in languages like Java.

λ> plus(42 1337)

<interactive>:16:6-7: error:
    • No instance for (Num (Integer -> Integer))
        arising from the literal ‘42’
        (maybe you haven't applied a function to enough arguments?)
    • In the expression: 42
      In the first argument of ‘plus’, namely ‘(42 1337)’
      In the expression: plus (42 1337)

The error message seems a bit cryptic, but the important message is

(maybe you haven't applied a function to enough arguments?).

For Haskell it seems like `(42 1337)` is the first argument of the function `plus`.
However, the first argument of `plus` needs to be of type `Integer`.
The expression `(42 1337)` is, however, not an `Integer`.
It is the application of `42` to `1337` (which does not make any sense at all, by the way.)
The Java-instinct then kicks in and we try to pass the two arguments seperated by a comma!

λ> plus(42, 1337)

<interactive>:17:5-14: error:
    • Couldn't match expected type ‘Integer’
                  with actual type ‘(Integer, Integer)’
    • In the first argument of ‘plus’, namely ‘(42, 1337)’
      In the expression: plus (42, 1337)
      In an equation for ‘it’: it = plus (42, 1337)

This try fails as well: again,
  we need to pass a value of type `Integer` as first argument,
  but what we actually use is a pair of `Integer`s.
The construction of a pair is a special syntax in Haskell that comes with its on type.
We will see and use pairs later in the lecture again.


Note, however, that it's not always safe to leave out the parentheses altogther.
Sometimes it's _necessary_ to use parentheses
    in order to make sure that the result of more complicated expression should be used as argument.
Take for example the following expression that applies the function `plus`.

λ> plus (inc 41) 1337
1379

Here, the second argument is the expression `inc 41`.
    As this expression evaluates to an `Integer`, namely `42`, we can use it as one of the arguments of `plus` as well.
If we we do not use parentheses here, the expression means something entirely different.

λ> plus inc 41 1337
<interactive>:21:1-18: error:
    • Couldn't match expected type ‘Integer -> t’
                  with actual type ‘Integer’
    • The function ‘plus’ is applied to three arguments,
      but its type ‘Integer -> Integer -> Integer’ has only two
      In the expression: plus inc 41 (1337)
      In an equation for ‘it’: it = plus inc 41 (1337)
    • Relevant bindings include it :: t (bound at <interactive>:21:1)

<interactive>:21:6-8: error:
    • Couldn't match expected type ‘Integer’
                  with actual type ‘Integer -> Integer’
    • Probable cause: ‘inc’ is applied to too few arguments
      In the first argument of ‘plus’, namely ‘inc’
      In the expression: plus inc 41 (1337)
      In an equation for ‘it’: it = plus inc 41 (1337)

Once again, the error message is rather cryptic, but also gives us
a hint about the root of the problem.

    • The function ‘plus’ is applied to three arguments,
      but its type ‘Integer -> Integer -> Integer’ has only two
      In the expression: plus inc 41 (1337)

Haskell interprets the above expression as follows:
    we apply the function `plus` to three arguments:
    the first one is `inc` (because why not?),
    the second one is `41` and `1337` is the third one.
However, `plus` is a binary function and only expects two arguments,
    so we used the function in a wrong way.



All the definitions we have seen above introduce variables for all arguments of the left-hand side,
    which can be used on the right-hand side.
In Haskell we can use a handy concept called _pattern matching_
    in order to define the behaviour of the function for a particular input.
The most general pattern we can use is a _variable pattern_,
    we have already seen the usage of variables in the definitions of `inc`,`dec` and `plus` above.

Similar to definitions we know from math classes,
    we can specify that a function should behave differently for a specific input.
We can, for example,
    define a variant of `inc` above that yields its argument incremented by one except for `42` and `1337`.

> incButNotIf42Or1337 :: Integer -> Integer
> incButNotIf42Or1337 42   = 42
> incButNotIf42Or1337 1337 = 1337
> incButNotIf42Or1337 i    = inc i


The lines after the type signature are the _rules_ of the function,
    before we've only seen function with one rule, but in general,
    we can define functions using several rules.

When Haskell evaluates a function call like

        incButNotIf42Or1337 14

    it _checks the rules from top to bottom_.
That is, it checks if the argument `14` matches `42`, as it does not,
    it then proceed to the second rule.
`14` also does not match with `1337`, so the last rule is taken.
The last rule uses a variable pattern for its argument that matches every input,
    so that the associated right-hand side will be used to evaluate the expression further.
Finally, `inc 14` yields `15` as result.

As the variable pattern is a very general pattern, it matches for every input argument.
We need to keep in mind to put the more specific patterns (like `42`) on top of such rules with general patterns.



> incButNotIf42 :: Integer -> Integer
> incButNotIf42 i  = inc i
> incButNotIf42 42 = 42

In this case the evaluation of the expression

        incButNotIf42 42

    yields `43`, because the first rule already matches,
    such that the rule with the special pattern in case of `42` is never checked.


Defining and constructing data
-------------------------------

Besides the definition of functions, in Haskell it is also important to represent data.
As we do not want to represent everything using `Integer` value alone,
    we want a mechanism to introduce new representations of data.

The keyword `data` introduces user-defined data types; names of data types start with an upper-case letter.

A data type declaration lists all the new possible values we are then able to construct with their corresonding types.
`Up`, `Down`, `Left` and `Right` are new values of type `Direction` that we can now use in our programs.
We call such values _constructors_; constructors always start with a capital letter as well.
Constructors are a special kind of functions:
    the type signature once again specifies how many and what type of arguments we need to apply the constructor to.

> --    name of the data type
> --       |
> --       v
> data Direction where
>   Up    :: Direction   -- <--|
>   Down  :: Direction   -- <--| constructors of type `Direction`
>   Left  :: Direction   -- <--|
>   Right :: Direction   -- <--|
>  deriving Show

When we wanted to test out our examplary value in the REPL, we got the following error message.

<interactive>:95:1-15: error:
    • No instance for (Show Direction) arising from a use of ‘print’
    • In a stmt of an interactive GHCi command: print it

We bypassed the problem by using the following function to transform a value of type `Direction` into a `String`.

```
directionToString :: Direction -> String
directionToString Up    = "Up"
directionToString Down  = "Down"
directionToString Left  = "Left"
directionToString Right = "Right"
```

λ> directionToString Down
"Down"

The annotation `deriving Show` generates a suitable function for visualising.
That is, GHC generate a function

        show :: Direction -> String

    that is used to visualise a value of type `Direction` in the REPL.

More precisely, the above definition `directionToString` mimics exactly
    the definition that GHC generates in case of `Direction`.

```
directionToString2 :: Direction -> String
directionToString2 dir = show dir
```

In order to construct values of type `Direction`,
    we need to use one of the above constructors (these are the only values of) hat type.
We can construct exemplary values as follows.

> exDirection1 :: Direction
> exDirection1 = Left

> exDirection2 :: Direction
> exDirection2 = Down


Note that, in contrast to names of types and constructors,
    function (and, thus, also constants like the above) always start with a lower-case letter.
Consequently, we can have a function named `right`,
    although we have a constructor named `Right` in already,
    the namespace for functions and constructors is destinct due to the difference concerning captialisation.

> right :: Integer
> right = 1


Haskell won't accept the following definition,
    because functions need to start with a lower-case letter.

    Right :: Integer
    Right = 2

    λ> :r
        [1 of 1] Compiling DataAndFunctions ( DataAndFunctions.hs, interpreted )
        DataAndFunctions.hs:171:1-5: error:
            Invalid type signature: Right :: ...
            Should be of form <variable> :: <type>
           |
        65 | Right :: Integer
           | ^^^^^
        Failed, modules loaded: none.

It is pretty neat to know all the possible values an argument can be beforehand,
    in case of `Direction` we know that the only possible values come in the shape of the associated constructors!

Let us, for example,
    define a function `flipVertical` that takes a `Direction` as input and yields a `Direction` as output.
The function changes the value in case of a vertical direction like `Up` or `Down`
    and yields the input as output in the other cases.

We'll use pattern matching to distinguish the different behaviour for specific input values.

> flipVertical :: Direction -> Direction
> flipVertical Up    = Down
> flipVertical Down  = Up
> flipVertical Left  = Left
> flipVertical Right = Right


The next function behaves similar, but flips the horizontal directions.
This time, we combine the two cases that yields the value of the input directly as output by using a variable pattern.

> flipHorizontal :: Direction -> Direction
> flipHorizontal Left  = Right
> flipHorizontal Right = Left
> flipHorizontal dir   = dir


The next data type definition has only one constructor,
    but this time the constructor has additional arguments.
More precisely, the constructor `XYAxis` is a binary function that takes two `Integer` values
    as arguments in order to construct a value of type `Coordinate`.
The first argument describes the x-component of a coordinate and the second arguments the y-component.

> data Coordinate where
>   XYAxis :: Integer -> Integer -> Coordinate
>  deriving Show


We define the following exemplary value that describes the "origin" with respect to our coordination system.
We construct a value of type `Coordinate` by applying the constructor `XYAxis` to two arguments of type `Integer`.

> origin :: Coordinate
> origin = XYAxis 0 0


For `Direction` we've already seen how to constructor new values of our self-defined type.
In case of `Coordinate` it now becomes more interesting to take a look at how to deconstruct a value.
We can only construct a value using the constructor `XYAxis` by applying two arguments of type `Integer`.
That means that, on the other hand, if we have an argument of type `Coordinate`,
    we know that this argument has to be constructed using `XYAxis` (as it is the only constructor)
    and we also have access to its two arguments of type `Integer` by using pattern matching!
Pattern matching on a constructor with arguments corresponds to a deconstruction of the value:
    we know that there have to be two values of type `Integer` available!

Take, for example,
    the following functions that access the components of a `Coordinate` in order to yield and change the y-component,
    respectively, and the same pair of functions for x-component.
Pattern matching allows us the access the arguments of the constructor `XYAxis`
    and bind them to the variable patterns `x` and `y`, that we can again use on the right-hand side.
These function have high resemblence with getter- and setter-functions known from OO-languages like Java.

> yCoord :: Coordinate -> Integer
> yCoord (XYAxis x y) = y

> yCoordSet :: Integer -> Coordinate -> Coordinate
> yCoordSet yNew (XYAxis x y) = XYAxis x yNew

> xCoord :: Coordinate -> Integer
> xCoord (XYAxis x y) = x

> xCoordSet :: Integer -> Coordinate -> Coordinate
> xCoordSet xNew (XYAxis x y) = XYAxis xNew y

Let us now define a function that given a direction and a
coordinate yields a coordinate with the component corresponding
to the given direction increases or decreases by one.
That is, we can think of the function as a moving one pixel (or any
other unit we set for the coordinates) withing a coordinate system
to the specified direction.

The first version uses the above getter and setter functions
    to construct a new coordinate based on the input coordinate.
In case of moving to the direction `Down`,
    the x-component stays the same and the y-component needs to be decreased by one.
We proceed with three further rules that define the behaviour for the other directions.

> moveByDirectionComplicated :: Direction -> Coordinate -> Coordinate
> moveByDirectionComplicated Down  coord = yCoordSet (dec (yCoord coord)) coord
> moveByDirectionComplicated Up    coord = yCoordSet (inc (yCoord coord)) coord
> moveByDirectionComplicated Left  coord = xCoordSet (dec (xCoord coord)) coord
> moveByDirectionComplicated Right coord = xCoordSet (inc (xCoord coord)) coord


We can simplify the above definition by using pattern matching
    instead of the explicit construction and deconstruction functions.
Pattern matching enables us to deconstruct the `Coordinate` directly
    on the left-hand side as we're already used to from `Direction`.

> moveByDirection :: Direction -> Coordinate -> Coordinate
> moveByDirection Down  (XYAxis x y) = XYAxis x (dec y)
> moveByDirection Up    (XYAxis x y) = XYAxis x (inc y)
> moveByDirection Left  (XYAxis x y) = XYAxis (dec x) y
> moveByDirection Right (XYAxis x y) = XYAxis (inc x) y

Last but not least, we try out our implementation by moving to all possible directions for the value `XYAxis 13 12`.

    λ> moveByDirection Down (XYAxis 13 12)
    XYAxis 13 11
    λ> moveByDirection Left (XYAxis 13 12)
    XYAxis 12 12
    λ> moveByDirection Up (XYAxis 13 12)
    XYAxis 13 13
    λ> moveByDirection Right (XYAxis 13 12)
    XYAxis 14 12
