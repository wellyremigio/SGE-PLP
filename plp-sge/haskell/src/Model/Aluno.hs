{-# LANGUAGE DeriveGeneric #-}

module Model.Aluno where
    
    import GHC.Generics
    import Model.Disciplina ( Disciplina )
    
    data Aluno = Aluno {
        matricula:: String,
        nome:: String,
        senha:: String,
        disciplinas :: [Disciplina]
    } deriving (Generic, Eq)

    getDisciplinas :: Aluno -> [Disciplina]
    getDisciplinas aluno = disciplinas aluno
