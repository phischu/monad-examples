module Main where

import Development.Shake (
    Rules, Action, shakeArgs, shakeOptions,
    action,
    readFileLines, readFile', writeFile')
import Control.Monad (
    forM)

sumRules :: Rules ()
sumRules = action sumAction


sumAction :: Action ()
sumAction = do

    summandFilePaths <- readFileLines "summands"

    summandStrings <- forM summandFilePaths readFile'

    let summands = map read summandStrings :: [Integer]
        sumString = show (sum summands)

    writeFile' "sum" sumString


main :: IO ()
main = shakeArgs shakeOptions sumRules
