# Chapter 6

- Typeclasses

- Kind of the opposite of types
    - Type declarations define how types are created
    - Typeclasses define how set of types are consumed or used.

- You should be able to add new cases and new functions to a data type without
  recompilation and retain static type safety (e.g. no type casting)

- Type classes are like interfaces to data
    - `Eq` implements equality / comparison checks and provides a way for data
      types to use equality operators
    - `Num` implements numeric operators

```haskell
Prelude> :info Bool
data Bool = False | True 	-- Defined in ‘GHC.Types’
-- Can be tested for equality
instance Eq Bool -- Defined in ‘GHC.Classes’
-- Can be put into a sequential order (strictly ordered)
instance Ord Bool -- Defined in ‘GHC.Classes’
-- Renders things into strings
instance Show Bool -- Defined in ‘GHC.Show’
-- Parses strings into things. Don't use it (PERSONAL NOTE: probably
-- something like `eval`, which results is severe security issues)
instance Read Bool -- Defined in ‘GHC.Read’
-- Can be enumerated
instance Enum Bool -- Defined in ‘GHC.Enum’
-- Has an upper / lower bound
instance Bounded Bool -- Defined in ‘GHC.Enum’
```

- Typeclasses have a heirarchy
    - All `Fractional` implements `Num`, but not all `Num` implements
      `Fractional`.
    - All `Ord` implements `Eq`
    - All `Enum` implements `Ord`.
    - To be able to put something into an enumerated list, they must be ordered;
      to order something, they must be able to be compared.

- Some datatypes cannot implement some typeclasses (e.g. functions cannot
  implement equality `:info (->)`)

- Typeclasses allow for compile-time checking of operations to see whether it is
  valid for a given data type.

- Haskell does not provide universal stringification (`Show`) or equality
  (`Eq`).

```haskell
-- Define a new data type called `Trivial`.
Prelude> data Trivial = Trivial
-- Since (==) is not implemented, and because data type does not derive from
-- `Eq` typeclass, this results in an exception.
Prelude> Trivial == Trivial

<interactive>:11:1: error:
    • No instance for (Eq Trivial) arising from a use of ‘==’
    • In the expression: Trivial == Trivial
      In an equation for ‘it’: it = Trivial == Trivial
-- We can implement a method that checks this data type for equality.
Prelude> :{
Prelude| data Trivial = Trivial'
Prelude| instance Eq Trivial where
--       0        1  2       3
Prelude| Trivial' == Trivial' = True
--       4        5  6          7
Prelude| :}
-- 0. `instance` declares a typeclass instance.
-- 1. Typeclass the `instance` is providing.
-- 2. Data type instance is provided for. Here, it is implementing the
-- `Eq` typeclass for the `Trivial` data type.
-- 3. `where` terminates initial declaration and begins declaration.
-- 4. `Trivial'` is the data constructor as first argument to the
-- (==) operation.
-- 5. Operator in declaration.
-- 6. Second argument of operator.
-- 7. Result of this operation.

<interactive>:20:10: warning: [-Wmissing-methods]
    • No explicit implementation for
        either ‘Prelude.==’ or ‘/=’
    • In the instance declaration for ‘Eq Trivial’
-- One expression that can be constructed from definition.
Prelude> Trivial' == Trivial'
True
Prelude>
```

- Implement data type `dayOfWeek` and `Date`. See `dates.hs`.

```haskell
*Dates> Date Thu 10 == Date Thu 10
True
*Dates> Date Thu 10 == Date Thu 11
False
*Dates> Date Thu 10 == Date Weds 10
False
*Dates>
```

- Partial function: One that doesn't handle all the possible cases.
    - Different from partial application of functions.
    - (PERSONAL NOTE: So these do exist in Haskell)
    - Must avoid partial functions where possible. In GHCi, type `:set -Wall` to
      turn on all warnings. This may be annoying if you are writing a method to
      do type casting:

        ```haskell
        *Dates> :set -Wall
        *Dates> :{
        *Dates| f :: Int -> Bool
        *Dates| f 2 = True
        *Dates| :}

        <interactive>:64:1: warning: [-Wincomplete-patterns]
            Pattern match(es) are non-exhaustive
            In an equation for ‘f’:
                -- GHCi is mad because you are not handling cases where latter
                -- argument is not in set {2}. Assuming you have `:set -Wall`.
                Patterns not matched: p where p is not one of {2}
        *Dates>
        ```
    - Answer here is to have an catch-all case that matches everything, or use a
      data type that isn't huge like `Int`.
    - Use Enum or bounded data types in order to fully specify everything and
      have everything else be compile-time errors.

- You can specify typeclasses when implementing other typeclasses. See
  `identity.hs`.

```haskell
Prelude> :r
[1 of 1] Compiling Identity         ( identity.hs, interpreted )
-- Ok, one module loaded. (commenting out due to syntax highlighting
-- issues in markdown)
*Identity> data NoEq = NoEqInst deriving Show
*Identity> inoe = Identity NoEqInst
-- When trying to execute (==), because data constructor NoEq derives Show,
-- and because inoe is also an instance of Identity, (==) is undefined for the
-- specified types.
*Identity> inoe == inoe

<interactive>:71:1: error:
    • No instance for (Eq NoEq) arising from a use of ‘==’
    • In the expression: inoe == inoe
      In an equation for ‘it’: it = inoe == inoe
*Identity>
```

********** BEGIN EXERCISES: EQ INSTANCES **********

Write the `Eq` instance for the datatype provided.

```haskell
-- (1)
data TisAnInteger = TisAn Integer
-- (2)
data TwoIntegers = Two Integer Integer
-- (3)
data StringOrInt = TisAnInt Int | TisAString String
-- (4)
data Pair a = Pair a a
-- (5)
data Tuple a b = Tuple a b
-- (6)
data Which a = ThisOne a | ThatOne a
-- (7)
data EitherOr a = Hello a | Goodbye b
```

__________

See `eq_instances.hs`.

********** END EXERCISES: EQ INSTANCES **********

- Num: type class implemented by most numeric types.

```haskell
Prelude> :info Num
class Num a where
-- Predefined functions
  (+) :: a -> a -> a
  (-) :: a -> a -> a
  (*) :: a -> a -> a
  negate :: a -> a
  abs :: a -> a
  signum :: a -> a
  fromInteger :: Integer -> a
  {-# MINIMAL (+), (*), abs, signum, fromInteger, (negate | (-)) #-} -- Defined in ‘GHC.Num’
-- List of instances
instance Num Word -- Defined in ‘GHC.Num’
instance Num Integer -- Defined in ‘GHC.Num’
instance Num Int -- Defined in ‘GHC.Num’
instance Num Float -- Defined in ‘GHC.Float’
instance Num Double -- Defined in ‘GHC.Float’
Prelude>
```

```haskell
Prelude> :info Integral
-- Type class constraints for Integral on Real and Enum.
-- Type class inheritance (Real <- Num) is only additive, multiple
-- inheritance problem "diamond of death" is avoided.
class (Real a, Enum a) => Integral a where
  quot :: a -> a -> a
  rem :: a -> a -> a
  div :: a -> a -> a
  mod :: a -> a -> a
  quotRem :: a -> a -> (a, a)
  divMod :: a -> a -> (a, a)
  toInteger :: a -> Integer
  {-# MINIMAL quotRem, toInteger #-}
  	-- Defined in ‘GHC.Real’
instance Integral Word -- Defined in ‘GHC.Real’
instance Integral Integer -- Defined in ‘GHC.Real’
instance Integral Int -- Defined in ‘GHC.Real’
Prelude>
```

********** START EXERCISES: TUPLE EXPERIMENT **********

Look at the types given for `quotRem` and `divMod`. What do you think those
functions do? Test your hypotheses by playing with them in the REPL. We've given
you a sample to start with below:

`Prelude> ones x = snd (divMod x 10)`

```haskell
Prelude> :t quotRem
quotRem :: Integral a => a -> a -> (a, a)
Prelude> :t divMod
divMod :: Integral a => a -> a -> (a, a)
```

I think `divMod` divides two input arguments of type `Integral`, and generates a
tuple result of two result values of type `Integral`, the former being the
quotient and the latter being the modulus.

I think `quotRem` might do the same thing.

(CORRECT, as far as I know: https://stackoverflow.com/a/342379)

********** END EXERCISES: TUPLE EXPERIMENT **********

- Fractional
    - Type constraint of `Num` in type class.

```haskell
-- No type signature, works fine due to type inference.
Prelude> divideThenAdd x y = (x / y) + 1
Prelude> :{
-- Providing an illegal type signature results in an compile-time error.
Prelude| divideThenAdd :: Num a => a -> a -> a
Prelude| divideThenAdd x y = (x / y) + 1
Prelude| :}

<interactive>:60:22: error:
    • Could not deduce (Fractional a) arising from a use of ‘/’
      from the context: Num a
        bound by the type signature for:
                   divideThenAdd :: forall a. Num a => a -> a -> a
        at <interactive>:59:1-37
      Possible fix:
        add (Fractional a) to the context of
          the type signature for:
            divideThenAdd :: forall a. Num a => a -> a -> a
    • In the first argument of ‘(+)’, namely ‘(x / y)’
      In the expression: (x / y) + 1
      In an equation for ‘divideThenAdd’: divideThenAdd x y = (x / y) + 1
Prelude> :{
-- Provide the correct type signature in order to ensure correctness.
Prelude| divideThenAdd :: Fractional a => a -> a -> a
Prelude| divideThenAdd x y = (x / y) + 1
Prelude| :}
Prelude>
```

********** BEGIN EXERCISES: PUT ON YOUR THINKING CAP **********

Why didn't we need to make the type of the function we wrote require both type
classes?? Why didn't we have to do this:

```haskell
f :: (Num a, Fractional a) => a -> a -> a
```

Consider what it means for something to be a *subset* of a larger set of
objects.

__________

Since `Fractional` is a subset of `Num`, assuming that input argument is
`Fractional`, its data type already understands all operations handled by `Num`.
Furthermore, since type class inheritance is additive only, there is no
ambiguity between different type classes reimplementing the same method.
Therefore, there are no compile-time errors.

********** END EXERCISES: PUT ON YOUR THINKING CAP **********

- Type defaults
    - Polymorphic types must resolve to concrete types.
    - Most times, concrete type would come from type signature specified, or
      from type inference.
    - Sometimes though, there may not be a concrete type, esp. when working in
      GHCi REPL.
    - [The Haskell Report](https://www.haskell.org/onlinereport/haskell2010/)
      specifies default concrete types for numeric type classes.

- Ord

```haskell
Prelude> :info Ord
-- Type class constraint of Eq.
class Eq a => Ord a where
-- List of operations.
  compare :: a -> a -> Ordering
  (<) :: a -> a -> Bool
  (<=) :: a -> a -> Bool
  (>) :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  max :: a -> a -> a
  min :: a -> a -> a
  {-# MINIMAL compare | (<=) #-}
    -- Defined in ‘GHC.Classes’
-- List of instances for type classes.
instance Ord a => Ord [a] -- Defined in ‘GHC.Classes’
instance Ord Word -- Defined in ‘GHC.Classes’
instance Ord Ordering -- Defined in ‘GHC.Classes’
instance Ord Int -- Defined in ‘GHC.Classes’
instance Ord Float -- Defined in ‘GHC.Classes’
instance Ord Double -- Defined in ‘GHC.Classes’
instance Ord Char -- Defined in ‘GHC.Classes’
instance Ord Bool -- Defined in ‘GHC.Classes’
-- Truncated instances.
Prelude>
```

```haskell
Prelude> compare 7 8
LT
Prelude> compare 4 (-4)
GT
Prelude> compare "Julie" "Chris"
GT
Prelude> compare True False
GT
Prelude> compare False True
LT
Prelude> compare True True
EQ
Prelude>
```

```haskell
-- `max` operation available to data types implementing `Ord` typeclass.
--
-- Error message is not intuitive, but `max` is not a method that can be
-- curried.
--
-- Typeclass that couldn't be found was `Show`, that allows values to be
-- printed to the terminal. We called `print` because we are using GHCi.
Prelude> max "Julie"

<interactive>:76:1: error:
    • No instance for (Show ([Char] -> [Char]))
        arising from a use of ‘print’
        (maybe you haven't applied a function to enough arguments?)
    • In a stmt of an interactive GHCi command: print it
Prelude>
```

- Ord implies Eq

```haskell
Prelude> :{
-- No type constraint results in a compile-time error.
Prelude| check' :: a -> a -> Bool
Prelude| check' a a' = (==) a a'
Prelude| :}

<interactive>:12:15: error:
    • No instance for (Eq a) arising from a use of ‘==’
      Possible fix:
        add (Eq a) to the context of
          the type signature for:
            check' :: forall a. a -> a -> Bool
    • In the expression: (==) a a'
      In an equation for ‘check'’: check' a a' = (==) a a'
Prelude> :{
-- However, specifying a subset of `Eq` is fine, since `Ord` inherits
-- operations needed by `Eq`.
Prelude| check' :: Ord a => a -> a -> Bool
Prelude| check' a a' = (==) a a'
Prelude| :}
Prelude>
```

********** START EXERCISES: WILL THEY WORK? **********

Take a look at the following code examples and try to decide if they will work,
what result they will return if they do, and why or why not (be sure, as always,
to test them in your REPL once you have decided on your answer):

1.  Shouldn't work. `length` operands are both working on input arguments of type
    `Foldable`, which should return a result of type `Integral`, which should be
    constrained by `Ord` since it is a numeric type. However, since no
    parentheses are around both `length` arguments, and the expression is
    left-associative, `max` will only be operating on one input argument, which
    will result in an exception.

    (INCORRECT, parentheses are executed first.)

    ```haskell
    Prelude> max (length [1, 2, 3]) (length [8, 9, 10, 11, 12])
    5
    Prelude>
    ```

2.  Should work. Multiplication operations should result in abstract class `Num`
    return values. `compare` will be operating on two `Num` values, which should
    resolve to `Bool` successfully.

    (PARTIALLY CORRECT, resolves to `Ordering` data type.)

    ```haskell
    Prelude> compare (3 * 4) (3 * 5)
    LT
    Prelude>
    ```

3.  Shouldn't work. `compare` only works on values of the same data type, or
    that can be resolved to the same data type.

    ```haskell
    Prelude> compare "Julie" True

    <interactive>:32:17: error:
        • Couldn't match expected type ‘[Char]’ with actual type ‘Bool’
        • In the second argument of ‘compare’, namely ‘True’
        In the expression: compare "Julie" True
        In an equation for ‘it’: it = compare "Julie" True
    Prelude>
    ```

4.  Should work. Parentheses are resolved first, which results in two `Num`
    return values, which can be executed with `>` as `Num` inherits from `Ord`.

    (CORRECT)

    ```haskell
    Prelude> (5 + 3) > (3 + 6)
    False
    Prelude>
    ```

********** END EXERCISES: WILL THEY WORK? **********

- Enum

```haskell
Prelude> :info Enum
class Enum a where
  succ :: a -> a
  pred :: a -> a
  toEnum :: Int -> a
  fromEnum :: a -> Int
  enumFrom :: a -> [a]
  enumFromThen :: a -> a -> [a]
  enumFromTo :: a -> a -> [a]
  enumFromThenTo :: a -> a -> a -> [a]
  {-# MINIMAL toEnum, fromEnum #-}
  	-- Defined in ‘GHC.Enum’
instance Enum Word -- Defined in ‘GHC.Enum’
instance Enum Ordering -- Defined in ‘GHC.Enum’
instance Enum Integer -- Defined in ‘GHC.Enum’
instance Enum Int -- Defined in ‘GHC.Enum’
instance Enum Char -- Defined in ‘GHC.Enum’
instance Enum Bool -- Defined in ‘GHC.Enum’
instance Enum () -- Defined in ‘GHC.Enum’
instance Enum Float -- Defined in ‘GHC.Float’
instance Enum Double -- Defined in ‘GHC.Float’
Prelude>
```

```haskell
-- Predecessor.
Prelude> pred 'd'
'c'
-- Successor.
Prelude> succ 4
5
-- Note that the successor of a float is still the integer step, not the step
-- by the smallest granularity.
Prelude> succ 4.5
5.5
Prelude> enumFromTo 3 8
[3,4,5,6,7,8]
Prelude> enumFromTo 'a' 'f'
"abcdef"
-- Starts at 1, goes to 10 **inclusive**, then steps until 100, with step
-- size controlled by the initial **all-inclusive** range (unlike Python,
-- which is [inclusive ... exclusive)).
Prelude> enumFromThenTo 1 10 100
[1,10,19,28,37,46,55,64,73,82,91,100]
Prelude> enumFromThenTo 0 10 100
[0,10,20,30,40,50,60,70,80,90,100]
-- Can do the same thing with type `Char`.
Prelude> enumFromThenTo 'a' 'c' 'z'
"acegikmoqsuwy"
-- Null step size still results in inclusive start rendered as type
-- `[Char]`.
Prelude> enumFromThenTo 'a' 'z' 'c'
"a"
Prelude>
```

- Show
    - Not a serialization format, solely for human readability.
    - Side effect: potentially observable result apart from the value the
      expression evaluates to.
    - Haskell separates effectful computations from pure computations.

```haskell
-- Value
Prelude> myVal :: String; myVal = undefined
-- Method of obtaining a value
Prelude> ioString :: IO String; ioString = undefined
Prelude>
```

- Working with `Show`

```haskell
Prelude> data Mood = Blah
Prelude> Blah

<interactive>:48:1: error:
    • No instance for (Show Mood) arising from a use of ‘print’
    • In a stmt of an interactive GHCi command: print it
-- GHCi supports deriving `Show` typeclasses by default. Still need to
-- derive it.
Prelude> data Mood = Blah deriving Show
Prelude> Blah
Blah
Prelude>
```

- Read
    - Don't use it.
    - Problem is in the `String` data type. A `String` is a list, which could be
      empty, or stretch to infinity.
    - No guarantee that `String` will be a valid representation of an `Integer`
      value (e.g. division by 0).
    - `read` is a partial function: function that doesn't return a proper value
      as a result *for all possible* inputs.
    - Avoid using such methods in Haskell.

- Instances are dispatched by type
    - Type classes: defined by set of operations and values all instances will
      provide.
    - Types: Instances of a type class.
    - Type class instances: unique pairings of the type class and a type. The
      ways a type uses the functions of the type class.

- Don't define type classes like in `bad_example.hs`.

- Don't use type classes to define default values.
    - Otherwise, GHC has no idea what type `defaultNumber` is other than that
      it's provided by `Numberish`s instances.
    - Even then, we can cast the value to explicitly tell Haskell what we want.

- Gimme more operations
    - No constraints on polymorphic typeclasses means not many operations
      available
    - No real way around this problem except to implement typcelass constraints
      (casting operations using `(+)` with `Num` typeclass constraint)

- Concrete types imply all the type classes they provide
    - If you implemented method `add` with a type signature of all concrete
      types (e.g. `Int`), you can extend method `add` with all operations
      supported by that/those concrete types (e.g. `(<)`, because `Int` supports
      `Ord` typeclass constraint).
    - Adding typeclass constraint to a concrete type would be meaningless.
    - Using typeclasses is better for describing what you want to do with your
      data, as opposed to concrete types which may allow the function to do
      something unintended with an operation supported by a hidden typeclass.

********** BEGIN CHAPTER EXERCISES **********

Multiple choice

1. c) (CORRECT, ANSWER KEY https://github.com/johnchandlerburnham/hpfp)
2. b) (CORRECT, ANSWER KEY https://github.com/johnchandlerburnham/hpfp)
3. a) (CORRECT, ANSWER KEY https://github.com/johnchandlerburnham/hpfp)
4. c) (CORRECT, ANSWER KEY https://github.com/johnchandlerburnham/hpfp)
5. a) (CORRECT, ANSWER KEY https://github.com/johnchandlerburnham/hpfp)

__________

Does it typecheck?

1. No, it does not typecheck, no typeclass constraint `Show`.

(CORRECT)

```haskell
Prelude> :{
Prelude| data Person = Person Bool
Prelude| printPerson :: Person -> IO ()
Prelude| printPerson person = putStrLn (show person)
Prelude| :}

<interactive>:8:32: error:
    • No instance for (Show Person) arising from a use of ‘show’
    • In the first argument of ‘putStrLn’, namely ‘(show person)’
      In the expression: putStrLn (show person)
      In an equation for ‘printPerson’:
          printPerson person = putStrLn (show person)
Prelude>
```

2. It should typecheck, as method `settleDown` does not have a type signature,
   enabling type inference.

(INCORRECT, `(==)` implies typeclass constraint `Eq`.)

```haskell
Prelude> :{
Prelude| data Mood = Blah | Woot deriving Show
Prelude| settleDown x = if x == Woot then Blah else x
Prelude| :}

<interactive>:12:19: error:
    • No instance for (Eq Mood) arising from a use of ‘==’
    • In the expression: x == Woot
      In the expression: if x == Woot then Blah else x
      In an equation for ‘settleDown’:
          settleDown x = if x == Woot then Blah else x
Prelude>
```

3. Below:
    a) Data of data type `Mood`. (CORRECT, ANSWER KEY
    https://github.com/johnchandlerburnham/hpfp)
    b) Type translation error, since `Int` cannot compare to `Mood`. (CORRECT,
    ANSWER KEY https://github.com/johnchandlerburnham/hpfp)
    c) Compile-time error, as neither `Blah` nor `Woot` derive from `Ord`.
    (PARTIALLY CORRECT, `Mood` does not derive from `Ord`, ANSWER KEY
    https://github.com/johnchandlerburnham/hpfp)

4. Compile-time error implementing `s1` (two arguments instead of three, not
   sure how nulls are handled)

(INCORRECT, no compile-time error.)

```haskell
Prelude> :{
Prelude| type Subject = String
Prelude| type Verb = String
Prelude| type Object = String
Prelude| data Sentence = Sentence Subject Verb Object deriving (Eq, Show)
Prelude| s1 = Sentence "dogs" "drool"
Prelude| s2 = Sentence "Julie" "loves" "dogs"
Prelude| :}
Prelude>
```

__________

Given a datatype declaration, what can we do?

1. Should typecheck, since data type `Rocks` is a subset of data type `String`
   and data type `Yeah` is a subset of data type `Bool`, passing in data of type
   `String` and of type `Bool` into `Yeah` instantiation should still match type
   signature.

(INCORRECT)

2. Should typecheck, type declarations are present in data declaration.

(CORRECT)

3. Should not typecheck, no equality instance comparator method.

(INCORRECT, does compile.)

4. Should not typecheck, `Papu` does not derive from `Ord`.

(CORRECT)

See `datatypes.hs`.

__________

Match the types:

See `MatchTheTypes.hs`; typing into file to avoid unnecessary `deriving Show`
which may result in GHCi errors.

1. Can match the type, no operations are executed.

(INCORRECT, apparently literals need to be cast to `Num` types.)

```haskell
MatchTheTypes.hs:11:5: error:
    • No instance for (Num a) arising from the literal ‘1’
      Possible fix:
        add (Num a) to the context of
          the type signature for:
            i :: forall a. a
    • In the expression: 1
      In an equation for ‘i’: i = 1
```

2. Can match the type, `Float` should derive from `Num`.

(INCORRECT, `Float` may need some operations not available in `Num`.)

```haskell
MatchTheTypes.hs:17:5: error:
    • Could not deduce (Fractional a) arising from the literal ‘1.0’
      from the context: Num a
        bound by the type signature for:
                   f :: forall a. Num a => a
        at MatchTheTypes.hs:16:1-15
      Possible fix:
        add (Fractional a) to the context of
          the type signature for:
            f :: forall a. Num a => a
    • In the expression: 1.0
      In an equation for ‘f’: f = 1.0
```

3. Can match the type; `Fractional` and `Float` should not be too different (?)

(CORRECT)

4. Can match the type. `RealFrac` partially derives from `Fractional`. (Did not
   know we were allowed use of GHCi and `:info`)

(CORRECT)

5. Can match the type, typeclass constraint is redundant.

(CORRECT)

6. Can match the type, concrete type w/o no operations should still compile.

(CORRECT)

7. Can match the type, abstract type signature for method gets cast to concrete
   base type with input arguments.

(INCORRECT)

```haskell
MatchTheTypes.hs:54:13: error:
    • Couldn't match expected type ‘a’ with actual type ‘Int’
      ‘a’ is a rigid type variable bound by
        the type signature for:
          sigmund :: forall a. a -> a
        at MatchTheTypes.hs:53:1-17
    • In the expression: myX
      In an equation for ‘sigmund’: sigmund x = myX
    • Relevant bindings include
        x :: a (bound at MatchTheTypes.hs:54:9)
        sigmund :: a -> a (bound at MatchTheTypes.hs:54:1)
```

8. Can match the type, with typeclass constraint `Num`, should be able to process
   type `Int`.

(INCORRECT, likely because with concrete casting, type signature comes into
conflict with method definition as method hardcodes `Int`.)

```haskell
MatchTheTypes.hs:63:14: error:
    • Couldn't match expected type ‘a’ with actual type ‘Int’
      ‘a’ is a rigid type variable bound by
        the type signature for:
          sigmund' :: forall a. Num a => a -> a
        at MatchTheTypes.hs:62:1-27
    • In the expression: myX
      In an equation for ‘sigmund'’: sigmund' x = myX
    • Relevant bindings include
        x :: a (bound at MatchTheTypes.hs:63:10)
        sigmund' :: a -> a (bound at MatchTheTypes.hs:63:1)
```

9. Can match the type, concrete base type is a valid method definition for
   inputs of type `Int`.

(CORRECT)

10. Can match the type, abstract type that has typeclass constraint `Ord` should
    be able to use `sort`.

(CORRECT)

11. Cannot match types, because method `mySort` forces method `signifier` to use
    concrete types.

(CORRECT)

```haskell
MatchTheTypes.hs:90:29: error:
    • Couldn't match type ‘a’ with ‘Char’
      ‘a’ is a rigid type variable bound by
        the type signature for:
          signifier :: forall a. Ord a => [a] -> a
        at MatchTheTypes.hs:89:1-30
      Expected type: [Char]
        Actual type: [a]
    • In the first argument of ‘mySort’, namely ‘xs’
      In the first argument of ‘head’, namely ‘(mySort xs)’
      In the expression: head (mySort xs)
    • Relevant bindings include
        xs :: [a] (bound at MatchTheTypes.hs:90:11)
        signifier :: [a] -> a (bound at MatchTheTypes.hs:90:1)
```

__________

Type-Kwon-Do Two: Electric Typealoo

See `TypeKwonDo.hs`.

********** END CHAPTER EXERCISES **********
