{-# LANGUAGE DeriveGeneric #-}
-- Módulo do comentário, com os atributos e o Show dele.s
module Model.Comentario where

import GHC.Generics ( Generic )

data Comentario = Comentario {
    idComentario :: String,
    idAluno :: String,
    texto :: String
} deriving (Generic)

instance Show Comentario where
    show comentario = "ID do Comentário: " ++ idComentario comentario ++ "\n" ++
                      "ID do Aluno: " ++ idAluno comentario ++ "\n" ++
                      "Texto do Comentário: " ++ texto comentario

