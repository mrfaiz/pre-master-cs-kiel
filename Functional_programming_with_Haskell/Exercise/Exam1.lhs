> {-# LANGUAGE GADTSyntax #-}

 # 1 - Quiz -- 12 Points

Mark all correct answers with an X. Note that any number of answers can be correct. Each question is worth 1.5 points. For each incorrect answer 0.5 points are deducted; negative scores for a question are not possible.


* Which of the following expressions will yield a type error?

      [X] map (\ x -> if x then 32 else 42) [1, 2, 3]

      [ ] Just [Nothing]

      [ ] filter id [True, False, False, True]

      [ ] [[1, 2], [1, 2, 3]]

      [ ] ([42], False, True)


* Which of the following types are correct?

      [X] putStrLn "Hello, world!" :: IO ()

      [ ] map :: (a -> a) -> [a] -> [b]

      [X] getLine :: IO String

      [ ] filter :: (a -> b) -> [a] -> [b]

      [ ] (>>) :: IO res1 -> res1 -> IO res2 -> IO res2


* Which of the following expressions terminate (if they are entered into ghci)?

      [X] let listLoop = 1 : listLoop in take 42 listLoop
  
      [ ] let noLoop = noLoop in take 12 noLoop

      [ ] let boolLoop = boolLoop in True && boolLoop

      [X] let boolLoop = boolLoop in True || boolLoop

      [X] let noLoop = 1 : noLoop in zip noLoop [1,2,3,4,5]


* Which of the following expressions yield 6? (Remark: `const` has type `a -> b -> a`)

      [X] length (zip [1,2,3,4,5,6] [1,2,3,4,5,6])

      [ ] foldr (+) 6 [1,1,2,2]

      [ ] const 42 6

      [X] head (map (\x -> x * 2) [3,2,1])

      [X] length (map (\x -> x + 1) [1,2,3,4,5,6])


* Which of the following types have exactly four different values?

      [X] (Bool, Bool)

      [ ] Either Bool ()

      [ ] Maybe Bool

      [ ] ((), Bool)

      [X] Either Bool Bool



(1.5 points) What's the type of the following operations?

(>>) :: IO a -> IO b -> IO b

(>>=) :: IO a -> (a -> IO b) -> IO b

(1.5 points) Give the most general type signature for the following function.

> f :: (a -> c -> d) -> (a -> b -> c) -> b -> a -> d
> f g h x y = g y (h y x)


(1.5 points) We define the following algebraic data types and definitions.

> data Boring where
>   Boring :: Boring
> 
> data Exciting a where
>   Ex1 :: Exciting Boring -> Exciting a
>   Ex2 :: a -> Exciting a

Give three different values of type `Exciting ()`.

> val1 :: Exciting ()
> val1 = Ex2 ()
> 
> val2 :: Exciting ()
> val2 = Ex1 (Ex2 Boring)
> 
> val3 :: Exciting ()
> val3 = E1 (Ex1 (Ex2 Boring))

 
 # 2 - A Lot of Definitions -- 16 Points

(3 points) Define a data type in GADT-syntax to represent a Boolean expression. The Boolean expression can be a truth value (true and false), a conjunction, or a negation.

> data BoolExp where
>   Val  :: Bool -> BoolExp
>   Conj :: BoolExp -> BoolExp -> BoolExp
>   Neg  :: BoolExp -> BoolExp

> data BoolExpAlternative where
>   TTrue :: BoolExmp
>   FFalse :: BoolExmp
>   Conj :: BoolExp -> BoolExp -> BoolExp
>   Neg  :: BoolExp -> BoolExp
        
(3 points) Consider the following types to represent a field of tokens.

> data Token where
>   Blank :: Token
>   Block :: Token
> 
> -- The outer list represent the rows, and the inner list the columns of one row
> type Field = [[Token]]
> 
> eqToken :: Token -> Token -> Bool
> eqToken Blank Blank = True
> eqToken Block Block = True
> eqToken _     _     = False

Define the following functions based on `Field`.

> -- Checks if the `Field` contains the given `Token`,
> --  yields `True` if the `Token` occurs and `False` otherwise.
> hasToken :: Token -> Field -> Bool
> hasToken t []            = False
> hasToken t (row : field) = hasToken' t row || hasToken t field
>  where
>   hasToken' t []         = False
>   hasToken' t (t' : row) = eqToken t t' || hasToken' row

> -- Constructs a n*m-field with n rows that each contain m `Block`-elements.
> blockField :: Int -> Int -> Field
> blockField 0 m = []
> blockField n m = blockRow m : blockField (n-1) m
>  where
>   blockRow 0 = []
>   blockRow m = Block : blockRow (m-1)

> blockFieldAlternative :: Int -> Int -> Field
> blockFieldAlternative n m = replicate n (replicate m Block)

(4 points) Consider the following type that represents a list of pairs.

> data PairList a where
>   Empty :: PairList a
>   ConsPair :: (a,a) -> PairList a -> PairList a

Define the following functions based on this type; also give the type signature if not specified!

> -- Constructs a list with n pairs, where the pair is specified by
> --  the second argument and the n by the first argument.
> replicatePairs :: Int -> (a,a) -> PairList a
> replicatePairs 0 _       = Empty
> replicatePairs n pairVal = ConsPair pairVal (replicatePairs (n-1) pairVal)

> -- Applies a function to both components of the pair for all
> --  pair-elements that occur in the list.
> mapPairList :: (a -> b) -> PairList a -> PairList b
> mapPairList f Empty                     = Empty
> mapPairList f (ConsPair (x,y) pairList) = ConsPair (f x, f y) (mapPairList pairList)


(2 Points) Define a function `length` using `foldr` that computes the length of a list.

> length :: [a] -> Int
> length list = foldr fCons fNil list
>  where
>   fCons = \_ acc -> 1 + acc
>   fNil  = 0

(4 Points) Define a function `getStringWithAtLeastTwoVowels` that reads a string from the user and yields the user's input if it contains at least two vowels; otherwise the user should be informed of the missed criterion and get another try (until the given input meets the criterion). Don't forget to annotate all functions that you define with their type signatures as well.

> getStringWithAtLeastTwoVowels :: IO String
> getStringWithAtLeastTwoVowels =
>   getLine >>= \ str ->
>   if length (vowels str) >= 2
>     then pure str
>     else putStrLn "Your string should contain at least two vowels, please try again" >>
>          getStringWithAtLeastTwoVowels
>  where
>   vowels str = filter vowel str
>   vowel 'a' = True
>   vowel 'e' = True
>   vowel 'i' = True
>   vowel 'o' = True
>   vowel 'u' = True
>   vowel _   = False
