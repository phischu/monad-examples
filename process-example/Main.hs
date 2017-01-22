{-# LANGUAGE StaticPointers, DeriveGeneric, DeriveAnyClass #-}
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
import Data.Binary (
  Binary)
import GHC.Generics (
  Generic)

import System.Environment (
  getArgs)
import Control.Monad (
  forever, forM)


data CheckNumber = CheckNumber ProcessId Integer
  deriving (Generic, Binary)

data CheckResult = CheckResult ProcessId Integer
  deriving (Generic, Binary)


masterProcess :: [NodeId] -> Process ()
masterProcess nodeIds = do

  say (show (length nodeIds))

  workerIds <- forM nodeIds (\nodeId ->
    spawn nodeId (staticClosure staticWorkerProcess))

  masterId <- getSelfPid

  let workItems = map (CheckNumber masterId) [1..]

  forM (zip workerIds workItems) (\(workerId, workItem) -> do
    send workerId workItem)

  masterLoop (drop (length workerIds) workItems)


masterLoop :: [CheckNumber] -> Process ()
masterLoop (workItem : workItems) = do
  CheckResult workerId number <- expect
  say (show number)
  send workerId workItem
  masterLoop workItems


workerProcess :: Process ()
workerProcess = forever (do
  workerId <- getSelfPid
  CheckNumber masterId number <- expect
  send masterId (CheckResult workerId number))


staticWorkerProcess :: Static (Process ())
staticWorkerProcess = staticPtr (static workerProcess)


main :: IO ()
main = do

  [role, host, port] <- getArgs

  backend <- initializeBackend host port initRemoteTable

  case role of
    "master" -> startMaster backend masterProcess
    "slave" -> startSlave backend

