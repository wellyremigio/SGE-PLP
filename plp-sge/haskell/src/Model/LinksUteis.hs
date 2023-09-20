{-# LANGUAGE DeriveGeneric #-}

module Model.LinksUteis where

import GHC.Generics ( Generic )
import Data.Aeson

data LinksUteis = LinksUteis {
    idLink :: String,
    titulo :: String,
    url :: String
} deriving (Generic)

instance Show LinksUteis where
    show link = "ID do Link: " ++ idLink link ++ "\n" ++
                "Título: " ++ titulo link ++ "\n" ++
                "URL: " ++ url link

