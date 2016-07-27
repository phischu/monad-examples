module Main where


import Numeric.Probability.Distribution (
  T, uniform, norm, pretty)


type Distribution a = T Rational a


sixSided :: Distribution Int
sixSided = uniform [1..6]


twentySided :: Distribution Int
twentySided = uniform [1..20]


youRoll :: Distribution Int
youRoll = norm (do
  firstRoll <- sixSided
  secondRoll <- sixSided
  return (firstRoll + secondRoll + 5))


enemyRolls :: Distribution Int
enemyRolls = norm (do
  firstRoll <- twentySided
  secondRoll <- twentySided
  return (max firstRoll secondRoll))


youWin :: Distribution Bool
youWin = norm (do
  yourScore <- youRoll
  enemyScore <- enemyRolls
  return (yourScore > enemyScore))


main :: IO ()
main = putStrLn (pretty show youWin)

