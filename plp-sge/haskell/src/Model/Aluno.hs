{-# LANGUAGE DeriveGeneric #-}

module Model.Aluno where 
    data Aluno = Aluno {
        matricula:: Int,
        nome:: String,
        senha:: String
    } deriving (Show, Read)