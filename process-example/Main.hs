module Main where


import Control.Distributed.Process (
  Process, NodeId, spawnLocal, getSelfPid,
  register, whereisRemoteAsync, WhereIsReply(WhereIsReply),
  expect, say)
import Control.Distributed.Process.Node (
  runProcess, initRemoteTable)
import Control.Distributed.Process.Backend.SimpleLocalnet (
  initializeBackend, Backend(newLocalNode, findPeers))

import System.Environment (
  getArgs)
import Control.Monad (
  forever, forM_)


master :: Backend -> IO ()
master backend = do
  nodes <- findPeers backend 1000000
  localNode <- newLocalNode backend
  runProcess localNode (masterProcess nodes)


masterProcess :: [NodeId] -> Process ()
masterProcess nodeIDs = do
  forM_ nodeIDs (\nodeID -> whereisRemoteAsync nodeID "worker")
  WhereIsReply name pid <- expect
  say name
  say (show pid)
  return ()


worker :: Backend -> IO ()
worker backend = do
  localNode <- newLocalNode backend
  runProcess localNode workerProcess


workerProcess :: Process ()
workerProcess = do
  workerID <- getSelfPid
  register "worker" workerID
  forever (do
    () <- expect
    return ())


main :: IO ()
main = do

  [role, host, port] <- getArgs

  backend <- initializeBackend host port initRemoteTable

  case role of
    "master" -> master backend
    "worker" -> worker backend

