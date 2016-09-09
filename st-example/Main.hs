{-| We have a vector of Word8 values. We want to compute a histogram of these
    values. The result is a vector of length 256 that contains at each index
    the number of occurences of the index in the original vector.

    In imperative languages we would create a new vector of length 256 and then
    in a loop increase its values at the corresponding indices by one. In
    Haskell we can do just that.

    Write a second function 'imperativeSum' that sums the elements of a vector
    in a loop.
-}
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


-- | This histogram function does not have side effects. The 'Vector.create' function
-- runs a side-effecting computation and freezes the result.
histogram :: Vector Word8 -> Vector Int
histogram vector = Vector.create (histogramST vector)


-- | This histogram function uses explicit allocation and destructive updates.
histogramST :: Vector Word8 -> ST s (MVector s Int)
histogramST vector = do

  resultVector <- MVector.new 256

  Vector.forM_ vector (\value -> do

    MVector.modify resultVector (+1) (fromIntegral value))

  return resultVector


-- | Print the histogram of the vector [5,6,2,8,8].
main :: IO ()
main = do
  print (histogram (Vector.fromList [5,6,2,8,8]))

