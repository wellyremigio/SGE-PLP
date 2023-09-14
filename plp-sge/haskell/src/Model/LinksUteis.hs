module Model.LinksUteis where
    import Model.Disciplina (Disciplina)
    import GHC.Generics

    data LinksUteis = LinksUteis{
        topico :: String,
        link :: String,
        disciplina :: Disciplina
    } deriving (Generic)