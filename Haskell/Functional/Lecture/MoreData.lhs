> {-# LANGUAGE GADTSyntax #-}
> 
> module Functional.Lecture.MoreData where


 # Small Recap
  
As we already defined some useful data types and functions last week, we'll resuse them by importing the corresponding module. 
We already discussed last week that two constructor names of type `Direction` clash with constructors that are already predefined in Haskell.
   Therefore, we'll use a _qualified import_ statement so that we can still reuse all the definitions from last week, but need to use the prefix `Data.` for each type, constructor or function we use.
   That is, instead of writing solely the constructor name `Right`, we need to write `Data.Right`.

> import qualified Functional.Lecture.DataAndFunctions as Data


Make sure that you start GHCi on the top-level directory of the repository, so that the module paths are solved correctly.

    $> ls
    Concurrency    Functional    README.md
    $> ghci
    GHCi, version 8.6.5: http://www.haskell.org/ghc/  :? for help
    Prelude> :l Functional.Lecture.MoreData

We have seen two custom defined data types last week: `Direction` and `Coordinate`.

    ```
    data Direction where
      Up    :: Direction
      Down  :: Direction
      Left  :: Direction
      Right :: Direction
    
    data Coordinate where
      XYAxis :: Integer -> Integer -> Coordinate
    ```

The data type `Direction` has four different constructors; all of them do not have any arguments, they are nullary constructors.
    The data type `Coordinate` on the other hand has just one constructor `XYAxis` that takes two `Integer` values as arguments in order to yield a value of type `Coordinate`.
    The arguments of `XYAxis` need to be applied in order to construct a valid value (see the definition of `coordinateValue` below); we can also use this information about the necessary arguments of `XYAxis` for deconstruction in case of pattern matching (see the definition of `xCoordinate`).
    Note that we need to use the qualified names `Data.Coordinate`, `Data.XYAxis` etc as explained in the beginning.

> coordinateValue :: Data.Coordinate
> coordinateValue = Data.XYAxis 42 1337
>
> xCoordinate :: Data.Coordinate -> Integer
> xCoordinate (Data.XYAxis x y) = x

  
    MoreData> coordinateValue
    XYAxis 42 1337
    MoreData> xCoordinate coordinateValue
    42

In order to have yet another type to work with, we'll use the predefined `Bool`.
   As common in (hopefully) all programming languages, there are two different values of type `Bool`.

   ```
   data Bool where
     True  :: Bool
     False :: Bool
   ```
Each of these (again) nullary constructors represents one possible value of type `Bool`.

Last but not least, we'll use the follwing type `One` that has only one constructor.

> data One where
>   OneC :: One
>   deriving Show


 # Counting Values
   
     As `One, `Bool` and `Data.Direction` do not have that many different values, we can define constant functions to list all these possible values.

> one1 :: One
> one1 = OneC

There is just one way to construct a value of type `One`...
    
> bool1 :: Bool
> bool1 = True
> 
> bool2 :: Bool
> bool2 = False

...there are two different values to construct a value of type `Bool`...

> dir1 :: Data.Direction
> dir1 = Data.Up
> 
> dir2 :: Data.Direction
> dir2 = Data.Down
> 
> dir3 :: Data.Direction
> dir3 = Data.Right
> 
> dir4 :: Data.Direction
> dir4 = Data.Left

...and four different values of type `Data.Direction`.

Hence, for data types with nullary constructors only it is pretty simple to count the number of different values we can construct of that type: we just need to count the numbers of constructors!

 ## Product types
       
In case of `Data.Coordinate` we have a constructor with arguments, so the counting procedure looks a bit different.
   Let us take a the following data type that represents a pair of `Bool`ean and `Data.Direction` values.

> data PairBD where
>   BoolAndDirection :: Bool -> Data.Direction -> PairBD
>  deriving Show

Using the constant functions of type `Bool` and `Data.Direction` above, we can now construct all possible values of type `PairBD`.
   As the first argument of the constructor `BoolAndDirection` needs to be of type `Bool`, we'll use `bool1` for the first four values and use one of the `Data.Direction` values as second argument.
   
> pair1 :: PairBD
> pair1 = BoolAndDirection bool1 dir1
> 
> pair2 :: PairBD
> pair2 = BoolAndDirection bool1 dir2
> 
> pair3 :: PairBD
> pair3 = BoolAndDirection bool1 dir3
> 
> pair4 :: PairBD
> pair4 = BoolAndDirection bool1 dir4

We list give yet another four values by using `bool2` instead of `bool1` as first argument!
         
> pair5 :: PairBD
> pair5 = BoolAndDirection bool2 dir1
> 
> pair6 :: PairBD
> pair6 = BoolAndDirection bool2 dir2
> 
> pair7 :: PairBD
> pair7 = BoolAndDirection bool2 dir3
> 
> pair8 :: PairBD
> pair8 = BoolAndDirection bool2 dir4

In total we have 8 values of type `PairBD`.
   You might see a connection between the number of `Bool`ean and `Direction` values.
   Let's make sure that this connection becomes more obvious by checking yet another data type: a pair of two `Bool`s.

> data PairBB where
>   BoolAndBool :: Bool -> Bool -> PairBB
>  deriving Show
>
> pairB1 :: PairBB
> pairB1 = BoolAndBool bool1 bool1
>
> pairB2 :: PairBB
> pairB2 = BoolAndBool bool1 bool2
>
> pairB3 :: PairBB
> pairB3 = BoolAndBool bool2 bool1
>
> pairB4 :: PairBB
> pairB4 = BoolAndBool bool2 bool2

This time we have constructed 4 different values.
We can observe that the values of type like `PairBB` and PairBD` with one constructor that takes multiple arguments follows from the type of its arguments.
   In case of `PairDB` we have `|Bool| * |Data.Direction| = 2 * 4 = 8` possible values, because for each possible values for the first component of type `Bool` (|Bool| ~ 2) we can construct a value of type `PairDB` with each possible value of type `Data.Direction` (|Data.Direction| ~ 4).
   The same reasoning applies for `PairBB`: we can construct `|Bool| * |Bool| = 2 * 2 = 4` different values when using `Bool`s in both components.

Types like `PairBB` and `PairDB` with one constructor with an arity greater than 1 (that is, with more than one argument) are often called _product types_: the name originates from the counting scheme we just observed, the number of values for the n-ary constructor is the product of the number of values for each of the arguments types.

In Haskell, there is already a predefined data type for products: we can define pair, or more general, n-tuples by using parentheses and commas: `(,)`, `(,,)`, `(,,,)`.

   ```
   data (,) a b where
     (,) :: a -> b -> (,) a b

   data (,,) a b c where
     (,,) :: a -> b -> c -> (,,) a b c

   data (,,,) a b c d where
     (,,,) :: a -> b -> c -> d -> (,,) a b c d
   ```

These definitions for n-tuples are so-called _polymorphic data types_: in addition to the name of the type (e.g., for pairs: `(,)`) they have two additional _type variables_.
   We can instantiate these type variables with concrete types when constructing values the same we pass arguments to function in order to yield a value.
   That is, `(,)` is a _type function_ that expects two types as arguments in order yield a type, which works analogue to a function like `(+)` that expects two `Integer` values in order to yield an `Integer` value.
   The only difference is that the former concerns the type-level, so we will only see such construction in type signatures, while the latter is used on value-level, such that we'll see such that application on the right-hand side of a function definition.

For our examplary type above, we can instantiate the type variables `a` and `b` with `Bool` and `Data.Direction` in order to have type isomorphic to `PairBD` and with `Bool` and `Bool` to have a type isomorphic to `PairBoolAndBool`, respectively.

    PairBD ~ (Bool,Data.Direction)
    PairBB ~ (Bool,Bool)

What does it mean if we say that a data type is isomorphic to another one?
   If a data type `A` is isomorphic to a type `B`, we can define functions `aToB :: A -> B` and `bToA :: B -> A` that fulfill the following to properties.

   (1) forall (x :: A), bToA (aToB x) = x
   (2) forall (y :: B), aToB (bToA y) = y

Let's define these functions for `PairBD`.
   
> pairBDToPair :: PairBD -> (Bool, Data.Direction)
> pairBDToPair (BoolAndDirection b dir) = (b, dir)
>
> pairToPairBD :: (Bool, Data.Direction) -> PairBD
> pairToPairBD (b,dir) = BoolAndDirection b dir

Next, we'll need to check if the properties above hold -- we'll post-pone this idea until the next lecture.


 ## Sum types
      
Besides these product types, there are also _sum types_.
   When we have a data type with multiple constructors that have at least one argument, then we need to sum up the possible values for each constructor in order to come to the total numbers of values for the defined type.
   Consider the following data type.

> data SelectBD where
>   SelectBDBool      :: Bool           -> SelectBD
>   SelectBDDirection :: Data.Direction -> SelectBD
>
> selBD1 :: SelectBD
> selBD1 = SelectBDBool bool1
>
> selBD2 :: SelectBD
> selBD2 = SelectBDBool bool2
>
> selBD3 :: SelectBD
> selBD3 = SelectBDDirection dir1
>
> selBD4 :: SelectBD
> selBD4 = SelectBDDirection dir2
>
> selBD5 :: SelectBD
> selBD5 = SelectBDDirection dir3
>
> selBD6 :: SelectBD
> selBD6 = SelectBDDirection dir4

We can _either_ use the constructor `SelectBDBool` and apply a value of type `Bool` as argument _or_ we use the constructor `SelectBDDirection` and apply a value of type `Data.Direction` to construct a value of type `SelectBD`.
   In order to get a better feeling for a pattern here, we take a look at a second data type where we switch the `SelectBDDirection` with a constructor with a different argument type.
    
> data SelectBO where
>   SelectBOBool :: Bool -> SelectBO
>   SelectBOOne  :: One  -> SelectBO
>
> selBO1 :: SelectBO
> selBO1 = SelectBOBool bool1
>
> selBO2 :: SelectBO
> selBO2 = SelectBOBool bool2
>
> selBO3 :: SelectBO
> selBO3 = SelectBOOne one1

As teasered above: we need to add up the possible values for each constructor in order to count the number of total values for a sum type like `SelectBD` and `SelectBO`.

   |SelectBD| = |Bool|             to count the values constructable with `SelectBDBool`
              + |Data.Direction|   to count the values constructable with `SelectBDDirection`
              = 2 + 4
              = 6
      
   |SelectBO| = |Bool|             to count the values constructable with `SelectBOBool`
              + |One|              to count the values constructable with `SelectBOOne`
              = 2 + 1
              = 3

Yet again, this kind of sum type is already predefined in Haskell, the data type definition looks as follows.

    ```
    data Either a b where
      Left  :: a -> Either a b
      Right :: b -> Either a b
    ```

Note that `Left` and `Right` are not the constructors of type `Data.Direction` that we defined last week, these constructors are visible using the `Data.`-prefix, that is by using `Data.Right` and `Data.Left`.
   `Either` is again a polymorhic data type with two type variables `a` and `b`: the `Left` constructor can be used to constructor a value of type `Either a b` that holds a value of type `a` and the constructor `Right` can be used to if the value should contain a value of type `b`.
   Again, our previously defined sum types `SelectBD` and `SelectBO` are isomorphic to instantiations of type `Either a b` with sutiable types for the type variables `a` and `b`.

    SelectBD ~ Either Bool Data.Direction
    SelectBO ~ Either Bool One

Due to these schemes to count the number of possible values, we name the data types we can define in Haskell _algebraic data types_: we have an operation for addition (sum types) and multiplication (product types) that are usually connected to an Algebra in mathematics.
 
A cool thing about Haskell now is that we can mix these sum and product types as much as we like.
  We can for example define the following crazy data type `Example` with a nullary, unary, binary and ternary constructor.
 
> data Example where
>   Nullary   ::                                  Example
>   OneArg    :: Bool ->                          Example
>   TwoArgs   :: One  -> Bool           ->        Example
>   ThreeArgs :: Bool -> Data.Direction -> One -> Example

We can use the schemes from above to count the number of values!
     
     |Example| = 1                                    the values constructable with `Nullary`
               + |Bool|                               to count the values constructable with `OneArg`
               + |One|  * |Bool|                      to count the values constructable with `TwoArgs`
               + |Bool| * |Data.Direction| * |One|    to count the values constructable with `ThreeArgs`
               = 2 * 4 * 1 + 1 + 1 * 2 + 2
               = 13


 # Type Synonyms

Besides defining new data types, Haskell allows the definition of _type synonyms_ in order to use already existing types using a different name.
   For example, we can define a type synonym `SelectBOSynonym` as an abbreviation for `Either Bool One` and `PairBDSynonym` for `(Bool, Direction)`.

> type SelectBOSynonym = Either Bool One
> type PairBDSynonym   = (Bool,Data.Direction)

As a less artificial example, we can think about our coordination system and `move` function from last week again: maybe it might be useful to give bounds for the coordination system. A valid move can then only occur withing these bounds.
   Such bounds can be defined by using two `Integer` value: one for maximum and one for the minumum valid value.

> type Bounds = (Integer,Integer)
> 

Using the following predefined operators in Haskell to compare `Integer` values as well as to compare `Bool`ean values

    ```
    (<=) :: Int -> Int -> Bool
    (>=) :: Int -> Int -> Bool

    (&&) :: Bool -> Bool -> Bool
    ```

 we can define the function `inBounds` to indicate if a given value `x` is within given `Bounds`.

> inBounds :: Integer -> Bounds -> Bool
> inBounds x (xMax, xMin) =
>   -- (&&) ((<=) x xMax) ((>=) x xMin)
>   -- ((<=) x xMax) && ((>=) x xMin)
>   -- (x <= xMax) && ((>=) x xMin)
>   (x <= xMax) && (x >= xMin)

We can check out the behaviour of `inBound` in the REPL.

    MoreData> inBound 42 (132, 26)
    True
    MoreData> inBound 142 (132, 26)
    False
    MoreData> inBound 12 (132, 26)
    False

 # Operators and infix notation

 Functional applications in Haskell is written using juxtaposition: we write the function in prefix position and give all arguments seperates by whitespace(s).
  In case of operators like `(+)`, `(<=)` and `(&&)` we use infix notation, if we want to use these operators in prefix notation we need to use parentheses!
  Operators are special functions: they are named with special characters only.
  We can, however, also use every ordinary function named with alphanumeric characters in infix notation!
  In order to use infix notation wiht ordinary function names we need to surround them with backticks: ``.
  For example, the application from above look as follows using infix notation.

    MoreData> 42 `inBounds` (132, 26)
    True
    MoreData> 142 `inBounds` (132, 26)
    False
    MoreData> 12 `inBounds` (132, 26)
    False

Sometimes the infix notation is a convenient way to write such expression, because the whole expression reads a bit like an ordinary english sentence.
