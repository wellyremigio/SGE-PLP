{-# LANGUAGE DeriveGeneric #-}

module Model.Aluno where
    import GHC.Generics 
    data Aluno = Aluno {
        matricula:: Int,
        nome:: String,
        senha:: String
    } deriving (Show, Read, Generic)