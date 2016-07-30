module Main where

import Data.Vector.Unboxed (
  Vector)
import qualified Data.Vector.Unboxed as Vector (
  create, fromList, forM_)
import Data.Vector.Unboxed.Mutable (
  MVector)
import qualified Data.Vector.Unboxed.Mutable as MVector (
  new, modify)
import Control.Monad.ST (
  ST)
import Data.Word (
  Word8)


histogram :: Vector Word8 -> Vector Int
histogram vector = Vector.create (histogramST vector)


histogramST :: Vector Word8 -> ST s (MVector s Int)
histogramST vector = do

  resultVector <- MVector.new 256

  Vector.forM_ vector (\value -> do

    MVector.modify resultVector (+1) (fromIntegral value))

  return resultVector


main :: IO ()
main = do
  print (histogram (Vector.fromList [5,6,2,8,8]))

