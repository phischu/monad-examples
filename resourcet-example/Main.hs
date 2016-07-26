module Main where


import Control.Monad.Trans.Resource (
  ResIO, runResourceT, allocate, ReleaseKey)

import System.IO (
  openFile, IOMode(AppendMode), Handle,
  hPutStrLn, hFlush,
  hClose)

import Control.Monad.IO.Class (
  liftIO)


allocateFile :: FilePath -> IOMode -> ResIO (ReleaseKey, Handle)
allocateFile filename ioMode = allocate openAction closeAction where

  openAction = do
    putStrLn ("Opening " ++ filename)
    openFile filename ioMode

  closeAction handle = do
    putStrLn ("Closing " ++ filename)
    hClose handle


askForFile :: ResIO Handle
askForFile = do

  liftIO (putStrLn "Enter filename:")
  filename <- liftIO getLine

  (_, handle) <- allocateFile filename AppendMode
  return handle


loop :: Handle -> ResIO ()
loop handle = do

  liftIO (putStrLn "Appending to file. Enter stop to stop:")
  userInput <- liftIO getLine

  case userInput of

    "stop" -> do
      return ()

    _ -> do
      liftIO (hPutStrLn handle userInput)
      liftIO (hFlush handle)
      loop handle


main :: IO ()
main = runResourceT (do
  handle <- askForFile
  loop handle)

