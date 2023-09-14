module Model.Disciplina where
    import GHC.Generics

    data Disciplina = Disciplina {
        id :: Int,
        nome :: String,
        professor :: String,
        periodo :: String
    } deriving (Generic)