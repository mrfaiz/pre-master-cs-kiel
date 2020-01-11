> {-# LANGUAGE GADTSyntax #-}
>
> module Functional.Lecture.InfiniteData where
        
 # Non-strict evaluation

 In the lecture `FunctionDefinitions` we already talked about how to evaluate expressions in Haskell and used these ideas several times when evaluating exemplary expressions.
    Haskell uses non-strict evaluation, that is, arguments of functions are only evaluated if needed (i.e., if demanded by pattern matching in the corresponding function definition) and if several functions occur in an expression to be evaluated, the outermost function is tried first.
    Thus, non-strict evaluation is often also called _outermost_ evaluation.

As a quick reminder concerning non-strict evaluation, consider the following function definitions.

    > const :: a -> b -> a
    > const x _ = x
    >
    > head :: [] a -> a
    > -- head []    = error "head: not defined for empty lists"
    > head (x:xs) = x
    >
    > (++) :: [] a -> [] a -> [] a
    > []     ++ ys = ys
    > (x:xs) ++ ys = x : (xs ++ ys)
 
The function `const` takes two arguments, ignores its second one and yields the first; the function `head` is a partial function that yields the first element of a list, if it exists, and yields `undefined` (thus, a run-time error) otherwise; the operator `(++)` concatenates two lists.

Now let us evaluate the following example.

     head ([1] ++ [2])
     ^^^^^^^^^^^^^^^^^
     { We cannot evaluate `head` yet, as we do not know if the argument matches one of the pattern in the definition,
        so we need to evaluate ([1] ++ [2]) first }
   = head ([1] ++ [2])
           ^^^^^^^^^^
     { The operator `(++)` pattern matches on its first argument:
        here, `[1]` matches the pattern `x:xs` when binding `x` to `1` and `xs` to `[]`,
        we replace the underlined expression with the right-hand side `x : (xs ++ ys)` and bindings
           x |-> 1, xs |-> [], ys |-> [2] }
   = head (1 : ([] ++ [2]))
     ^^^^^^^^^^^^^^^^^^^^^^
     { Now we can evaluate `head`, because its argument matches the pattern `x:xs` when binding `x` to `1` and
        `xs` to `([] ++ [2])`; we replace the underlined expression with the right-hand side `x` and bindings
           x |-> 1, xs |-> [] ++ [2] }
   = 1

Note that replacing the second argument of `(++)` with a potential non-terminating expression like `loop`

> loop :: a
> loop = loop

a run-time error like `undefined` or an expensive computation does not have any conseequences for the above evaluation, because the second argument pf `(++)`, here `[2]`, does not need to be evaluated.


     head ([1] ++ loop)
     ^^^^^^^^^^^^^^^^^
     { We cannot evaluate `head` yet, as we do not know if the argument matches one of the pattern in the definition,
        so we need to evaluate ([1] ++ loop) first }
   = head ([1] ++ loop)
           ^^^^^^^^^^
     { The operator `(++)` pattern matches on its first argument:
        here, `[1]` matches the pattern `x:xs` when binding `x` to `1` and `xs` to `[]`,
        we replace the underlined expression with the right-hand side `x : (xs ++ ys)` and bindings
           x |-> 1, xs |-> [], ys |-> loop }
   = head (1 : ([] ++ loop))
     ^^^^^^^^^^^^^^^^^^^^^^
     { Now we can evaluate `head`, because its argument matches the pattern `x:xs` when binding `x` to `1` and
        `xs` to `([] ++ [2])`; we replace the underlined expression with the right-hand side `x` and bindings
           x |-> 1, xs |-> [] ++ loop }
   = 1


Moreover, we do not need to take any of these evaluation steps into account if we apply the function `const 3` first.

     const 3 (head ([1] ++ [2]))
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
     { The pattern `const x y` matches with bindings
        x |-> 3, y |-> head ([1] ++ [2]) }
   = 3


That is, non-terminating expressions like `loop` can occur in our programs, but as long we do not need to evaluate them, no harm is done.

 # Infinite data
     
While an expression like `loop` does not feel that useful, there a other non-terminating expression that come in handy.
  Due to Haskell's non-strictness, a non-terminating expression can express infinite data, which simplifies seperation of concerns: the computation of data and how to process the data afterwards can be expressed using seperate functions.
  Haskell's non-strict evaluation strategy then interlocks both functions again.

Consider, for example, a list of infinite many numbers starting with zero.

> nats :: [] Int
> nats = help 0
>  where help n = n : help (n + 1)

Evaluating `nats` is not the best idea: it does not terminate.
  We can, however, define a function `take` that yields a prefix of a list; it is predefined in Haskell as follows.

    > take :: Int -> [] a -> [] a
    > take 0 _            = []
    > take _ []           = []
    > take n (val : vals) = val : take (n-1) vals

The function `take` takes as many elements from the given the list as the first argument demands, or if the length of the list is smaller than the first argument, it yields the entire list.

    $> take 5 [1,2,3]
    [1,2,3]
    $> take 5 [1,2,3,4,5,6,7]
    [1,2,3,4,5]
    $> take 5 nats
    [0,1,2,3,4]

Let's take a look at the evaluation of shorter example.

     take 2 nats
     ^^^^^^^^^^^^
   = { As the first argument is not `0`, `take` has to pattern match its second argument: we need to know if `nats` is empty or not }
     take 2 nats
             ^^^^
   = { Definition of `nats` }
     take 2 (0 : help (0 + 1))
     ^^^^^^^^^^^^^^^^^^^^^^^^^^
   = { The third rule matches with bindings
       n |-> 2, val |-> 0, vals |-> help (0 + 1) }
     0 : take (2-1) (help (0 + 1))
         ^^^^^^^^^^^^^^^^^^^^^^^^^^
   = { We need to evaluate the first argument to know if the first rule matches }
     0 : take (2-1) (help (0 + 1))
               ^^^^^
   = 0 : take 1 (help (0 + 1))
         ^^^^^^^^^^^^^^^^^^^^^^
   = { As the first argument is not `0`, `take` has to pattern match its second argument: we need to know if `nats` is empty or not }
     0 : take 1 (help (0 + 1))
                 ^^^^^^^^^^^^^^
   = { Definition of `help` }
     0 : take 1 ((0+1) : help ((0 + 1) + 1))
         ^^^^^^^^^^^^^^^^^^^^^^^^^^
   = { The third rule matches with bindings
       n |-> 1, val |-> (0+1), vals |-> help ((0 + 1) + 1) }
     0 : (0+1) : take (1-1) (help ((0 + 1) + 1))
         ^^^^^
   = { The left-most outermost expression to evaluate next is `(0+1)` }
     0 : 1 : take (1-1) (help ((0 + 1) + 1))
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   = { `take` needs to evaluate its first argument }
     0 : 1 : take (1-1) (help ((0 + 1) + 1))
                   ^^^^^
   = 0 : 1 : take 0 (help ((0 + 1) + 1))
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   = { The first rule of `take` matches }
     0 : 1 : []
   = [0,1]

        
As long as we have a function that processes only a terminating prefix of the non-terminating list, it can be quite useful.

Consider the following function `zip`, which is predefined in Haskell.

    > zip :: [] a -> [] b -> [] ((,) a b)
    > zip []     _      = []
    > zip _      []     = []
    > zip (x:xs) (y:ys) = (x,y) : zip xs ys

Given two lists, we pair them up elementwise: if one of the lists terminates, the resulting lists terminates as well.

Using `zip` and `nats`, we can implement a function that takes a list and labels them with their index by yielding a pair of the original value and its index.

> numberedList :: [] a -> [] ((,) a Int)
> numberedList list = zip list nats

We can pair each element of a list with `True` as follows.

> assignTrue :: [] a -> [] ((,) a Bool)
> assignTrue list = zip list trues
>  where trues = True : trues

In Haskell we can also use a predefined function `repeat :: a -> [] a` that computes a list that contains the given value infinitely often.

    > repeat :: a -> [] a
    > repeat x = x : repeat x

That is, instead of using a local function defintion we can define `assignFalse`, a function that pairs each element of a given list with `False` as follows.

> assignFalse :: [] a -> [] ((,) a Bool)
> assignFalse list = zip list (repeat False)

As long as the arguments of `numberedList`, `assignTrue` and `assignFalse` terminate, the overall computation will terminate as well as though we use `zip` with an infinite list as second argument.
   The crucial point here is that functions like `repeat`, `nats` or `trues` are non-terminating functions that produce data while the functions `loop` is merely non-terminating that does not do any process during evaluation.
   Due to this difference, we say that functions like `repeat`, `nats` and `trues` describe infinite data, while `loop` is merely a non-terminating function.

 # For the interested reader...
   
A more practical usage of infinite data in Haskell are applications of dynamic programming: computing values once and reusing them when possible; this principle is often called _memoisation_ in the field of declarative (and functional) programming.

Let's take a look at an efficient computation of fibonacci numbers.
  The intuitive idea is to compute an infinite list of all fibonacci numbers and reuse already computed results when computing new ones.
  This scheme is especially helpful when computing fibonacci numbers as a fibonacci number depends on its two predecessors.
  As a reminder, consider the following straightfoward implementation.

> fib :: Int -> Int
> fib 0 = 0
> fib 1 = 1
> fib n = fib (n-1) + fib (n-2)

Instead we can define an infinite list of all fibonacci numbers and reuse the ones we have already computed by accessing the corresponding number specified by its index.
  
> fibMemo :: Int -> Integer
> fibMemo n = fibs !! n
>
> fibs :: [Integer]
> fibs = 0 : 1 : map (\n -> fibMemo (n-2) + fibMemo (n-1)) [2..]
