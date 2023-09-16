{-# LANGUAGE DeriveGeneric #-}

module Model.LinksUteis where

import GHC.Generics ( Generic )
import Data.Aeson

data LinksUteis = LinksUteis {
    id :: Int,
    titulo :: String,
    url :: String
} deriving (Generic)
