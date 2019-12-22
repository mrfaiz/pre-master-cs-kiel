> {-# LANGUAGE GADTSyntax #-}
>
> module Functional.Lecture.Polymorphism where


 # Polymorphic data types
  
In the last lecture we discussed how to abstract repetitive schemes that occur all over our code again using higher-order functions.
   A different kind of abstraction mechanism commonly used in functional programming languages is polymorphism.
   Instead of writing a data type like `CoordMap` that represents a list-like structure for `Coordinate`s, a data type `Row` that contains `Token`, a `Field` that contains `Row`s as well as data type like `IntList` with elements of type `Integer`, we can define one list-like data structure that does not restrict the type of its elements to one specific type.
   We say that such a structure is _polymorphic_ over its element type.

Let us define such polymorphic list data type as follows.

> data List elemType where
>   Nil  :: List elemType
>   Cons :: elemType -> List elemType -> List elemType
>  deriving Show

As before, we have one nullary constructor `Nil` that marks the end of the list, and a constructor `Cons` that takes the element of the list and the remaining list as argument.
   The new part is the usage of the variable `elemType` all over the type definition.
   A variable like `elemType` that is introduced in the name of a data type is called _type variable_ or _type parameter_.
   We are already used to functions like `(+) :: Integer -> Integer -> Integer` or `eqDirection :: Direction -> Direction -> Bool` to take arguments, now we have seen the first type that takes an argument as well.
   A type like `List` is, thus, a _type function_ (in Haskell usually called a _type constructor_), because in order to have type that we use in a type signature, we need to apply `List` to a type.
   Similar to all our functions (and constructors, which are special kind of functions), we can also give a signature for types; in Haskell such signature are called _kind signatures_ (that is, functions have type signature and types have kind signatures).
   Whereas a type constructor like `List` needs to be applied to a type in order to yield a type, all the types we have used beforehand do not need any argument.
   We can as for the kind of type as follows.

   $> :k List
   List :: * -> *
   $> :k Bool
   Bool :: *
   $> :k Integer
   Integer :: *
   
In order to use `List` in type signature, we need to apply it to a type.
   We can, for example, apply it to types like `Bool` or `Integer`.

   $> :k List Integer
   List Integer :: *
   $> :k List Bool
   List Bool :: *

What happens to the parameter `elemType` we used in the type signature?
   Similar to how we replace parameters introduced on the left-hand side of function definition on their corresponding right-hand side, we replace all occurrences of the type parameter `elemType` with the more concrete type.

> intList1 :: List Integer
> intList1 = Cons 43 Nil
> --         ^^^^^^^^^^^
> --         Cons :: Integer -> List Integer -> List Integer
> --         Nil  :: List Integer

When specifying that `intList1` should be of type `List Integer`, as given in its type signature, Haskell checks if `Cons` and `Nil` are used in the correct way.
   That is, given the type signature of `Cons`

     Cons :: elemType -> List elemType -> List elemType

   we know that we need instantiate the type parameter `elemType` in the resulting type with `Integer` in order to yield a value of type `List Integer` as the type signature of `intList1` demands.

     Cons :: elemType -> List elemType -> List elemType   { elemType -> Integer } as demanded by the resulting type of `List Integer`
     ~>
     Cons :: Integer -> List Integer -> List Integer

   That is, we need to use `Cons` with a value of type `Integer` as first argument and a value of type `List Integer` as second argument.
   In the example expression above, we then know that `Nil`'s type needs to be instantiate as `List Integer` in order to fit the overall usage.

     Nil :: List elemType   { elemType -> Integer }  as demanded by the usage of `Cons 42`
     ~>
     Nil :: List Integer

Intuitively, we can instantiate the type variables for each constructor with the concrete type we are using.

     data List elemType where                               List Bool                            List Integer
       Nil  :: List elemType                                  :: List Bool                         :: List Integer
       Cons :: elemType -> List elemType -> List elemType     :: Bool -> List Bool -> List Bool    :: Integer -> List Integer -> List Integer

Before introducing polymorphic data types we needed to define every time we needed a different element type for our list-like structure.
   Now we can reuse `List elemType` by instantiating the type parameter with a concrete type.

> intList2 :: List Integer
> intList2 = Cons 1 (Cons 2 (Cons 3 Nil))
>
> boolList1 :: List Bool
> boolList1 = Cons True (Cons False (Cons True Nil))
>
> intListList :: List (List Integer)
> intListList = Cons intList1 (Cons intList2 Nil)

Note that the third example defines a list with elements of type `List Integer`.


 # Polymorphic functions

We can now also define _polymorphic functions_.
    For example, in order to compute the length of the list (i.e., the number of elements), we do not care about the type of the element: the function behaves the same for all (element) types.

We define `lengthList` inductively over the structure of the list argument.

> lengthList :: List elemType -> Integer
> lengthList Nil              = 0
> lengthList (Cons elem list) = 1 + lengthList list

In case of an empty list, the lengt is `0`, otherwise we add `1` to the resulting length of the remaining list.
   Since we defined a polymorphic function `lengthList`, that is, the function can be applied to list `List a`, we can test it on all our exemplary lists above.

   $> lengthList intList1
   1
   $> lengthList intList2
   3
   $> lengthList boolList1
   3
   $> lengthList intListList
   2

When using the function `lengthList` with a specific list, Haskell checks if we're allowed to make this function call at compile-time again.

     lengthList :: List elemType -> Integer    { elemType -> Integer }   (in case of using the function with `intList1` or `intList2`)
     ~>
     lengthList :: List Integer -> Integer

     
     lengthList :: List elemType -> Integer    { elemType -> Bool }   (in case of using the function with `boolList1`)
     ~>
     lengthList :: List Bool -> Integer

     
     lengthList :: List elemType -> Integer    { elemType -> List Integer }   (in case of using the function with `intListList`)
     ~>
     lengthList :: List (List Integer) -> Integer


Recall the higher-order example we implemented last week: instead of defining a map-like functions for different list-like structures (like `IntList`, `Field`, `Row` and `CoordMap`), we define these functions for `List` instead and reuse them for any element types.
  In case of `CoordMap` we defined a function of the following type.
  
   > mapCoordMap :: (Coordinate -> Coordinate) -> CoordMap -> CoordMap
   > mapCoordMap fCoord EmptyC = EmptyC
   > mapCoordMap fCoord (ACoord coord cm) = ACoord (fCoord coord) (mapCoordMap fCoord cm)

We define a similar function for our polymorphic data type `List` as well; for brevity we use the type variable `a` instead of `elemType`.
    Instead of using a functional argument of type `Coordinate -> Coordinate`, we need a function that maps the element type `a` to a new value.

> mapListA :: (a -> a) -> List a -> List a
> mapListA f Nil = Nil
> mapListA f (Cons elem list) = Cons (f elem) (mapListA f list)

The definition stays nearly the same, we only need to adapt the names of the constructors (`Nil` instead of `EmptyC` and `Cons` instead of `ACoord`) as well as the name of the recursive function itself.

We can use the functions on lists of `Integer` as well as on lists of `Bool` and lists of `List Integer`.

   $> mapListA (\b -> not b) boolList1

   $> mapListA (\n -> n + 1) intList1

   $> mapListA (\list -> list) intListList

However, we cannot use the `mapListA` function with a functional argument that yields a value of different type than the input type.
   For example, the following applications yield compile-type errors.
   
   $> mapListA (\n -> even n) intList1
   <interactive>:103:25-32: error:
    • Couldn't match type ‘Integer’ with ‘Bool’
      Expected type: List Bool
        Actual type: List Integer
    • In the second argument of ‘mapListA’, namely ‘intList1’
      In the expression: mapListA (\ n -> even n) intList1
      In an equation for ‘it’: it = mapListA (\ n -> even n) intList1

   $> mapListA (\list -> lengthList list) intListList
   <interactive>:112:20-34: error:
    • Couldn't match expected type ‘List Integer’
                  with actual type ‘Integer’
    • In the expression: lengthList list
      In the first argument of ‘mapListA’, namely
        ‘(\ list -> lengthList list)’
      In the expression: mapListA (\ list -> lengthList list) intListList

We can call `mapListA` only with functions of type `(a -> a)`, the functions we use the above examples are, however, of types that don't fit this specification.
   The first example uses the function `even` of type `Integer -> Bool` and the second example uses `\list -> lengthList list` that is of type `List a -> Integer`.

We can, however, define a function that can traverse a list of type `Integer` and produce a list of type `Bool`, that is, we can make the first example work!
   The function we are looking for has a more general type than `mapListA`: instead of passing a function of type `(a -> a)` as argument, we can use a functional argument of type `(a -> b)` that allows to yield a value of different type as result.

> mapList :: (a -> b) -> List a -> List b
> mapList f Nil = Nil
> mapList f (Cons elem list) = Cons (f elem) (mapList f list)
   
Thus, instead of transforming a `List a` into a `List a`, we yield a final structure `List b` since we need to apply the function `(a -> b)` the every element of the input list, we end up with a list of type `List b`.
   The attentive reader might notice that we did not adapt the implementation of the function, we only relaxed the type: we now have a more general type that allows using functions like `even`, `\b -> if b then 42 else 12` or `list -> lengthList list`.

   $> mapList (\n -> even n) intList1
   Cons False Nil
   $> mapList (\b -> if b then 42 else 12 ) boolList1
   Cons 42 (Cons 12 (Cons 42 Nil))
   $> mapList (\list -> lengthList list) intListList
   Cons 1 (Cons 3 Nil)

The other higher-order function that we defined for `CoordMap` as well as for `IntList` (see Exercise 3) is a filtering function that takes a predicate as first argument and decides based on this predicate if an argument should be kept in the final list or discarded.
   We can define this function polymorphic in the element type `elemType` for `List elemType` as follows.

> filterList :: (elemType -> Bool) -> List elemType -> List elemType
> filterList pred Nil = Nil
> filterList pred (Cons elem list) = if pred elem
>                                      then Cons elem (filterList pred list)
>                                      else filterList pred list

Again, we can use this function on element types `Bool`, `Integer` etc.

   $> filterList (\n -> even n) intList2
   Cons 2 Nil
   $> filterList (\b -> b) boolList1
   Cons True (Cons True Nil)
   $> filterList (\list -> lengthList list > 2) intListList
   Cons (Cons 1 (Cons 2 (Cons 3 Nil))) Nil

 # Predefined lists in Haskell

A polymorphic list data type is already predefined in Haskell.
   In contrast to the definition we use, it is defined using special syntax that is not valid Haskell syntax: it uses special characters for the constructor and type name.

  > data [] a where                      -- corresponds to `List`
  >  []  :: [] a                         -- corresponds to `Nil`
  >  (:) :: a -> [] a -> [] a            -- corresponds to `Cons`
  
This special syntax is very convenient to use: we can use the constructor `(:)` in infix-notation as follows to construct a list of `Integer`.

   $> 1 : 2 : 3 : []
   [1,2,3]

Note that Haskell pretty-prints the lists using yet another syntactical convention: we can define a finite list by enumerating all the elements separated by commas and enclosed using brackets.

   $> [1,2,3]
   [1,2,3]
   $> 1 : [2,3,4]
   [1,2,3,4]

In order to be completely honest: Haskell pretty-prints the type `[] a` also using special syntax.

   $> :i (:)
   data [a] where
     ...
   infixr 5 :
   
Note as well that the `(:)`-constructor is right-associative!
That is, the above expression is equivalent to the following explicitly parenthesised expression.

   $> 1 : (2 : (3 : []))
   [1,2,3]

Using `(:)` infix is also convenient when defining functions using pattern matching.
   For example, the functions `map` and `filter` are predefined as followed.

   > map :: (a -> b) -> [] a -> [] b
   > map f [] = []
   > map f (elem : list) = f elem : map f list
   >
   > filter :: (a -> Bool) -> [] a -> [] a
   > filter pred [] = []
   > filter pred (elem : list) = if pred elem
   >                               then elem : filter pred list
   >                               else filter pred list

 # More predefined polymorphic data types

Haskell has also predefined data types for a polymorphic product type (pairs)...
 
   > data (,) a b where
   >  (,) :: a -> b -> (,) a b

... for a polymorphic sum type...

   > data Either a b where
   >   Left  :: a -> Either a b
   >   Right :: b -> Either a b

as well as a polymorphic type to represent optional values.

   > data Maybe a where
   >   Nothing :: Maybe a
   >   Just    :: a -> Maybe a

Note that the product and sum types are polymorphic over two types, that is, they need to applied to two type arguments!

    $> :k (,)
    (,) :: * -> * -> *
    $> :k Either
    Either :: * -> * -> *
    $> :k Maybe
    Maybe :: * -> *
   
We can use the product type to represent a pair of `Integer` and `Bool`...

> intAndBool :: (,) Integer Bool
> intAndBool = (42, True)

... the sum type to either represent an `Integer` or a `Bool`...

> intOrBool1 :: Either Integer Bool
> intOrBool1 = Left 42
>
> intOrBool2 :: Either Integer Bool
> intOrBool2 = Right True

..., and use `Maybe` to define partial functions.

> secondElem :: [] a -> Maybe a
> secondElem [] = Nothing
> secondElem (elem : []) = Nothing
> secondElem (elem1 : elem2 : list) = Just elem2

The function `secondElem` is a polymorphic function: it accepts lists of arbitrary type and yields the second element of that list (wrapped in a `Just`-constructor) or `Nothing` in case the list has only one or none elements.

Similar to the special syntax for lists, Haskell also allows to write the product type and its constructor using a special syntax.

    > intAndBool :: (Integer, Bool)   -- using a "mixfix"-notation for products
    > intAndBool = (42, True)         -- using a "mixfix"-notation for values of product type

Last but not least, we can use the abstraction mechanism of polymorphic data structures for type synonyms as well.
   Recall that type synonyms allow us to introduce abbreviations/new names for already predefined types.
   For example, we define a list of key-value pairs as follows.

> type KeyValuePairs key value = [] ((,) key value)
>                           -- we could also write it mixfix: [(key, value)]

As for polymorphic data types, we introduce the type variable on the left-hand side of the type synonym definition, here `key` and `value` are the type parameters corresponding to the types used as first and second component of the pair.
