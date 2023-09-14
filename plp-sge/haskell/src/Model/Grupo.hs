{-# LANGUAGE DeriveGeneric #-}

module Model.Grupo where

import GHC.Generics
import Model.Aluno
import Model.Disciplina

data Grupo = Grupo {
    nome :: String,
    alunos :: [Aluno],
    codigo :: Int,
    disciplinas :: [Disciplina],
    adm :: Int
} deriving (Generic)



