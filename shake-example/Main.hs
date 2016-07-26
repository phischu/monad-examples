module Main where


import Development.Shake (
    Rules, Action, shakeArgs, shakeOptions,
    action,
    readFileLines, readFile', writeFile')
import Control.Monad (
    forM)


sumRules :: Rules ()
sumRules = do

  action sumAction


sumAction :: Action ()
sumAction = do

  filePaths <- readFileLines "shake-data/filenames"

  fileContents <- forM filePaths readFile'

  writeFile' "shake-data/sum" (show (sum (map length fileContents)))


main :: IO ()
main = shakeArgs shakeOptions sumRules


