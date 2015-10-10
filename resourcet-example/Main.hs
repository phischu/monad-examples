module Main where


import Control.Monad.Trans.Resource (runResourceT)


main :: IO ()
main = runResourceT (do
    return ())
