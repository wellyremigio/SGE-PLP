module Model.Disciplina where
    data Disciplina = Disciplina {
        id :: Int
        nome :: String
        professor :: String
        periodo :: String
    } deriving (Show, Read)