{-# LANGUAGE DeriveGeneric #-}

module Model.Grupo where

import GHC.Generics (Generic)
import Model.Aluno (Aluno)
import Model.Disciplina (Disciplina)

data Grupo = Grupo {
    nome :: String,
    alunos :: [Aluno],
    codigo :: Int,
    disciplinas :: [Disciplina],
    adm :: String
} deriving (Generic)

instance Show Grupo where
    show grupo = "Nome do Grupo: " ++ nome grupo ++ "\n" ++
                 "Código: " ++ show (codigo grupo) ++ "\n" ++
                 "Número de Alunos: " ++ show (length (alunos grupo)) ++ "\n" ++
                 "Número de Disciplinas: " ++ show (length (disciplinas grupo)) ++ "\n" ++
                 "Matrícula do Administrador: " ++ adm grupo

getDisciplinasGrupo :: Grupo -> [Disciplina]
getDisciplinasGrupo grupo = disciplinas grupo
