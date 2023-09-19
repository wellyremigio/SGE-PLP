{-# LANGUAGE DeriveGeneric #-}

module Model.Disciplina where

import GHC.Generics ( Generic )
import Model.Data
import Model.LinksUteis
import Model.Resumo


data Disciplina = Disciplina {
    id :: Int,
    nome :: String,
    professor :: String,
    periodo :: String,
    resumos :: [Resumo],
    datas :: [Data],
    links :: [LinksUteis]
} deriving (Generic)

instance Eq Disciplina where
    (Disciplina id1 _ _ _ _ _ _ ) == (Disciplina id2 _ _ _ _ _ _ ) = id1 == id2

instance Show Disciplina where
    show disciplina = "ID: " ++ show (Model.Disciplina.id disciplina) ++ "\n" ++
                      "Nome: " ++ nome disciplina ++ "\n" ++
                      "Professor: " ++ professor disciplina ++ "\n" ++
                      "Período: " ++ periodo disciplina
    