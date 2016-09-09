{-| This example is taken from
    <http://corehtml5canvas.com/code-live/ch02/example-2.22/example.html>

    The server translates the program to javascript calls to the HTML5 canvas
    API and transmits them to the client.

    You can abstract over drawing instructions within Haskell.
-}
{-# language OverloadedStrings #-}
module Main where


import Graphics.Blank (
  Canvas, blankCanvas, send,
  fillStyle, strokeStyle,
  shadowColor, shadowOffsetX, shadowOffsetY, shadowBlur,
  lineWidth, lineCap,
  beginPath, moveTo, quadraticCurveTo, stroke)


-- | Translation of <http://corehtml5canvas.com/code-live/ch02/example-2.22/example.html>.
canvas :: Canvas ()
canvas = do

  fillStyle("cornflowerblue")
  strokeStyle("red")

  shadowColor("rgba(50, 50, 50, 1.0)")
  shadowOffsetX(2)
  shadowOffsetY(2)
  shadowBlur(4)

  lineWidth(20)
  lineCap("round")

  beginPath()
  moveTo(120.5, 130);
  quadraticCurveTo(150.8, 130, 160.6, 150.5)
  quadraticCurveTo(190, 250.0, 210.5, 160.5)
  quadraticCurveTo(240, 100.5, 290, 70.5)
  stroke()


-- | Start a server on port 3000 that will send clients the instructions to draw
-- the example.
main :: IO ()
main = blankCanvas 3000 (\context -> send context canvas)

