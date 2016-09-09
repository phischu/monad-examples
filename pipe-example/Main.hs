{-| We have a stream of messages. A message consists of a user's name
    (the sender), the message content and a time stamp. We want to
    limit the number of messages to at most one message per three seconds.

    Add a pipe that filters messages from a user with a given user name.
    Compose it either before or after rate limiting and observe the result.
-}
{-# LANGUAGE OverloadedStrings #-}
module Main where


import Pipes (
  runEffect, Pipe, Producer, await, yield, each, (>->))
import Pipes.Prelude as Pipe (
  print)
import Data.Text (
  Text)


-- | The message type is a record of user name, content and timestamp.
data Message = Message {
  user :: UserName,
  content :: Text,
  timestamp :: Integer }
    deriving (Show)

-- | A user name is text.
type UserName = Text


-- | A pipe that takes messages and produces messages. It makes sure that no
-- messages with timestamps closer than 3 seconds get through.
rateLimit :: (Monad m) => Pipe Message Message m r
rateLimit = do

  message <- await
  yield message

  rateLimitLoop message


-- | Given the previous message await the new message and compare their
-- timestamps. If only yield the new message if the difference between
-- their timestamps is larger than 3.
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


-- | An example of a producer of messages.
exampleMessages :: (Monad m) => Producer Message m ()
exampleMessages = each [
  Message "Alice" "Wow, Haskell rocks! #haskell" 1,
  Message "Bob" "Look at us! #selfie" 6,
  Message "Charles" "@Bob Cat picture at example.com/cat.png" 7,
  Message "Alice" "Yeah, let's chat." 8]


-- | Compose the example messages with ratelimiting and a pipe that prints each
-- message received.
main :: IO ()
main = runEffect (
  exampleMessages >->
  rateLimit >->
  Pipe.print)

