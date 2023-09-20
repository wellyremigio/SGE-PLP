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

instance Show Data where
    show dataObj = "Título: " ++ titulo dataObj ++ "\n" ++
                   "ID da Data: " ++ iddata dataObj ++ "\n" ++
                   "Data de Início: " ++ dataInicio dataObj ++ "\n" ++
                   "Data de Fim: " ++ dataFim dataObj

