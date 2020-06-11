module Main where

import Network.Wai.Handler.Warp (run)

import App (app)

main :: IO ()
main = do
  putStrLn "http://localhost:8080"
  run 8080 app
