{-# LANGUAGE DeriveGeneric #-}
--Model de disciplina, com seus atributos e instância show, para mostrar ao usuário o que é necessário.
-- Tem um método que confere se duas disciplpinas são iguais.
module Model.Disciplina where

import GHC.Generics ( Generic )
import Model.Data
import Model.LinkUtil
import Model.Resumo


data Disciplina = Disciplina {
    id :: Int,
    nome :: String,
    professor :: String,
    periodo :: String,
    resumos :: [Resumo],
    datas :: [Data],
    links :: [LinkUtil]
} deriving (Generic)

instance Eq Disciplina where
    (Disciplina id1 _ _ _ _ _ _ ) == (Disciplina id2 _ _ _ _ _ _ ) = id1 == id2

instance Show Disciplina where
    show disciplina = "ID: " ++ show (Model.Disciplina.id disciplina) ++ "\n" ++
                      "Nome: " ++ nome disciplina ++ "\n" ++
                      "Professor: " ++ professor disciplina ++ "\n" ++
                      "Período: " ++ periodo disciplina
    