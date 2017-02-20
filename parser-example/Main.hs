{-| A parser for chemical formulas.
    For example H2O parses to [(Hydrogen, 2), (Oxygen, 1)].

    You could add more elements.
-}
{-# language OverloadedStrings #-}
module Main where


import Data.Attoparsec.Text (
  Parser, parseOnly, string, decimal, endOfInput,
  option, choice, many1)

import Data.Text (
  Text)


-- | The formula for water.
waterFormula :: Text
waterFormula = "H2O"

-- | The formula for salt.
saltFormula :: Text
saltFormula = "NaCl"

-- | The formula for helium gas.
heliumFormula :: Text
heliumFormula = "He"


-- | A chemical formula is a list of pairs of an element and its number of occurences.
type ChemicalFormula = [(Element, Int)]


-- | A short enumeration of elements.
data Element =
  Hydrogen |
  Oxygen |
  Helium |
  Sodium |
  Chlorine
    deriving (Show, Eq, Ord)


-- | We parse a chemical formula by repeatedly parsing pairs of element and number.
chemicalFormulaParser :: Parser ChemicalFormula
chemicalFormulaParser = do
  chemicalFormula <- many1 elementAndNumberParser
  endOfInput
  return chemicalFormula


-- | We parse an element followed optionally by a number by first parsing the element
-- and then optionally the number. If no number is given the default is 1.
elementAndNumberParser :: Parser (Element, Int)
elementAndNumberParser = do
  element <- elementParser
  number <- option 1 decimal
  return (element, number)


-- | We parse an element as the choice between all elements we know. If a choice fails
-- we try the next one.
elementParser :: Parser Element
elementParser = choice [
  specificElementParser "He" Helium,
  specificElementParser "H" Hydrogen,
  specificElementParser "O" Oxygen,
  specificElementParser "Na" Sodium,
  specificElementParser "Cl" Chlorine]


-- | Given the text representing an element and the element itself we first cosume
-- the text and then return the element. If we can't parse the given text we fail.
specificElementParser :: Text -> Element -> Parser Element
specificElementParser elementText element = do
  _ <- string elementText
  return element


-- | We print the results of parsing three example.
main :: IO ()
main = do
  print (parseOnly chemicalFormulaParser waterFormula)
  print (parseOnly chemicalFormulaParser saltFormula)
  print (parseOnly chemicalFormulaParser heliumFormula)

