{-| We solve the four fours problem.
    <https://en.wikipedia.org/wiki/Four_fours>

    We generate expressions out of 4s and the binary operations add, subtract,
    multiply and divide.

    You can extend this to also allow concatenation i.e. 44.
-}
module Main where


import Control.Monad.Logic (
  Logic, observeAll, msum, guard, when)
import Control.Applicative (
  pure, liftA2)


-- | Arithmetic expressions with the number of and binary operators.
data Expression =
  Four |
  Binary Operator Expression Expression
    deriving (Show, Eq, Ord)


-- | Operators add, subtract, multiply and divide.
data Operator =
  Add |
  Subtract |
  Multiply |
  Divide
    deriving (Show, Eq, Ord)


-- | Given a target number generates all expressions that evaluate to that number
-- and contain exactly four fours.
solutions :: Rational -> Logic Expression
solutions targetNumber = do

  expression <- expressions 4

  guard (evaluate expression == targetNumber)

  return expression


-- | Given a number, generate all expressions with exactly that number of fours.
-- There is only on expression containing exactly one four.
-- If the number of fours to use is larger than one we generate an expression with
-- a binary operator. We choose how many fours go into the left-hand-side and how
-- many into the right-hand-side.
-- When we generate an expression with a division we make sure that the
-- right-hand-side does not evaluate to zero.
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

    when (operator == Divide) (
      guard (not (evaluate expressionRight == 0)))

    return (Binary operator expressionLeft expressionRight)


-- | Choose from a list of values.
choose :: [a] -> Logic a
choose as = msum (map return as)


-- | Print all solutions for the target number three.
main :: IO ()
main = mapM_ putStrLn (map pretty (observeAll (solutions 3)))


-- | Evaluate an expression.
evaluate :: Expression -> Rational
evaluate Four = 4
evaluate (Binary operator left right) =
  operate operator (evaluate left) (evaluate right)


-- | Operato on two numbers according to the given operator.
operate :: Operator -> Rational -> Rational -> Rational
operate Add = (+)
operate Subtract = (-)
operate Multiply = (*)
operate Divide = (/)


-- | Make a nice string from an expression.
pretty :: Expression -> String
pretty Four =
  "4"
pretty (Binary operator left right) =
  "(" ++ pretty left ++ operatorSymbol operator ++ pretty right ++ ")"


-- | The infix symbol for an operator.
operatorSymbol :: Operator -> String
operatorSymbol Add = "+"
operatorSymbol Subtract = "-"
operatorSymbol Multiply = "*"
operatorSymbol Divide = "/"

