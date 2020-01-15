{-# LANGUAGE OverloadedStrings #-}

-- OverloadedStrings is a GHC language extension that makes type 'String'
-- polymorphic (abstract types 'Text' and 'ByteString') by default.
--
-- Prelude Data.String> :t "blah"
-- "blah" :: [Char]
-- Prelude Data.String> :set -XOverloadedStrings
-- Prelude Data.String> :t "blah"
-- "blah" :: IsString p => p
-- Prelude Data.String> import Data.Text (Text)
-- Prelude Data.String Data.Text> import Data.ByteString (ByteString)
-- Prelude Data.String Data.Text Data.ByteString> t = "blah" :: Text
-- Prelude Data.String Data.Text Data.ByteString> bs = "blah" :: ByteString
-- Prelude Data.String Data.Text Data.ByteString> t == bs

-- <interactive>:12:6: error:
--     • Couldn't match expected type ‘Text’ with actual type ‘ByteString’
--     • In the second argument of ‘(==)’, namely ‘bs’
--       In the expression: t == bs
--       In an equation for ‘it’: it = t == bs
-- Prelude Data.String Data.Text Data.ByteString>

-- Module name must be "Main" required for anything exporting a "main"
-- executable.
module Main where

import Control.Monad (replicateM)
import Control.Monad.IO.Class (liftIO)
import qualified Data.ByteString.Char8 as BC
import Data.Text.Encoding (decodeUtf8, encodeUtf8)
import qualified Data.Text.Lazy as TL
import qualified Database.Redis as R
import Network.URI (URI, parseURI)
import qualified System.Random as SR
import Web.Scotty


alphaNum :: String
alphaNum = ['A'.'Z'] ++ ['0'..'9']

main :: IO ()
main = do
  putStrLn "hello world"
