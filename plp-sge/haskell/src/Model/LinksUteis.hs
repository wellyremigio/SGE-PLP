{-# LANGUAGE DeriveGeneric #-}

module Model.LinksUteis where

import GHC.Generics ( Generic )
import Data.Aeson

data LinksUteis = LinksUteis {
    idLink :: String,
    titulo :: String,
    url :: String
} deriving (Generic)
