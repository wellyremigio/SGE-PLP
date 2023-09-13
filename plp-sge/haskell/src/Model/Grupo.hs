module Model.Grupo where
    data Grupo = Grupo{
        nome::  String,
        alunos:: [Aluno],
        codigo:: Int,
        disciplinas:: [Disciplina],
        adm:: Int
    } deriving (Show, Read)