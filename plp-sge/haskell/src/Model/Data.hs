{-# LANGUAGE DeriveGeneric #-}

module Model.Data where

import GHC.Generics ( Generic )
import Data.Aeson

data Data = Data {
    titulo:: String,
    iddata :: String,
    dataInicio :: String,
    dataFim :: String
} deriving (Generic)
