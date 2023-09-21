{-# LANGUAGE DeriveGeneric #-}
--Módulo Resumo, com sseus atributos e instância Show.
module Model.Resumo where

import Model.Comentario ( Comentario )
import GHC.Generics ( Generic )
import Data.Aeson


data Resumo = Resumo{
    idResumo:: String,
    titulo :: String,
    corpo :: String,
    comentario :: [Comentario]
} deriving (Generic)

instance Show Resumo where
    show resumo = "ID do Resumo: " ++ idResumo resumo ++ "\n" ++
                  "Título: " ++ titulo resumo ++ "\n" ++
                  "Corpo: " ++ corpo resumo

