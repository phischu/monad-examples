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


main :: IO ()
main = runResourceT (do

  liftIO (putStrLn "Enter filename:")
  filename <- liftIO getLine

  (_, handle) <- allocateFile filename AppendMode

  liftIO (putStrLn "Enter string to append:")
  userInput <- liftIO getLine

  liftIO (hPutStrLn handle userInput)
  liftIO (hFlush handle))

