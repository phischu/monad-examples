{-# LANGUAGE OverloadedStrings #-}
module Main where


import Database.Relational.Query (
  Relation, relation,
  table,
  query, (><))

import Person (
  Person, personTable)
import Pet (
  Pet, petTable)


persons :: Relation () Person
persons = table personTable


pets :: Relation () Pet
pets = table petTable


personPets :: Relation () (Person, Pet)
personPets = relation (do
  person <- query persons
  pet <- query pets
  return (person >< pet))


main :: IO ()
main = putStrLn (show personPets)


