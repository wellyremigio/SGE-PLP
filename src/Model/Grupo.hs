module Model.Grupo where
    data Grupo = Grupo{
        nome::  String,
        alunos:: [String],
        codigo:: Int,
        disciplinas:: [ String],
        adm:: Int
    } deriving (Show, Read)