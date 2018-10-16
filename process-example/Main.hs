{-# LANGUAGE StaticPointers, DeriveGeneric, DeriveAnyClass, OverloadedStrings #-}
{-| Let's write a distributed password recovery tool.
    Run it like this:
    > process-example slave localhost 3014
    > process-example slave localhost 3015
    > process-example master localhost 3013

    The master process will send the task to check passwords of a certain
    length to the slave processes.

    You could try out different SHA256 hashes for (short) passwords.
-}
module Main where


import Control.Distributed.Process (
  Process, NodeId, ProcessId, Static,
  getSelfPid, say, spawn, send, expect)
import Control.Distributed.Process.Node (
  initRemoteTable)
import Control.Distributed.Process.Backend.SimpleLocalnet (
  initializeBackend, startMaster, startSlave)
import Control.Distributed.Static (
  staticPtr, staticClosure)
import Data.ByteString.Char8 (
  pack)
import Crypto.Hash.SHA256 (
  hash)
import Data.ByteString.Base16 (
  decode)
import Data.Binary (
  Binary)
import GHC.Generics (
  Generic)

import System.Environment (
  getArgs)
import Control.Monad (
  forever, forM)


data CheckLength =
  CheckLength ProcessId Int
    deriving (Generic, Binary)

data Result =
  Found String |
  NotFound ProcessId Int
    deriving (Generic, Binary)


masterProcess :: [NodeId] -> Process ()
masterProcess nodeIds = do

  say ("Number of workers: " ++ show (length nodeIds))

  workerIds <- forM nodeIds (\nodeId ->
    spawn nodeId (staticClosure staticWorkerProcess))

  masterId <- getSelfPid

  let workItems = map (CheckLength masterId) [1..]

  forM (zip workerIds workItems) (\(workerId, workItem) -> do
    send workerId workItem)

  masterLoop (drop (length workerIds) workItems)


masterLoop :: [CheckLength] -> Process ()
masterLoop (workItem : workItems) = do

  result <- expect

  case result of

    Found password -> do
      say ("Found password: " ++ password)

    NotFound workerId passwordLength -> do
      say ("Not found with length: " ++ show passwordLength)
      send workerId workItem
      masterLoop workItems


workerProcess :: Process ()
workerProcess = forever (do

  workerId <- getSelfPid

  CheckLength masterId passwordLength <- expect

  say ("Working on length: " ++ show passwordLength)

  case findPassword passwordLength of

    Nothing -> do
      send masterId (NotFound workerId passwordLength)

    Just password -> do
      send masterId (Found password))


staticWorkerProcess :: Static (Process ())
staticWorkerProcess = staticPtr (static workerProcess)


findPassword :: Int -> Maybe String
findPassword passwordLength = go passwordLength allLetters [] where

  go 0 _ password = if matching password
    then Just password
    else Nothing
  go _ [] _ =
    Nothing
  go n (letter : letters) password =
    case go (n - 1) allLetters (letter : password) of
      Just password' -> Just password'
      Nothing -> go n letters password

  matching password = hash (pack password) == targetHash

  allLetters = ['a' .. 'z']

  (targetHash, _) = decode
    "50d858e0985ecc7f60418aaf0cc5ab587f42c2570a884095a9e8ccacd0f6545c"


main :: IO ()
main = do

  [role, host, port] <- getArgs

  backend <- initializeBackend host port initRemoteTable

  case role of
    "master" -> startMaster backend masterProcess
    "slave" -> startSlave backend

