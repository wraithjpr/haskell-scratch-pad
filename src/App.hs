{-# LANGUAGE OverloadedStrings #-}

module App
    ( app
    ) where

import Network.HTTP.Types
import Network.Wai

app :: Application
app _ respond = do
    putStrLn "I've done some IO here"
    respond $ responseLBS status200 [("Content-Type", "text/plain")] "hello, world\nHaskell is here\n"
