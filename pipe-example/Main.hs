{-# LANGUAGE OverloadedStrings #-}
module Main where


import Pipes (
  runEffect, Pipe, Producer, await, yield, each, (>->))
import Pipes.Prelude as Pipe (
  print)
import Data.Text (
  Text)


data Message = Message {
  user :: UserName,
  content :: Text,
  timestamp :: Integer }
    deriving (Show)

type UserName = Text


rateLimit :: (Monad m) => Pipe Message Message m r
rateLimit = do

  message <- await
  yield message

  rateLimitLoop message


rateLimitLoop :: (Monad m) => Message -> Pipe Message Message m r
rateLimitLoop previousMessage = do

  message <- await

  let timeDifference = timestamp message - timestamp previousMessage

  if timeDifference > 3
      then do
          yield message
          rateLimitLoop message
      else do
          rateLimitLoop previousMessage


exampleMessages :: (Monad m) => Producer Message m ()
exampleMessages = each [
  Message "Alice" "Wow, Haskell rocks! #haskell" 1,
  Message "Bob" "Look at us! #selfie" 6,
  Message "Charles" "@Bob Cat picture at example.com/cat.png" 7]


main :: IO ()
main = runEffect (
  exampleMessages >->
  rateLimit >->
  Pipe.print)

