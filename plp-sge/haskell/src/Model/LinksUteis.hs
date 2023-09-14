{-# LANGUAGE DeriveGeneric #-}

module Model.LinksUteis where

import GHC.Generics ( Generic )

data LinksUteis = LinksUteis {
    id :: Int,
    titulo :: String,
    url :: String
} deriving (Generic)
