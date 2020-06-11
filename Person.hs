{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( Person (..)
    ) where

import Control.Applicative (empty)
import Data.Aeson
import Data.Monoid

data Person = Person { _id :: String, name :: String, age :: Int } deriving (Show)

instance FromJSON Person where
    parseJSON (Object v) = Person <$> v .: "_id" <*> v .: "name" <*> v .: "age"
    parseJSON _          = empty 

instance ToJSON Person where
    toJSON (Person _id name age) = object [ "_id" .= _id, "name" .= name, "age" .= age ]
    toEncoding (Person _id name age) = pairs $ "_id" .= _id <> "name" .= name <> "age" .= age

