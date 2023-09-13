{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE InstanceSigs #-}

module Model.Aluno where
    import GHC.Generics
    
    data Aluno = Aluno {
        matricula:: Int,
        nome:: String,
        senha:: String
    } deriving (Generic)