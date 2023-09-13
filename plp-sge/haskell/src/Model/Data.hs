module Model.Data where
    import Model.Disciplina (Disciplina)
    data Data = Data{
        topico :: String,
        disciplina :: Disciplina,
        dataImportante :: String
    } deriving (Show, Read)