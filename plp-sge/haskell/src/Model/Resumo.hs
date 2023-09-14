{-# LANGUAGE DeriveGeneric #-}

module Model.Resumo where

import Model.Comentario ( Comentario )
import Model.Disciplina ( Disciplina )
import GHC.Generics ( Generic )

data Resumo = Resumo{
    titulo :: String,
    corpo :: String,
    comentario :: [Comentario],
    disciplina :: Disciplina
} deriving (Generic)
