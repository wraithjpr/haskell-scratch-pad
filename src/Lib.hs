{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( Person (..)
    ) where

import Control.Applicative (empty)
import Data.Aeson
import Data.Monoid

data Person = Person { id :: String, name :: String, age :: Int } deriving (Show)

instance FromJSON Person where
    parseJSON (Object v) = Person <$> v .: "id" <*> v .: "name" <*> v .: "age"
    parseJSON _          = empty 

instance ToJSON Person where
    toJSON (Person id name age) = object [ "id" .= id, "name" .= name, "age" .= age ]
    toEncoding (Person id name age) = pairs $ "id" .= id <> "name" .= name <> "age" .= age
