{-# LANGUAGE DeriveGeneric #-}

module Model.Data where

import GHC.Generics

data Data = Data {
    idData :: Int,
    dataInicio :: String,
    dataFim :: String
} deriving (Generic)
