module Main where


import Test.Hspec (
  Spec, hspec, describe, specify,
  shouldBe)
import Test.QuickCheck (
  property)


import Data.Char (
  toUpper, toLower)


main :: IO ()
main = hspec specification


specification :: Spec
specification = do

  describe "capitalize" capitalizeSpec


capitalizeSpec :: Spec
capitalizeSpec = do

  specify "Capitalizes \"monad\"" (do
    capitalize "monad" `shouldBe` "Monad")

  specify "Empty string" (do
    capitalize "" `shouldBe` "")

  specify "Allcaps string" (do
    capitalize "NOTATION" `shouldBe` "Notation")

  specify "Is idempotent" (do
    property (\s -> capitalize (capitalize s) == capitalize s))


capitalize :: String -> String
capitalize [] = []
capitalize (c : cs) = toUpper c : map toLower cs

