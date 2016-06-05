{-# LANGUAGE UnicodeSyntax #-}

module Main where

import Language.Grammar
import System.Random

palindromes :: CFG String Char
palindromes =
  CFG { terminals = ["0", "1", ""]
      , nonterminals = ['P']
      , productions =
          [ 'P' ⟹ [Left ""]
          , 'P' ⟹ [Left "0"]
          , 'P' ⟹ [Left "1"]
          , 'P' ⟹ [Left "0"
                    , Right 'P'
                    , Left "0"]
          , 'P' ⟹ [ Left "1"
                    , Right 'P'
                    , Left "1"]
          ]
      , start = 'P'
      }



main :: IO ()
main = do
  randomGen <- newStdGen
  let lower = 1 :: Int
      upper = 10000 :: Int
      nums = randomRs (lower, upper) randomGen
      result = fuzzTop nums palindromes
  putStrLn result
