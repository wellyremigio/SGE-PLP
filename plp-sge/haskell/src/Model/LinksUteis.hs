module Model.LinksUteis where
    import Model.Disciplina ( Disciplina )
    data LinksUteis = LinksUteis{
        topico :: String,
        link :: String,
        disciplina :: Disciplina
    } deriving (Show, Read)