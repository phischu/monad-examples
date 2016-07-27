{-# LANGUAGE OverloadedStrings #-}
module Main where


import Web.Scotty (
  ScottyM, scotty, get,
  ActionM, text, param)

import qualified Data.Text.Lazy as Text (
  toUpper)


routes :: ScottyM ()
routes = do
  get "/" rootAction
  get "/allcaps/:input" allcapsAction


rootAction :: ActionM ()
rootAction = do
  text "Hello User"


allcapsAction :: ActionM ()
allcapsAction = do
  input <- param "input"
  text (Text.toUpper input)


main :: IO ()
main = scotty 3000 routes


