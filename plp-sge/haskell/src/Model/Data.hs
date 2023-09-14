{-# LANGUAGE DeriveGeneric #-}

module Model.Data where

import GHC.Generics ( Generic )

data Data = Data {
    idData :: Int,
    dataInicio :: String,
    dataFim :: String
} deriving (Generic)
