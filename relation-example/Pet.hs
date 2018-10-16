module Pet where


import Database.Relational.Table (
  Table, table)

import Data.Int (
  Int32)


data Pet = Pet {
  key :: Int32,
  name :: String,
  owner :: Int32 }

petTable :: Table Pet
petTable = table "pet" ["key", "name", "owner"]




