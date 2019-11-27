# Chapter 4

- Basic datatypes

- Types are like sets (set theory -> type theory), disjunction (or) /
  conjunction (and)
- Data declarations: Defining new datatypes.
- Data constructors: Values that inhabit the type they are defined in.
- Term level: Values as they appear in *your* code.

```haskell
Prelude> data Bool = False | True
Prelude> :info Bool
data Bool = False | True 	-- Defined at <interactive>:1:1
Prelude>
```

```haskell
-- NOTE: Must not redefine Prelude.Bool for 'not' to work.
Prelude> :t not
not :: Bool -> Bool
Prelude> not True
False
Prelude>
```

********** START EXERCISES: MOOD SWING **********

Given the following datatype, answering the following questions:

```haskell
data Mood = Blah | Woot deriving Show
```

1.  What is the type constructor, or name of this type?

    `Mood`.

2.  If the function requires a `Mood` value, what are the values you could
    possibly use?

    `Blah` or `Woot deriving Show`.

3.  We are trying to write a function `changeMood` to change Chris's mood
    instantaneously. It should act like `not` in that, given one value, it
    returns the *other* value of the same type. So far, we've written a type
    signature `changeMood :: Mood -> Woot`. What's wrong with that?

    Method signature should be `changeMood :: Mood -> Mood`, as both `Blah` and
    `Woot` both are of type `Mood`.

4.  Now we want to write the function that changes his mood. Given an input
    mood, it gives us the other one. Fix any mistakes and complete the function:

    ```haskell
    -- pattern matching
    changeMood Mood = Woot
    changeMood _ = Blah
    ```

    Change the input argument resulting in value `Woot` to have input `Blah`.

    ```haskell
    changeMood Blah = Woot
    changeMood _ = Blah
    ```

5.  Enter all of the above -- datatype (including the `deriving Show` bit), your
    corrected type signature, and the corrected function into a source file.
    Load it and run it in GHCi to make sure you got it right.

    ```haskell
    Prelude> data Mood = Blah | Woot deriving Show
    Prelude> :{
    Prelude| changeMood :: Mood -> Mood
    Prelude| changeMood Blah = Woot
    Prelude| changeMood _ = Blah
    Prelude| :}
    Prelude> changeMood Woot
    Blah
    Prelude> changeMood Blah
    Woot
    ```

********** END EXERCISES: MOOD SWING **********

- Integral numeric types

```haskell
Prelude> :i Int
data Int = GHC.Types.I# GHC.Prim.Int# 	-- Defined in ‘GHC.Types’
instance Eq Int -- Defined in ‘GHC.Classes’
instance Ord Int -- Defined in ‘GHC.Classes’
instance Show Int -- Defined in ‘GHC.Show’
instance Read Int -- Defined in ‘GHC.Read’
instance Enum Int -- Defined in ‘GHC.Enum’
instance Num Int -- Defined in ‘GHC.Num’
instance Real Int -- Defined in ‘GHC.Real’
instance Bounded Int -- Defined in ‘GHC.Enum’
instance Integral Int -- Defined in ‘GHC.Real’
Prelude> :i Integer
data Integer
  = integer-gmp-1.0.2.0:GHC.Integer.Type.S# GHC.Prim.Int#
  | integer-gmp-1.0.2.0:GHC.Integer.Type.Jp# {-# UNPACK #-}integer-gmp-1.0.2.0:GHC.Integer.Type.BigNat
  | integer-gmp-1.0.2.0:GHC.Integer.Type.Jn# {-# UNPACK #-}integer-gmp-1.0.2.0:GHC.Integer.Type.BigNat
  	-- Defined in ‘integer-gmp-1.0.2.0:GHC.Integer.Type’
instance Eq Integer
  -- Defined in ‘integer-gmp-1.0.2.0:GHC.Integer.Type’
instance Ord Integer
  -- Defined in ‘integer-gmp-1.0.2.0:GHC.Integer.Type’
instance Show Integer -- Defined in ‘GHC.Show’
instance Read Integer -- Defined in ‘GHC.Read’
instance Enum Integer -- Defined in ‘GHC.Enum’
instance Num Integer -- Defined in ‘GHC.Num’
instance Real Integer -- Defined in ‘GHC.Real’
instance Integral Integer -- Defined in ‘GHC.Real’
Prelude> :i Word
data Word = GHC.Types.W# GHC.Prim.Word# 	-- Defined in ‘GHC.Types’
instance Eq Word -- Defined in ‘GHC.Classes’
instance Ord Word -- Defined in ‘GHC.Classes’
instance Show Word -- Defined in ‘GHC.Show’
instance Read Word -- Defined in ‘GHC.Read’
instance Enum Word -- Defined in ‘GHC.Enum’
instance Num Word -- Defined in ‘GHC.Num’
instance Real Word -- Defined in ‘GHC.Real’
instance Bounded Word -- Defined in ‘GHC.Enum’
instance Integral Word -- Defined in ‘GHC.Real’
Prelude>
```

- Fractional numeric types

```haskell
Prelude> :i Float
data Float = GHC.Types.F# GHC.Prim.Float#
  	-- Defined in ‘GHC.Types’
instance Eq Float -- Defined in ‘GHC.Classes’
instance Ord Float -- Defined in ‘GHC.Classes’
instance Show Float -- Defined in ‘GHC.Float’
instance Read Float -- Defined in ‘GHC.Read’
instance Enum Float -- Defined in ‘GHC.Float’
instance Floating Float -- Defined in ‘GHC.Float’
instance Fractional Float -- Defined in ‘GHC.Float’
instance Num Float -- Defined in ‘GHC.Float’
instance Real Float -- Defined in ‘GHC.Float’
instance RealFloat Float -- Defined in ‘GHC.Float’
instance RealFrac Float -- Defined in ‘GHC.Float’
Prelude> :i Double
data Double = GHC.Types.D# GHC.Prim.Double#
  	-- Defined in ‘GHC.Types’
instance Eq Double -- Defined in ‘GHC.Classes’
instance Ord Double -- Defined in ‘GHC.Classes’
instance Show Double -- Defined in ‘GHC.Float’
instance Read Double -- Defined in ‘GHC.Read’
instance Enum Double -- Defined in ‘GHC.Float’
instance Floating Double -- Defined in ‘GHC.Float’
instance Fractional Double -- Defined in ‘GHC.Float’
instance Num Double -- Defined in ‘GHC.Float’
instance Real Double -- Defined in ‘GHC.Float’
instance RealFloat Double -- Defined in ‘GHC.Float’
instance RealFrac Double -- Defined in ‘GHC.Float’
Prelude> :i Rational
type Rational = GHC.Real.Ratio Integer 	-- Defined in ‘GHC.Real’

-- Datatype `Fixed` not available in default `Prelude`.
Prelude> import Data.Fixed as Fixed
Prelude Fixed> :info Fixed
type role Fixed phantom
newtype Fixed a = MkFixed Integer
  	-- Defined in ‘Data.Fixed’
instance Eq (Fixed a) -- Defined in ‘Data.Fixed’
instance Ord (Fixed a) -- Defined in ‘Data.Fixed’
instance HasResolution a => Show (Fixed a)
  -- Defined in ‘Data.Fixed’
instance HasResolution a => Read (Fixed a)
  -- Defined in ‘Data.Fixed’
instance Enum (Fixed a) -- Defined in ‘Data.Fixed’
instance HasResolution a => Fractional (Fixed a)
  -- Defined in ‘Data.Fixed’
instance HasResolution a => Num (Fixed a)
  -- Defined in ‘Data.Fixed’
instance HasResolution a => Real (Fixed a)
  -- Defined in ‘Data.Fixed’
instance HasResolution a => RealFrac (Fixed a)
  -- Defined in ‘Data.Fixed’
Prelude Fixed> :m

-- Datatype `Scientific` not available in default `Prelude`. May need to install
-- using command `stack install scientific` and run GHCi with
-- `stack ghci --package scientific`, or maybe not if package `data` is already
-- installed.
--
-- Tried uninstalling package after realizing it may be unnecessary, but
-- this esoteric weirdness about uninstalling packages in Haskell Stack:
-- https://stackoverflow.com/a/38639959
Prelude> import Data.Scientific as Scientific
Prelude Scientific> :i Scientific
data Scientific
  = Data.Scientific.Scientific {coefficient :: !Integer,
                                base10Exponent :: {-# UNPACK #-}Int}
  	-- Defined in ‘Data.Scientific’
instance Eq Scientific -- Defined in ‘Data.Scientific’
instance Ord Scientific -- Defined in ‘Data.Scientific’
instance Show Scientific -- Defined in ‘Data.Scientific’
instance Read Scientific -- Defined in ‘Data.Scientific’
instance Fractional Scientific -- Defined in ‘Data.Scientific’
instance Num Scientific -- Defined in ‘Data.Scientific’
instance Real Scientific -- Defined in ‘Data.Scientific’
instance RealFrac Scientific -- Defined in ‘Data.Scientific’
```

- All these types inherit from `Num`, which implements standard numeric
  operations like additon, subtraction, etc.
- Think of Integers as a resolved [generator
  expression](https://docs.python.org/3/reference/expressions.html#generator-expressions)
  that can count towards negative Infinity, zero, and positive Infinity.

- **Most programs should use `Integer` instead of `Int`, `Int8`, or `Int16` as
  the latter may run into exceptions for arbitrarily large values.

```haskell
Prelude> import GHC.Int
-- Casting as Int8 (8-bit integer)
--
-- Numbers are polymorphic under the surface, compiler doesn't assign them a
-- concrete type until it is forced to. Lazy evaluation means that the largest
-- result can be defined before assigning to a concrete type. This is why the
-- number must be explicitly cast to Int8 to reproduce this error.
Prelude GHC.Int> 127 :: Int8
127
-- Gives a warning about impending overflow.
Prelude GHC.Int> 128 :: Int8

<interactive>:3:1: warning: [-Woverflowed-literals]
    Literal 128 is out of the Int8 range -128..127
    If you are trying to write a large negative literal, use NegativeLiterals
-128
-- Overflows without warning.
Prelude GHC.Int> (127 + 1) :: Int8
-128
Prelude GHC.Int>
```

```haskell
-- Find the minimum and maximum values for different intN types.
Prelude> import GHC.Int
Prelude GHC.Int> :t minBound
minBound :: Bounded a => a
Prelude GHC.Int> :t maxBound
maxBound :: Bounded a => a
Prelude GHC.Int> minBound :: Int8
-128
Prelude GHC.Int> minBound :: Int16
-32768
Prelude GHC.Int> minBound :: Int32
-2147483648
Prelude GHC.Int> minBound :: Int64
-9223372036854775808
Prelude GHC.Int> maxBound :: Int8
127
Prelude GHC.Int> maxBound :: Int16
32767
Prelude GHC.Int> maxBound :: Int32
2147483647
Prelude GHC.Int> maxBound :: Int64
9223372036854775807
Prelude GHC.Int>

-- Can also find out whether the datatype is bounded using :info
Prelude GHC.Int> :i Int
data Int = I# GHC.Prim.Int# 	-- Defined in ‘GHC.Types’
instance Eq Int -- Defined in ‘GHC.Classes’
instance Ord Int -- Defined in ‘GHC.Classes’
instance Show Int -- Defined in ‘GHC.Show’
instance Read Int -- Defined in ‘GHC.Read’
instance Enum Int -- Defined in ‘GHC.Enum’
instance Num Int -- Defined in ‘GHC.Num’
instance Real Int -- Defined in ‘GHC.Real’

instance Bounded Int -- Defined in ‘GHC.Enum’

instance Integral Int -- Defined in ‘GHC.Real’
```

- As datatype `Word` does not become negative, the bounds are different.

- You almost never want a `Float` unless you're doing graphics programming such
  as with OpenGL.

```haskell
-- `Fractional a =>` denotes a **type class constraint,** where type 'a' can be
-- whatever you want given that it implements the `Fractional` type class.
Prelude> :t (/)
(/) :: Fractional a => a -> a -> a
-- Even though (/) takes in integers here, it returns a float. Default return
-- value type is `Double`.
Prelude> 4 / 2
2.0
Prelude>
```

- Use `:t` and `:i` in order to get type and information for infix operations.
  Generally types will implement `Eq` (for equality comparisons) or `Ord` (for
  ordering comparisons).

********** START EXERCISES: FIND THE MISTAKES **********

The following lines of code may have mistakes - some of them won't compile! You
know what you need to do.

1. `not True && true`
2. `not (x = 6)`
3. `(1 * 2) > 5`
4. `[Merry] > [Happy]`
5. `[1, 2, 3] ++ "look at me!"`

1. Will not compile; must capitalize `true` to `True`.

(CORRECT)

```haskell
Prelude> not True && true

<interactive>:1:13: error:
    • Variable not in scope: true :: Bool
    • Perhaps you meant data constructor ‘True’ (imported from Prelude)
Prelude> not True && True
False
Prelude>
```

2. Will not compile; `x` is not defined. Define `x` before executing a
   comparison, and assuming it is now in scope, change boolean calculation to
   comparison instead of assignment.

(NOT SURE WHAT I AM SUPPOSED TO DO, ISOLATED CONTEXT)

```haskell
Prelude> x = 6
Prelude> not (x == 6)
False
Prelude>
```

3. No error here, will return `False`.

(CORRECT)

```haskell
Prelude> (1 * 2) > 5
False
Prelude>
```

4. Will not compile because variables `Merry` and `Happy` are undefined and of
   unknown types. Cast as strings using double quotes to effectively compare it.
   Result should then be `False`, as ord|string compares by alphabetical order.

(CORRECT IN COMPILE ERROR, INCORRECT IN EVENTUAL RESULT)

```haskell
Prelude> [Merry] > [Happy]

<interactive>:3:2: error:
    Data constructor not in scope: Merry :: ()

<interactive>:3:12: error:
    Data constructor not in scope: Happy :: ()
Prelude> ["Merry"] > ["Happy"]
-- Likely true because "M" has a higher ordinal than "H".
True
Prelude>
```

5. Not sure whether Haskell has lists of arbitrary types, but if a list data
   structure can only accept a single type, then this will result in a compile
   error in concatenating integer and string types in the same list. In that
   case, cast the integers to string types to result in a list of 4 elements.

(INCORRECT, also need to cast second argument as a list.)

```haskell
Prelude> [1, 2, 3] ++ "look at me!"

<interactive>:5:2: error:
    • No instance for (Num Char) arising from the literal ‘1’
    • In the expression: 1
      In the first argument of ‘(++)’, namely ‘[1, 2, 3]’
      In the expression: [1, 2, 3] ++ "look at me!"
Prelude> ["1", "2", "3"] ++ "look at me!"

<interactive>:6:20: error:
    • Couldn't match type ‘Char’ with ‘[Char]’
      Expected type: [[Char]]
        Actual type: [Char]
    • In the second argument of ‘(++)’, namely ‘"look at me!"’
      In the expression: ["1", "2", "3"] ++ "look at me!"
      In an equation for ‘it’: it = ["1", "2", "3"] ++ "look at me!"
Prelude> ["1", "2", "3"] ++ ["look at me!"]
["1","2","3","look at me!"]
Prelude>
```

********** END EXERCISES: FIND THE MISTAKES **********

- Haskell does not have if/else statements, but it does have ternary statements.

```haskell
Prelude> t = "Truthin'"
Prelude> f = "Falsin'"
Prelude> if True then t else f
"Truthin'"
Prelude>
```

```haskell
-- Condition passed to if-expression must resolve to type `Bool`. In this case,
-- `Num a => a` was passed, and `Bool` doesn't implement `Num`. Haskell doesn't
-- cast between types underneath the hood.
Prelude> dog = "adopt a dog"
Prelude> cat = "or a cat"
Prelude> x = 0
Prelude> if x * 100 then dog else cat

<interactive>:7:4: error:
    • No instance for (Num Bool) arising from a use of ‘*’
    • In the expression: x * 100
      In the expression: if x * 100 then dog else cat
      In an equation for ‘it’: it = if x * 100 then dog else cat
Prelude>
```