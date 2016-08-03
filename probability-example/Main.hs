module Main where


import Numeric.Probability.Distribution (
  T, uniform, norm, pretty)


type Probability a = T Rational a


sixSided :: Probability Int
sixSided = uniform [1..6]


twentySided :: Probability Int
twentySided = uniform [1..20]


youRoll :: Probability Int
youRoll = norm (do
  firstRoll <- sixSided
  secondRoll <- sixSided
  return (firstRoll + secondRoll + 5))


enemyRolls :: Probability Int
enemyRolls = norm (do
  firstRoll <- twentySided
  secondRoll <- twentySided
  return (max firstRoll secondRoll))


youWin :: Probability Bool
youWin = norm (do
  yourScore <- youRoll
  enemyScore <- enemyRolls
  return (yourScore > enemyScore))


main :: IO ()
main = putStrLn (pretty show youWin)

