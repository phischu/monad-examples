{-# language OverloadedStrings #-}
module Main where


import Data.Attoparsec.Text (
  Parser, parseOnly, string, decimal, endOfInput,
  option, choice, many1)

import Data.Text (
  Text)


waterFormula :: Text
waterFormula = "H2O"

saltFormula :: Text
saltFormula = "NaCl"

heliumFormula :: Text
heliumFormula = "He2"


type ChemicalFormula = [(Element, Int)]

data Element =
  Hydrogen |
  Oxygen |
  Helium |
  Sodium |
  Chlorine
    deriving (Show, Eq, Ord)


chemicalFormulaParser :: Parser ChemicalFormula
chemicalFormulaParser = do
  chemicalFormula <- many1 elementAndNumberParser
  endOfInput
  return chemicalFormula


elementAndNumberParser :: Parser (Element, Int)
elementAndNumberParser = do
  element <- elementParser
  number <- option 1 decimal
  return (element, number)


elementParser :: Parser Element
elementParser = choice [
  specificElementParser "He" Helium,
  specificElementParser "H" Hydrogen,
  specificElementParser "O" Oxygen,
  specificElementParser "Na" Sodium,
  specificElementParser "Cl" Chlorine]


specificElementParser :: Text -> Element -> Parser Element
specificElementParser elementText element = do
  _ <- string elementText
  return element


main :: IO ()
main = do
  print (parseOnly chemicalFormulaParser waterFormula)
  print (parseOnly chemicalFormulaParser saltFormula)
  print (parseOnly chemicalFormulaParser heliumFormula)

