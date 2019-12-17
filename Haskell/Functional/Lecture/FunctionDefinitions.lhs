> {-# LANGUAGE GADTSyntax #-}
> 
> module Functional.Lecture.FunctionDefinitions where


 # Small Recap
  
Last week we have seen and declared some more data types.
     In order to reuse them this week, we'll import the corresponding modules.
     As last week, we'll do a _qualified import_ that says that all definitions of these modules are available using a given prefix.
     In this case we'll use the prefix _Data_ for both modules: we can use the same for both modules, because we do not have any name clashes.

> import qualified Functional.Lecture.DataAndFunctions as Data
> import qualified Functional.Lecture.MoreData as Data
     
In order for this imports to work as expected, make sure that you start GHCi on the top-level directory of the repository, so that the module paths are solved correctly.

    $> ls
    Concurrency    Functional    README.md
    $> ghci
    GHCi, version 8.6.5: http://www.haskell.org/ghc/  :? for help
    Prelude> :l Functional.Lecture.FunctionDefinitions
    
One predefined type we talked about last week was the type `Bool` to represent Boolean values.

    ```
    data Bool where
      True  :: Bool
      False :: Bool
    ```

Haskell brings several predefined operations for `Bool`ean values: a disjunction and conjunction operator as well as a function tonegate a given `Bool`ean value.

    ```
    (&&) :: Bool -> Bool -> Bool
    (||) :: Bool -> Bool -> Bool
    not  :: Bool -> Bool
    ```

Let us define some exemplary expressions using these operators.

> boolEx1 :: Bool
> boolEx1 = True && False
>
> boolEx2 :: Bool
> boolEx2 = not (True || False)
>
> boolEx3 :: Bool
> boolEx3 = False && True || True

> boolEx4 :: Bool
> boolEx4 = False && (True || True)

We can run these examples in the REPL to check their results.
  
    FunctionDefinitions> boolEx1
    False
    FunctionDefinitions> boolEx2
    False
    FunctionDefinitions> boolEx3
    False
    FunctionDefinitions> boolEx4
    True

When running the last two examples we notice that the expressions do not have the same results.
     This observation indicates that `boolEx3` can be read as `(False && True) || True`, that is, the disjunction has a higher precedence than the conjuction.
     We can actually check these precedences in the REPL using the command `:i` and the definition we want to have some _i_nformation about.

    FunctionDefinitions> :i (&&)
    (&&) :: Bool -> Bool -> Bool 	-- Defined in ‘GHC.Classes’
    infixr 3 &&
    FunctionDefinitions> :i (||)
    (||) :: Bool -> Bool -> Bool 	-- Defined in ‘GHC.Classes’
    infixr 2 ||
    
Besides the full type signature in the first line of the answer, we get information about the fixity and the precedence of the operator: the disjunction operator `(&&)` is an infix operator with right-associativity and a precendence of 3.
     The conjunction operator `(||)` on the other hand has a precedence of 2, but is also right-associative and an infix operator.
     Only for operators (that is, function defined using special characters only) we have these precedence and associatity options.
     So, in our example `boolEx3` above, the operator with the higher precendence --- `(&&)` --- will be evaluated first, because it is used as first argument for `(||)`.
     That is, the expression `boolEx3` is not equivalent to `boolEx4`, where we explicitly use parentheses for the conjunction in order to pass it as second argument to `(&&)`.

Let's quickly discuss associativity of operations before we take a look at the definitions of the above operators.
      For a right-associative operator like `(&&)` we know that the following equation holds for all `Bool`ean values `b1`, `b2` and `b3`.

      b1 && b2 && b3 = b1 && (b2 && b3)

The operation `(+)`, on the other hand, is left-associative; that is, the follows equation holds for all numeric values `n`, `m` and `o`.

    n + m + o = (n + m) + o

The conjunction and disjunction operations as well as the function `not` are predefined using pattern matching as follows.

    ```
    (&&) :: Bool -> Bool -> Bool
    True  && x = x
    False && _ = False

    (||) :: Bool -> Bool -> Bool
    False || x = x
    True  || _ = True

    not :: Bool -> Bool
    not True  = False
    not False = True
    ```

In both cases we need to pattern match on the first argument in order to decide which result to yield.
   Let us evaluate the examples from above step-by-step; we highlight the expression we need to evaluate next using `^^^^`.

      boolEx1
      ^^^^^^^
    = { definition of `boolEx1` }
      True && False
      ^^^^^^^^^^^^^
    = { definition for `(&&)`: first rule with `x` bound to `False` }
    = False

When we evaluate the expression `True && False`, we check the definition of `(&&)`.
     The first rule `True && x = x` matches because we have `True` as first argument.
     Our second argument `False` matches the variable pattern `x`: so we can apply the first rule.
     That is, we can replace the expression `True && False` with the left-hand side of the first rule of `(&&)`; note that the variable pattern `x` is bound to `False` now.
     That is, we finally yield `False` as result.
   
      boolEx2
      ^^^^^^^
    = { definition of `boolEx2` }
      not (True || False)
      ^^^^^^^^^^^^^^^^^^^
    = { definition of `not`: cannot be applied, first argument is demanded}
      not (True || False)
          ^^^^^^^^^^^^^^^
    = { definition of `(||)`: second rule without binding any variables }
      not True
      ^^^^^^^^
    = { definition of `not`: first rule }
      False

In Haskell, when we have an expression with several function applications, we try to evaluate the outermost function first, and proceed to more inner function applications only if the outer function cannot be evaluated.
     Here, we want to evaluate `not` first.
     In order to know which rule to choose to evaluate `not`, the argument of `not` needs to be evaluated to either `True` or `False` first.
     That is, we cannot evaluate `not` right now.
     Instead we proceed to its argument `(True || False)`, because the definition of `not` _demands_ that we need to evaluate it first before we can proceed.
     We can then take the second rule for `(||)` as our first argument matches `True`, the second argument is not important, there is not variable to bind, we can directly replace the expression `True || False` with `True` as the rule commands.
     Now we have the expression `not True` in place that we can evaluate further by using the definition of `not`.
     Here, the first rule applies such that we replace `not True` by the right-hand side of the first rule, yielding `False`.

The same rule apply for the examples `boolEx3` and `boolEx4`, we will give the evaluation steps for the former and leave the latter as exercise.

      boolEx3
      ^^^^^^^
    = { definition of `boolEx3` }
      False && True || True
      ^^^^^^^^^^^^^^^^^^^^^
    = { definition of `(||)`: cannot be applied, first argument is demanded}
      False && True || True
      ^^^^^^^^^^^^^
    = { definition of `(&&)`: second rule }
      False || True
      ^^^^^^^^^^^^^
    = { definition of `(||)`: first rule with `x` bound to `True` }
      True

    
Let's proceed by defining our own function on `Bool`.
      Besides negation, conjuction and disjunction another prominent operator on Boolean values is an implication.
      We write a binary function `imp` that behaves like the implication operation on Boolean values.
      As a small recap, how does the truth table for implication look like?

      |   X   |   Y   | X => Y |
      --------------------------
      | True  | True  | True   |
      | True  | False | False  |
      | False | True  | True   | 
      | False | False | True   |

We can directly translate this truth table into a definition via pattern matching in Haskell.

> imp :: Bool -> Bool -> Bool
> imp True  True  = True
> imp True  False = False
> imp False True  = True
> imp False False = True

As we have seen for the predefined implementations of `(&&)` and `(||)`, we can simplify the pattern matching in case one argument already determines the resulting value.
   In case of `imp` we can observe that `True` as first argument will yield the second argument as result, and otherwise, that is, for `False`, the function yields `True`.

> impSimplified :: Bool -> Bool -> Bool
> impSimplified True  y = y
> impSimplified False _ = True

Since we are deciding what result to yield based on a value of type `Bool`, we can use an if-then-else-expression instead of pattern matching as well.
      In Haskell an if-then-else expression takes three arguments: the first one is a `Bool`, and the second and third value need to be of the same type.
      For exmaple, the above definintion of `impSimplified` looks as follows using an if-then-else-expression.
  
> impIf :: Bool -> Bool -> Bool
> impIf x y = if x then y else True

It is important to keep in mind that expression in the `then`- and `else`-branch need to be of the same type.
   The following expression would yield a type error when trying to run the program (a type error is a compile-time error, not a run-time error!).

    FunctionDefinitions> if True then Data.XYAxis 42 12 else Data.Left
    <interactive>:30:37-45: error:
        • Couldn't match expected type ‘Data.Coordinate’
                      with actual type ‘Data.Direction’
        • In the expression: Data.Left
          In the expression: if True then Data.XYAxis 42 12 else Data.Left
          In an equation for ‘it’:
              it = if True then Data.XYAxis 42 12 else Data.Left

    `if b then e1 else e2` is type-correct when `b :: Bool`, `e1 :: <SomeType>` and `e2 :: <SomeType>` where `<SomeType>` can be an arbitrary type, but it is important that the types of `e1` and `e2` are the same!

Moreover, we can reuse the functions we already know.
    Since the implication `X => Y` is equivalent to the formula `not X \/ Y`, we can implement an alternative definition using `not` and `(||)` based on this equivalence.

> impDirect :: Bool -> Bool -> Bool
> impDirect x y = not x || y

Sometimes it's more convenient to define helper functions (or constants) to clean up the code.

> impDirectHelp :: Bool -> Bool -> Bool
> impDirectHelp x y = notX || y
>  where notX = not x
  
Here, `notX` is a local (constant) function: we can use all variables introduced in the left-hand side of the top-level definition on the right-hand side of local functions.
     Furthermore, when we define local functions that take arguments, we can use pattern matching as we are used to from top-level definitions.

> impWithLocalNot :: Bool -> Bool -> Bool
> impWithLocalNot x y = notLocal x || y
>  where notLocal True  = False
>        notLocal False = True

For such definitions it is important that all rules of the local function definitions (as well as all other function definitions) have the same left-side indentation.
    That is, we can define the above function also as follows.
     
> impWithLocalNot2 :: Bool -> Bool -> Bool
> impWithLocalNot2 x y = notLocal x || y
>  where
>    notLocal True  = False
>    notLocal False = True

Note that the `where`-keyword as well as the following local function definitions needsto be indented by at least one whitespace.

No matter how we define the implication function, we might want use it as operator that looks like the symbol from logic.
   That is, last but not least, we define the operator `(==>) :: Bool -> Bool -> Bool` and give the operation a precedence lower than `(&&)` and `(||)` in order to not only make formulas look like in logic, they should also behave as expected.
   Furthermore, we define the operator as being right-associative as are `(&&)` and `(||)` as well.

> infixr 1 ==>
> (==>) :: Bool -> Bool -> Bool
> b1 ==> b2 = imp b1 b2

The line `infixr 1 ==>` specifies that the operator `(==>)` is right-associative and has precedence of level 1, when used as infix operator.
    Note that we can use operators in infix position when specifying a rule, that is, instead of writing

         (==>) b1 b2 = imp b1 b2

     we are allowed to write the above version that uses `(==>)` as infix operator as follows.

        b1 ==> b2 = imp b1 b2
