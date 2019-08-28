{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( Person (..)
    ) where

import Data.Aeson
import Data.Aeson.Types

data Person = Person { name :: String, age :: Int } deriving Show

instance FromJSON Person where
    parseJSON (Object v) = Person <$> v .: "name" <*> v .: "age"
    parseJSON v          = typeMismatch "Object" v
