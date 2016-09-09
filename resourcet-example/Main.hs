{-| We ask the user for a filename. We open that file and ask the user for some input.
    We append the given input to the file. We want to be sure that we close the file
    no matter what happens.
-}
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
allocateFile filename ioMode = let

  openAction = do
    putStrLn ("Opening " ++ filename)
    openFile filename ioMode

  closeAction handle = do
    putStrLn ("Closing " ++ filename)
    hClose handle

  in allocate openAction closeAction


main :: IO ()
main = runResourceT (do

  filename <- liftIO (do

    putStrLn "Enter filename:"
    getLine)

  (_, handle) <- allocateFile filename AppendMode

  liftIO (do

    putStrLn "Enter string to append:"
    userInput <- getLine

    hPutStrLn handle userInput
    hFlush handle))

