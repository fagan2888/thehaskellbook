# Chapter 10

- Folds
    - General concept called "catamorphisms"
    - Catamorphism: deconstructing data
    - If the spine of a list is the structure of a list, then a fold is what can
      reduce the structure.

- Bringing you into the fold

```haskell
-- GHC 7.10 abstracts out list-specific part of folding into a typeclass
-- (not `[]`.)
Prelude> :t foldr
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
Prelude>
-- We can always recover the concrete type from the generic type. Vice versa not
-- possible.
Prelude> :{
Prelude| let listFoldr   :: (a -> b -> b)
Prelude|                 -> b
Prelude|                 -> [] a
Prelude|                 -> b
Prelude|     listFoldr = foldr
Prelude| :}
Prelude> :t listFoldr
listFoldr :: (a -> b -> b) -> b -> [a] -> b
Prelude>
```

- Some parallels between `map` and `foldr`
    - `map` applies a function to each member of a list and returns a list
    - `foldr` replaces the `cons` constructors with the function and reduces the
      list.

- Recursive patterns

```haskell
-- These reproductions of `sum`, `length`, `product`, and `concat` have the
-- base case be the identity of the function, and a main function that recurses
-- to the right. Head of list gets evaluated, set aside, and function moves to
-- the right and evaluates the next head.
Prelude> :{
Prelude| sum' :: [Integer] -> Integer
Prelude| sum' [] = 0
Prelude| sum' (x : xs) = x + sum' xs
Prelude|
Prelude| length' :: [a] -> Integer
Prelude| length' [] = 0
Prelude| length' (_ : xs) = 1 + length' xs
Prelude|
Prelude| product' :: [Integer] -> Integer
Prelude| product' [] = 1
Prelude| product' (x : xs) = x * product' xs
Prelude|
Prelude| concat' :: [[a]] -> [a]
Prelude| concat' [] = []
Prelude| concat' (x : xs) = x ++ concat' xs
Prelude| :}
Prelude>
```

- Fold right

```haskell
Prelude> :{
Prelude| foldr' :: (a -> b -> b) -> b -> [a] -> b
Prelude| foldr' f z [] = z
Prelude| foldr' f z (x : xs) = f x (foldr' f z xs)
Prelude| :}
Prelude> foldr' (+) 0 [1, 2, 3]
6
-- Here, we can see how `foldr''` or `foldr` is very similar to the
-- recursive patterns from earlier. There is a method, and an identity
-- value, evaluated to the right over a list.
--
-- Since `(+)` is strict in its arguments, it unconditionally forces the rest
-- of the fold.
--
Prelude> :{
Prelude| foldr'' :: (a -> b -> b) -> b -> [a] -> b
Prelude| foldr'' f z xs =
Prelude|     case xs of
Prelude|         [] -> z
Prelude|         (x : xs) -> f x (foldr'' f z xs)
Prelude| :}
-- The expression below could be rewritten as:
--
-- `(+) 1 ((+) 2 ((+) 3 0))`
-- `1 + (2 + (3 + 0))`
-- `1 + (2 + 3)`
-- `1 + 5`
-- `6`
--
Prelude> foldr'' (+) 0 [1, 2, 3]
6
Prelude>
```

```haskell
-- This is a trick to show how `foldr` associates.
Prelude> map show [1..5]
["1","2","3","4","5"]
Prelude> xs = map show [1..5]
Prelude> foldr (\x y -> concat ["(", x, "+", y, ")"]) "0" xs
"(1+(2+(3+(4+(5+0)))))"
Prelude>
```

- Folding occurs in two stages: traversal and folding.
    - Traversal: fold recurses over the spine.
    - Folding: Reduction of folding function applied over the values.

```haskell
Prelude> :{
Prelude| foldr'' :: (a -> b -> b) -> b -> [a] -> b
Prelude| foldr'' f z xs =
Prelude|     case xs of
Prelude|         [] -> z
-- If method `f` doesn't evaluate the second argument, then the spine will
-- not be forced.
--
-- This means`foldr` can avoid evaluating not only the values, but also the
-- spine. This means `foldr` can be used with lists that are potentially
-- infinite (e.g. stream processing).
--
-- There is no guarantee that `fold` on infinite list will finish evaluating
-- since it depends on the fold function and input data.
Prelude|         (x : xs) -> f x (foldr'' f z xs)
Prelude| :}
Prelude> :{
Prelude| myAny :: (a -> Bool) -> [a] -> Bool
Prelude| myAny f xs =
Prelude|     foldr'' (\x b -> f x || b) False xs
Prelude| :}
-- `[1..]` is an infinite list, yet `myAny` doesn't fail because it returns
-- immediately if a value evaluates to True.
Prelude> myAny even [1..]
True
Prelude>
```

```haskell
Prelude> u = undefined
-- Here, "bottom" is part of the value construction.
Prelude> foldr (+) 0 [1, 2, 3, 4, u]
*** Exception: Prelude.undefined
CallStack (from HasCallStack):
  error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
  undefined, called at <interactive>:111:5 in interactive:Ghci17
Prelude> xs = take 4 [1, 2, 3, 4, u]
-- `foldr` doesn't evaluate the value if it is not forced.
Prelude> foldr (+) 0 xs
10
Prelude>
-- Here, "bottom" is part of the spine as well.
Prelude> xs' = [1, 2, 3, 4] ++ u
Prelude> foldr (+) 0 xs'
*** Exception: Prelude.undefined
CallStack (from HasCallStack):
  error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
  undefined, called at <interactive>:111:5 in interactive:Ghci17
Prelude> xs'' = take 4 ([1, 2, 3, 4] ++ u)
-- `foldr` also doesn't evaluate the spine if not needed.
Prelude> foldr (+) 0 xs''
10
-- Method `length` is different, since it evaluates the spine only
Prelude> length [1, 2, 3, 4, u]
5
-- If "bottom" is part of the spine, then `length` is forced to raise
-- an exception.
Prelude> length ([1, 2, 3, 4] ++ u)
*** Exception: Prelude.undefined
CallStack (from HasCallStack):
  error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
  undefined, called at <interactive>:111:5 in interactive:Ghci17
-- Method `take` is non-strict, and stops returning elements of list upon
-- hitting length limit given.
Prelude> length (take 4 xs')
4
Prelude>
```

```haskell
Prelude> xs = [1, 2] ++ undefined
-- Method `take 4` would hit bottom, but doesn't matter due to `take 2`
-- in between.
Prelude> length $ take 2 $ take 4 xs
2
Prelude>
```

```haskell
-- Assume an anonymous method that ignores all inputs and just returns 9001.
--
-- This method never forces evaluation of any of its argument.
Prelude> foldr (\_ _ -> 9001) 0 [1..5]
9001
Prelude> foldr (\_ _ -> 9001) 0 [1, 2, 3, undefined]
9001
Prelude> foldr (\_ _ -> 9001) 0 ([1, 2, 3] ++ undefined)
9001
-- Only if the first `cons` cell is "bottom", does the method raise an
-- exception.
Prelude> foldr (\_ _ -> 9001) 0 undefined
*** Exception: Prelude.undefined
CallStack (from HasCallStack):
  error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
  undefined, called at <interactive>:132:24 in interactive:Ghci32
-- This input argument works b ecause it isn't the first `cons cell` that is
-- bottom. The undefined values are inside the cons cell, not the spine
-- itself. The cons cells "contain" bottom values but are not themselves
-- bottom.
Prelude> foldr (\_ _ -> 9001) 0 [undefined, undefined]
9001
Prelude>
```

- Fold left