{-# LANGUAGE DeriveGeneric #-}
--Módulo link útil, com seus atributos e instância Show.
module Model.LinkUtil where
import Model.Comentario
import GHC.Generics ( Generic )
import Data.Aeson
import Model.Comentario

data LinkUtil= LinkUtil {
    idLink :: String,
    titulo :: String,
    url :: String,
    comentarios :: [Comentario]
} deriving (Generic)

instance Show LinkUtil where
    show link = "ID do Link: " ++ idLink link ++ "\n" ++
                "Título: " ++ titulo link ++ "\n" ++
                "URL: " ++ url link