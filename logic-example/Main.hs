module Main where


import Control.Monad.Logic (
  Logic, observeAll, msum, guard)
import Control.Applicative (
  pure, liftA2)


data Expression =
  Four |
  Add Expression Expression |
  Subtract Expression Expression |
  Multiply Expression Expression |
  Divide Expression Expression


type Operator = Expression -> Expression -> Expression


solutions :: Rational -> Logic Expression
solutions targetNumber = do

  expression <- expressions 4

  guard (evaluate expression == Just targetNumber)

  return expression


expressions :: Int -> Logic Expression
expressions numberOfFours = case numberOfFours of

  1 -> do

    return Four

  _ -> do

    numberOfFoursLeft <- choose [1 .. numberOfFours - 1]

    let numberOfFoursRight = numberOfFours - numberOfFoursLeft

    expressionLeft <- expressions numberOfFoursLeft
    expressionRight <- expressions numberOfFoursRight

    operator <- choose [Add, Subtract, Multiply, Divide]

    return (operator expressionLeft expressionRight)


choose :: [a] -> Logic a
choose as = msum (map return as)


main :: IO ()
main = mapM_ putStrLn (map pretty (observeAll (solutions 3)))


evaluate :: Expression -> Maybe Rational
evaluate Four =
  pure 4
evaluate (Add left right) =
  liftA2 (+) (evaluate left) (evaluate right)
evaluate (Subtract left right) =
  liftA2 (-) (evaluate left) (evaluate right)
evaluate (Multiply left right) =
  liftA2 (*) (evaluate left) (evaluate right)
evaluate (Divide left right) = case evaluate right of
  Nothing -> Nothing
  Just 0 -> Nothing
  _ -> liftA2 (/) (evaluate left) (evaluate right)


pretty :: Expression -> String
pretty Four =
  "4"
pretty (Add left right) =
  "(" ++ pretty left ++ "+" ++ pretty right ++ ")"
pretty (Subtract left right) =
  "(" ++ pretty left ++ "-" ++ pretty right ++ ")"
pretty (Multiply left right) =
  "(" ++ pretty left ++ "*" ++ pretty right ++ ")"
pretty (Divide left right) =
  "(" ++ pretty left ++ "/" ++ pretty right ++ ")"


