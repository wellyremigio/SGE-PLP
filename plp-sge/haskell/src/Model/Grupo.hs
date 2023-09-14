{-# LANGUAGE DeriveGeneric #-}

module Model.Grupo where

import GHC.Generics ( Generic )
import Model.Aluno ( Aluno )
import Model.Disciplina ( Disciplina )

data Grupo = Grupo {
    nome :: String,
    alunos :: [Aluno],
    codigo :: Int,
    disciplinas :: [Disciplina],
    adm :: Int
} deriving (Generic)



