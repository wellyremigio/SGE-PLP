module Model.Comentario where
    import Model.Aluno ( Aluno )
    data Comentario = Comentario{
        autor :: Aluno,
        titulo :: String,
        corpo :: String
    } deriving (Show, Read)