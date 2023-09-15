{-# LANGUAGE DeriveGeneric #-}

module Model.Aluno where
    import GHC.Generics 
    data Aluno = Aluno {
        matricula:: String,
        nome:: String,
        senha:: String
    } deriving (Generic)