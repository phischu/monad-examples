{-| A web service for ALLCAPS. If you request \/allcaps\/kitten you get KITTEN
    as a response.

    Extend the server so that if someone actually requests \/allcaps\/kitten you
    respond with status 404 and body text @Not found@. You will need the 'status'
    function for that.
-}
{-# LANGUAGE OverloadedStrings #-}
module Main where


import Web.Scotty (
  ScottyM, scotty, get,
  ActionM, text, param)

import qualified Data.Text.Lazy as Text (
  toUpper)


-- | We define two routes and the corresponding actions. The colon input part
-- captures that part of the request and makes it available in the allcaps
-- action.
routes :: ScottyM ()
routes = do
  get "/" rootAction
  get "/allcaps/:input" allcapsAction


-- | The root action greets the user.
rootAction :: ActionM ()
rootAction = do
  text "Hello user"


-- | The allcaps action gets the captured part of the request, capitalizes it
-- and responds with it to the user.
allcapsAction :: ActionM ()
allcapsAction = do
  input <- param "input"
  text (Text.toUpper input)


-- | Run a scotty server on port 3000.
main :: IO ()
main = scotty 3000 routes


