{-| We have written a function to capitalize a given string. We want to specify
    tests for that function. We have some concrete test cases and also
    properties that should hold for all inputs.

    The code to specify the test cases is repetitive. Abstract over the name
    of the specification, the example input and the expected output.
-}
module Main where


import Test.Hspec (
  Spec, hspec, describe, specify,
  shouldBe)
import Test.QuickCheck (
  property)


import Data.Char (
  toUpper, toLower)


-- | Capitalize the given string.
capitalize :: String -> String
capitalize [] = []
capitalize (c : cs) = toUpper c : map toLower cs


-- | Our main test specification. In this example we only have one function to test.
specification :: Spec
specification = do

  describe "capitalize" capitalizeSpec


-- | The specification for the capitalize function. We have three example cases and
-- one property.
capitalizeSpec :: Spec
capitalizeSpec = do

  specify "Capitalizes \"monad\"" (do
    capitalize "monad" `shouldBe` "Monad")

  specify "Empty string" (do
    capitalize "" `shouldBe` "")

  specify "Allcaps string" (do
    capitalize "NOTATION!" `shouldBe` "Notation")

  specify "Is idempotent" (do
    property (\s -> capitalize (capitalize s) == capitalize s))


-- | Run our tests.
main :: IO ()
main = hspec specification

