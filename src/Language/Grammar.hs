{-# LANGUAGE UnicodeSyntax #-}

module Language.Grammar where

import System.Random

data CFG s v =
  CFG { productions :: [(v, [Either s v])]
      , start :: v
      }

(⟹) :: a -> b -> (a, b)
(⟹) x y = (x, y)
infixr 4 ⟹


lookupAll :: Eq b => b -> [(b, ab)] -> [ab]
lookupAll _ [] = []
lookupAll t ((k, v):xs) =
  if t == k
  then v : lookupAll t xs
  else lookupAll t xs

fuzz :: (Monoid a, Eq a, Eq b) => [Int] -> CFG a b -> Either a b -> a
fuzz [] _ _  = error "list of random values cannot be empty."
fuzz _ _ (Left x) = x
fuzz (r:rs) c (Right v) =
  let xs = lookupAll v (productions c)
      chooseRandom vs = vs !! (r `mod` length xs)
      ps = chooseRandom xs
      applyTimes f n = foldr (.) id (replicate n f)
      ts x = applyTimes tail x rs
  in mconcat $ zipWith id (map (\x -> fuzz (ts x) c) [1..]) ps

fuzzTop :: (Monoid a, Eq a, Eq b) => [Int] -> CFG a b -> a
fuzzTop nums c = fuzz nums c (Right $ start c)
