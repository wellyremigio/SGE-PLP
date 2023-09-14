module Model.Comentario where
    import Model.Aluno ( Aluno )
    import GHC.Generics
    
    data Comentario = Comentario{
        autor :: Aluno,
        titulo :: String,
        corpo :: String
    } deriving (Generic)