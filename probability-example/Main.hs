{-| You have two six-sided dice. You roll them and add five to their sum.
    Your enemy has two twenty-sided dice. He rolls both and takes the maximum.
    What is your chance of scoring higher than your enemy?

    You can extend the code to the following scenario:
    Now you have two enemies, what is your chance of scoring higher than both?
-}
module Main where

import Numeric.Probability.Distribution (
  T, uniform, norm, pretty)


-- | We specialize our probabilities to be rational numbers.
type Probability a = T Rational a


-- | Uniform distribution over the numbers [1 .. 6]
sixSided :: Probability Int
sixSided = uniform [1..6]


-- | Uniform distribution over the numbers [1 .. 20]
twentySided :: Probability Int
twentySided = uniform [1..20]


-- | Get the results of two six-sided rolls and add 5.
youRoll :: Probability Int
youRoll = norm (do
  firstRoll <- sixSided
  secondRoll <- sixSided
  return (firstRoll + secondRoll + 5))


-- | Get the results of two twenty-sided rolls and take their maximum.
enemyRolls :: Probability Int
enemyRolls = norm (do
  firstRoll <- twentySided
  secondRoll <- twentySided
  return (max firstRoll secondRoll))


-- | You win if your score is higher than the enemy's score.
youWin :: Probability Bool
youWin = norm (do
  yourScore <- youRoll
  enemyScore <- enemyRolls
  return (yourScore > enemyScore))


-- | Print the probabilities for winning and losing.
main :: IO ()
main = putStrLn (pretty show youWin)

