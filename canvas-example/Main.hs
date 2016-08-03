{-# language OverloadedStrings #-}
module Main where


import Graphics.Blank (
  Canvas, blankCanvas, send,
  fillStyle, strokeStyle,
  shadowColor, shadowOffsetX, shadowOffsetY, shadowBlur,
  lineWidth, lineCap,
  beginPath, moveTo, quadraticCurveTo, stroke)


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


main :: IO ()
main = blankCanvas 3000 (\context -> send context canvas)


