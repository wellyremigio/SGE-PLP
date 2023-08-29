module Model.Disciplina where
    data Disciplina = Disciplina {
        id :: Int
        nome :: String
        professor :: String
        período :: String
    } deriving (Show, Read)