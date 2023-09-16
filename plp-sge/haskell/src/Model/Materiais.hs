{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Model.Materiais where

import Data.Aeson
import Data.Text (Text)
import GHC.Generics (Generic)
import Model.Resumo (Resumo(..))
import Model.LinksUteis (LinksUteis(..))
import Model.Data (Data(..))
import Model.Comentario (Comentario(..))
import Data.Aeson.Types (Parser)

data Material = ResumoMaterial Resumo
              | LinksUteisMaterial LinksUteis
              | DataMaterial Data
  deriving (Generic)

-- Defina instâncias ToJSON e FromJSON para o tipo Material
instance ToJSON Material where
    toJSON (ResumoMaterial resumo) = object ["tipo" .= ("resumo" :: Text), "conteudo" .= resumo]
    toJSON (LinksUteisMaterial linksUteis) = object ["tipo" .= ("linksUteis" :: Text), "conteudo" .= linksUteis]
    toJSON (DataMaterial dataAula) = object ["tipo" .= ("dataAula" :: Text), "conteudo" .= dataAula]

instance FromJSON Material where
    parseJSON (Object v) = do
        tipo <- v .: "tipo" :: Parser Text
        case tipo of
            "resumo" -> ResumoMaterial <$> v .: "conteudo"
            "linksUteis" -> LinksUteisMaterial <$> v .: "conteudo"
            "dataAula" -> DataMaterial <$> v .: "conteudo"
            _ -> fail "Tipo de material desconhecido"

instance ToJSON Resumo where
    toJSON (Resumo titulo corpo comentario) = object ["titulo" .= titulo, "corpo" .= corpo, "comentario" .= comentario]

instance FromJSON Resumo where
    parseJSON = withObject "Resumo" $ \v -> Resumo
        <$> v .: "titulo"
        <*> v .: "corpo"
        <*> v .: "comentario"

instance ToJSON LinksUteis where
    toJSON (LinksUteis id titulo url) = object ["id" .= id, "titulo" .= titulo, "url" .= url]

instance FromJSON LinksUteis where
    parseJSON = withObject "LinksUteis" $ \v -> LinksUteis
        <$> v .: "id"
        <*> v .: "titulo"
        <*> v .: "url"

instance ToJSON Data where
    toJSON (Data idData dataInicio dataFim) = object ["idData" .= idData, "dataInicio" .= dataInicio, "dataFim" .= dataFim]

instance FromJSON Data where
    parseJSON = withObject "Data" $ \v -> Data
        <$> v .: "idData"
        <*> v .: "dataInicio"
        <*> v .: "dataFim"

instance ToJSON Comentario where
     toJSON (Comentario idComentario idAluno texto) = object ["idComentario" .= idComentario, "idAluno" .= idAluno, "texto" .= texto]
        
instance FromJSON Comentario where
    parseJSON = withObject "Comentario" $ \v -> Comentario
        <$> v .: "idComentario"
         <*> v .: "idAluno"
         <*> v .: "texto"
        