{-# LANGUAGE DeriveGeneric #-}

module Model.Disciplina where

import GHC.Generics ( Generic )
import Model.Materiais ( Material )

data Disciplina = Disciplina {
    id :: Int,
    nome :: String,
    professor :: String,
    periodo :: String,
    materiais :: [Material]
} deriving (Generic)

instance Eq Disciplina where
    (Disciplina id1 _ _ _ _) == (Disciplina id2 _ _ _ _) = id1 == id2
