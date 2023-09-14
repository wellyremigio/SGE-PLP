{-# LANGUAGE DeriveGeneric #-}

module Model.Comentario where

import GHC.Generics ( Generic )
import Model.Aluno ( Aluno )

data Comentario = Comentario {
    idComentario :: Int,
    aluno :: Aluno,
    texto :: String
} deriving (Generic)
