{-# LANGUAGE DeriveGeneric #-}
-- Modulo de Datas Importantes, com os atributos e a instância Show, que mostra os atributos necessários do aluno ao usuário.
module Model.Data where
import Model.Comentario
import GHC.Generics ( Generic )
import Data.Aeson
import Model.Comentario

data Data = Data {
    titulo:: String,
    iddata :: String,
    dataInicio :: String,
    dataFim :: String,
    comentarios :: [Comentario]
} deriving (Generic)

instance Show Data where
    show dataObj = "Título: " ++ titulo dataObj ++ "\n" ++
                   "ID da Data: " ++ iddata dataObj ++ "\n" ++
                   "Data de Início: " ++ dataInicio dataObj ++ "\n" ++
                   "Data de Fim: " ++ dataFim dataObj

