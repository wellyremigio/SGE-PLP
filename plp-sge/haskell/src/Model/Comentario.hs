{-# LANGUAGE DeriveGeneric #-}

module Model.Comentario where

import GHC.Generics ( Generic )

data Comentario = Comentario {
    idComentario :: Int,
    idAluno :: String,
    texto :: String
} deriving (Generic)
