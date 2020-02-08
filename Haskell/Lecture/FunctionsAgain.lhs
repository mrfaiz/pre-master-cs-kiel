> {-# LANGUAGE GADTSyntax #-}
>
> module Functional.Lecture.FunctionsAgain where

Let's revisit functions again!
    We have talked about higher-order functions, that is, functions that have functions as argument.
    Besides passing functions as arguments, we can also yield functions as result.


 # Function composition
    
A good example for returning a function as result is the concept of _function composition_.
    Function composition is a higher-order function of type `(b -> c) -> (a -> b) -> (a -> c)`.
    That is, it takes two functions as arguments and yields a function as result by combining both functions on the possible input value.
    Let's try to define such a function.

   > compose :: (b -> c) -> (a -> b) -> (a -> c)
   > -- f :: (b -> c)
   > -- g :: (a -> b)
   > compose f g = \x -> ...
                   ^^^   ^^^^^^
                   :: a   :: c
                  ^^^^^^^^^^^^^^
                    :: a -> c

Having a function `g` of type `a -> b` and a value `x` of type `a` withing the lambda function, we can construct a value of type `b` by applying `g` to `x`.

   > compose f g = \x -> ... (g x)
                   ^^^       ^^^^^
                   :: a       :: b
                         ^^^^^^^^^^
                            :: c
                  ^^^^^^^^^^^^^^^^^^
                     :: a -> c

Now we have a value of type `b` but need to produce something of type `c`.
    Luckily, we have a function `f` of type `b -> c` that fits the job description perfectly.
    
   > compose f g = \x -> f (g x)
                   ^^^     ^^^^^
                   :: a    :: b
                         ^^^^^^^^^^
                          :: c
                  ^^^^^^^^^^^^^^^^^^
                     :: a -> c

That's how we can define the function `compose`.

> compose :: (b -> c) -> (a -> b) -> (a -> c)
> compose f g = \x -> f (g x)

In Haskell the functionality of `compose` is already predefined as the operator `(.)`.

The function composition operator comes in handy when we want to combine predefined functions into more complex functions, especially in the context of higher-order functions.
Let's define the following two functions to increment a number and compute the square, respectively.

> inc :: Int -> Int
> inc x = x + 1
>
> square :: Int -> Int
> square x = x * x

Let's say we do not want to define a third function, but use these two function to increment a number and then compute the square of that result for all elements in a list -- or the other way around.
    We can do this by using two calls of `map`, that is, by traversing the list two times.
  
    $> map square (map inc [1,2,3,4,5])
    [4,9,16,25,36]
    $> map inc (map square [1,2,3,4,5])
    [2,5,10,17,26]

Another way to implement the same behaviour is to use function composition: given one of the list elements as input, we want to apply the function `inc` and then the function `square` on the argument (and vice versa for the second example).
    That is, we use the composed function `square . inc` for the first example and `inc . square` as functional argument for second example.

    $> map (square . inc) [1,2,3,4,5]
    [4,9,16,25,36]
    $> map (inc . square) [1,2,3,4,5]
    [2,5,10,17,26]


 # Currying

 Asking GHCi for the type of `(.)` reveals the following.

    $> :t (.)
    (.) :: (b -> c) -> (a -> b) -> a -> c

The last pair of parentheses is missing!
    What's going on here?
    The type constructor `->` we use in type signatures associates to the right!

    $> :i (->)
    data (->) t1 t2
    infixr 0 `(->)`

That is a binary function like

> add :: Int -> Int -> Int
> add x y = x + y

cal also be seen as a unary function that yields a function as result.

    add :: Int -> Int -> Int

    is the same as
    
    add :: Int -> (Int -> Int)

In Haskell, we can say that every function takes only one argument: the result can then be a value or a function.
    In case of `add` the result is a function of type `Int -> Int`, in case of `square` and `inc` it's a value of type `Int`.

Note that while the function arrow `->` is right-associative, function application is left-associative!
    That is, `add 1 2` is the same as writing `(add 1) 2`.
    The second expression makes the fact that `add` can be seen as a unary function that yields a function more clearly.
    We apply `add` to `1` and get a function that is then applied to the argument `2`.
    That is, `add 1` is of type `Int -> Int`, that's why we can then apply it to the value `2`.
    In the same sense, a lambda function `\x y -> x + y` is the same as writing `\x -> (\y -> x + y)` (note, that we do not need to use parentheses here).

In the end, we can give an alternative definition of `compose` as follows.

> compose' :: (b -> c) -> (a -> b) -> (a -> c)
> compose' f g x = f (g x)

Instead of yielding a function, thus, introducing a lambda function on the right-hand side, we interpret the first argument of the resulting type `a -> c` as input type `a` to our function.

The idea of representing n-ary functions as unary function that yields function as result is called _currying_.


 # Partial application
    
The advantage of currying becomes more apparent when combined with the concept of _partial application_.
    Since we can think of all functions as unary functions, even though they expect, for example, three arguments, it's feel natural to apply functions to only one argument (instead of all three).

For example, the expression `take 5` is a function of type `[] a -> [] a` that expects a list as argument and yields the first 5 elements for that list.

> take5 :: [] a -> [] a
> take5 = take 5

    $> take5 [1,2,3,4,5,6,7,8,9,10]
    [1,2,3,4,5]

The most common usage for partial function applications are higher-order functions.
    Instead of giving a lambda function as argument that defines an anonymous function for that need only, we reuse predefined function, but specialise them by partially applying them to their first argument.

The following three examples all yield the same result, because the function we use as argument are the same (but specified differently).

    $> map (\x -> x + 1) [1,2,3,4]
    [2,3,4,5]
    $> map ((+) 1) [1,2,3,4]
    [2,3,4,5]
    $> map (add 1) [1,2,3,4]
    [2,3,4,5]

The following two examples also yield the same value.

    $> map (\x -> 42) [1,2,3,4]
    [42,42,42,42]
    $> map (const 42) [1,2,3,4]

Here, `const` is a predefined function that takes two arguments and yields its first one.

      > const :: a -> b -> a
      > const x _ = x


We can also use `(+)` as argument to `map` without applying it to any arguments.

    $> :t map (+)
    map (+) :: [] Int -> [] (Int -> Int)

Now Haskell yields a list of functions when we apply the above expression to a list of integer.
    We can then again uses these functions that are within the list and apply them to a value.

    $> map (\f -> f 5) (map (+) [1,2,3,4])
    [6,7,8,9]

Intuitively, the expression `map (+) [1,2,3,4]` constructs a list of functions (here, `(+)` is a partially applied to the the corresponding element of the list): `[(+) 1, (+) 2, (+) 3, (+) 4]`.
    Then the surrounding `map`-call then iterates of this list of function and yields `f 5` for each function `f` of that list.
    That is, in the end we have computed the list `[(+) 1 5, (+) 2 5, (+) 3 5, (+) 4] 5`.

We can also construct a list of functions on top-level.

> intPredicates :: [] (Int -> Bool)
> intPredicates = [\x -> True, \x -> x > 4, (>) 12, \x -> not (x == 5)]

Using a helper function that computes the conjunction of all boolean values of a list

> andList :: [Bool] -> Bool
> andList []        = True
> andList (b:bools) = b && andList bools

we can then test if a value meets all conditions listed in `intPredicates`.

    $> andList (map (\pred -> pred 4) intPredicates)
    False
    $> andList (map (\pred -> pred 15) intPredicates)
    False
    $> andList (map (\pred -> pred 6) intPredicates)
    True
    $> andList (map (\pred -> pred 10) intPredicates)
    True
    $> andList (map (\pred -> pred 5) intPredicates)
    False

