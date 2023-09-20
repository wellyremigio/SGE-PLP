{-# LANGUAGE DeriveGeneric #-}

module Model.Comentario where

import GHC.Generics ( Generic )

data Comentario = Comentario {
    idComentario :: String,
    idAluno :: String,
    texto :: String
} deriving (Generic)
