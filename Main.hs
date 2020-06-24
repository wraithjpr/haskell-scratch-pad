module Main where

import System.Environment
import System.Exit

printHelp :: IO ()
printHelp = do
  progName <- getProgName
  putStrLn $ "Usage: " ++ progName ++ " [-h | --help | -v | --version] <greeting>"

main :: IO ()
main = do
  progName <- getProgName
  args <- getArgs
  putStrLn $ unwords $ progName : args

  if "-h" `elem` args || "--help" `elem` args
      then printHelp >> exitSuccess
      else return ()

