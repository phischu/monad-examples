{-# LANGUAGE OverloadedStrings #-}
module Main where

import Pipes (runEffect, Pipe, Producer, await, yield, each, (>->))
import Pipes.Prelude as Pipe (filter, print)
import Data.Text (Text)
import Data.Set (Set)
import Data.Set as Set (fromList, member)

data Message = Message {
    user :: UserName,
    content :: Text,
    timestamp :: Integer }
        deriving (Show)

type UserName = Text

blacklist :: Set UserName
blacklist = Set.fromList ["Alice"]

isBlacklisted :: Message -> Bool
isBlacklisted message = Set.member (user message) blacklist

filterBlacklist :: (Monad m) => Pipe Message Message m r
filterBlacklist = Pipe.filter (not . isBlacklisted)

rateLimit :: (Monad m) => Pipe Message Message m r
rateLimit = do
    message <- await
    yield message
    rateLimitLoop message

rateLimitLoop :: (Monad m) => Message -> Pipe Message Message m r
rateLimitLoop previousMessage = do
    message <- await
    let timeDifference =
            timestamp message - timestamp previousMessage
    if timeDifference > 3
        then do
            yield message
            rateLimitLoop message
        else do
            rateLimitLoop previousMessage

exampleMessages :: (Monad m) => Producer Message m ()
exampleMessages = each [
    Message "Alice" "Wow, Haskell rocks! #haskell" 1,
    Message "Bob" "Look at us! #selfie" 2,
    Message "Charles" "@Bob Cat picture at example.com/cat.png" 3]

main :: IO ()
main = runEffect (
    exampleMessages >->
    filterBlacklist >->
    rateLimit >->
    Pipe.print)
