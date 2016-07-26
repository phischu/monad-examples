module Main where


import Development.Shake (
    Rules, Action, shakeArgs, shakeOptions,
    want, (%>),
    readFileLines, readFile', writeFile')
import Control.Monad (
    forM)


rules :: Rules ()
rules = do

  want ["shake-data/sum"]

  "shake-data/sum" %> (\_ -> sumAction)


sumAction :: Action ()
sumAction = do

  filePaths <- readFileLines "shake-data/filenames"

  fileContents <- forM filePaths readFile'

  writeFile' "shake-data/sum" (show (sum (map length fileContents)))


main :: IO ()
main = shakeArgs shakeOptions rules


