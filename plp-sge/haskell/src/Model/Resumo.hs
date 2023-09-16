{-# LANGUAGE DeriveGeneric #-}

module Model.Resumo where

import Model.Comentario ( Comentario )
import GHC.Generics ( Generic )
import Data.Aeson


data Resumo = Resumo{
    titulo :: String,
    corpo :: String,
    comentario :: [Comentario]
} deriving (Generic)
