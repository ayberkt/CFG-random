{-# LANGUAGE UnicodeSyntax #-}

module Main where

import Language.Grammar
import System.Random

arithmetic :: CFG String Char
arithmetic =
  CFG { terminals = ["+", "*"]
      , nonterminals = ['P']
      , productions =
          [ 'P' ⟹ [Right 'P', Left  " * " , Right 'P']
          , 'P' ⟹ [Right 'P', Left  " + " , Right 'P']
          , 'P' ⟹ [Right 'P', Left  " + " , Right 'P']
          , 'P' ⟹ [Right 'P', Left  " - " , Right 'P']
          , 'P' ⟹ [Left "10"]
          ] ++ ((\x -> 'P' ⟹ [Left (show x)]) <$> ([1..10] :: [Integer]))
      , start = 'P'
      }

main :: IO ()
main = do
  randomGen <- newStdGen
  let lower = 1 :: Int
      upper = 10000 :: Int
      nums = randomRs (lower, upper) randomGen
      result = fuzzTop nums arithmetic
  putStrLn result
