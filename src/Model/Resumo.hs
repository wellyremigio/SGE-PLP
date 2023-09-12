module Model.Resumo where
    data Resumo = Resumo{
        titulo :: String,
        corpo :: String,
        comentario :: [Comentario],
        disciplina :: Disciplina
    } deriving (Show, Read)