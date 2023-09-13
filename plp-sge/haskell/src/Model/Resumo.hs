module Model.Resumo where
    import Model.Comentario ( Comentario )
    import Model.Disciplina ( Disciplina )
    data Resumo = Resumo{
        titulo :: String,
        corpo :: String,
        comentario :: [Comentario],
        disciplina :: Disciplina
        --teste
    } deriving (Show, Read)