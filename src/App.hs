{-# LANGUAGE OverloadedStrings #-}

module App ( app ) where

import           Lib                            ( Person (..) )

import           Data.Aeson                     ( encode
                                                , decode
                                                )
import qualified Data.ByteString                as B
import qualified Data.ByteString.Lazy           as L
import           Data.Maybe                     ( fromMaybe )
import           Network.HTTP.Types             ( Method
                                                , parseMethod
                                                , ok200
                                                , badRequest400
                                                , notFound404
                                                , statusMessage
                                                , StdMethod (..)
                                                )
import           Network.HTTP.Types.Header
import           Network.Wai                    ( Application
                                                , Request
                                                , Response
                                                , rawPathInfo
                                                , requestHeaders
                                                , requestMethod
                                                , responseLBS
                                                , strictRequestBody
                                                )

app :: Application
app request respond = do
    print request
    let method = parseMethod . requestMethod $ request
    let route = rawPathInfo request
    response <- case method of
        Right GET -> case route of
            "/"            -> getRoot
            "/healthcheck" -> getHealthcheck
            "/person"      -> getPerson
            _              -> notFound
        Right POST -> case route of
            "/echo"        -> echo request
            "/person"      -> postPerson request
            _              -> notFound
        _     -> notFound
    respond response

echo:: Request -> IO Response
echo request = do
    let contentType = fromMaybe "application/json" $ getHeaderValue hContentType request
    body <- strictRequestBody request
    return $ responseLBS ok200 [(hContentType, contentType)] body

getHealthcheck :: IO Response
getHealthcheck = return $ responseLBS ok200 [] L.empty

getPerson :: IO Response
getPerson = return $ responseLBS
    ok200
    [(hContentType, "application/json")]
    (encode $ Person "872058d1-0c14-4ca4-90de-d31d46ebcd18" "Ben Stokes" 28)

postPerson :: Request -> IO Response
postPerson request = do
    personIn <- getRequestBodyAsPerson request
    let person = Just Person <*> Just "cb9395a3-0d6f-4d27-a066-4a820500552f" <*> (name <$> personIn) <*> (age <$> personIn) :: Maybe Person
    return $ responseLBS
        (maybe badRequest400 (const ok200) person)
        [(hContentType, "application/json")]
        (maybe "{\"error\": \"Nothing from json decode\"}" encode person)

getRoot :: IO Response
getRoot = return $ responseLBS
    ok200 [(hContentType, "text/plain")] "hello, world\n"

notFound :: IO Response
notFound = return $ responseLBS
    notFound404 [(hContentType, "text/plain")] $ L.fromStrict $ statusMessage notFound404

getHeaderValue :: HeaderName -> Request -> Maybe B.ByteString
getHeaderValue name request = lookup name $ requestHeaders request

getRequestBodyAsPerson :: Request -> IO (Maybe Person)
getRequestBodyAsPerson request = do
    body <- strictRequestBody request
    return $ decode body
