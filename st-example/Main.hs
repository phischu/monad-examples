module Main where

import Prelude hiding (
    length)
import Data.Vector.Unboxed (
    Vector, create, (!), length, fromList, forM_)
import Data.Vector.Unboxed.Mutable (
    MVector, new, modify)
import Control.Monad.ST (
    ST)
import Data.Word (
    Word8)

histogram :: Vector Word8 -> Vector Int
histogram vector = create (histogramST vector)

histogramST :: Vector Word8 -> ST s (MVector s Int)
histogramST vector = do
    resultVector <- new 256
    forM_ vector (\value -> do
        modify resultVector (+1) (fromIntegral value))
    return resultVector

main :: IO ()
main = do
    print (histogram (fromList [5,6,2,8,8]))
