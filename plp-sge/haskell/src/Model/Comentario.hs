{-# LANGUAGE DeriveGeneric #-}

module Model.Comentario where

import GHC.Generics
import Model.Aluno

data Comentario = Comentario {
    idComentario :: Int,
    aluno :: Aluno,
    texto :: String
} deriving (Generic)
