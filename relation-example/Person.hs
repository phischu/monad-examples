module Person where


import Database.Relational.Query.Table (
  Table, table)

import Data.Int (
  Int32)


data Person = Person {
  key :: Int32,
  name :: String,
  age :: Int32 }

personTable :: Table Person
personTable = table "person" ["key", "name", "age"]



