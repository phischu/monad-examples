{-| We have two variables and we want to atomically swap their contents.

    Go ahead and change the code to atomically swap the contents of three variables.
-}
module Main where

import Control.Concurrent.STM (
    STM, TVar, readTVar, writeTVar,
    atomically, newTVarIO, readTVarIO)
import Control.Concurrent (
    forkIO, threadDelay)
import Control.Monad (
    replicateM_)


-- | Swap the contents of two given variables in a transaction.
swapTVars :: TVar Int -> TVar Int -> STM ()
swapTVars tvar1 tvar2 = do

    value1 <- readTVar tvar1
    value2 <- readTVar tvar2

    writeTVar tvar1 value2
    writeTVar tvar2 value1


-- | We create two transactional variables with contents 1 and 2 respectively.
-- Then we fork 100001 threads that all atomically swap the same two variables.
-- After 1 second we read their contents. Because the number of threads was odd
-- the first variable should contain value 2 and the second variable should
-- contain value 1.
main :: IO ()
main = do

    tvar1 <- newTVarIO 1
    tvar2 <- newTVarIO 2

    replicateM_ 100001 (forkIO (atomically (swapTVars tvar1 tvar2)))

    threadDelay 1000000

    value1 <- readTVarIO tvar1
    value2 <- readTVarIO tvar2

    putStrLn ("value1: " ++ show value1)
    putStrLn ("value2: " ++ show value2)
