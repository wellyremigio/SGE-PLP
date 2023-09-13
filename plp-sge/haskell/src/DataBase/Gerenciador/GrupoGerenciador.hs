module DataBase.GrupoGerenciador (module DataBase.GrupoGerenciador) where

import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC

import Model.Grupo

instance FromJSON Grupo
instance ToJSON Grupo


