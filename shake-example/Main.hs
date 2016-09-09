{-| We have file named filenames that contains a newline-delimited list of
    filenames. We want to count the total number of lines in all listed files
    and write that count to a file named linecount. If we rerun we want to
    avoid any unnecessary work.

    You could try adding *.count files that remember the line counts of
    individual files.
-}
module Main where


import Development.Shake (
    Rules, Action, shakeArgs, shakeOptions,
    want, (%>),
    readFileLines, readFile', writeFile')
import Control.Monad (
    forM)


-- | We have one build rule for the linecount file. We specify that we want
--   the linecount file to be created if it is missing or recreated if it
--   is outdated.
rules :: Rules ()
rules = do

  "shake-data/linecount" %> linecountAction

  want ["shake-data/linecount"]


-- | Our action takes the path to the file to be created. It reads the list
--   of filenames. For each listed file it reads its content. It writes the
--   sum of the individual line counts to a file at the given path.
--   The trick is that it remembers all reads and writes to avoid reading
--   the same file in the next invocation if it didn't change.
linecountAction :: FilePath -> Action ()
linecountAction linecountPath = do

  fileNames <- readFile' "shake-data/filenames"

  fileContents <- forM (lines fileNames) readFile'

  let linecount = sum (map (length . lines) fileContents)

  writeFile' linecountPath (show linecount)


-- | Run the specified rules.
main :: IO ()
main = shakeArgs shakeOptions rules


