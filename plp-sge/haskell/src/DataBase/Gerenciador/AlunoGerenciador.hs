module DataBase.AlunoGerenciador (module DataBase.AlunoGerenciador) where

import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC

import Model.Aluno

instance FromJSON Aluno
instance ToJSON Aluno


getAlunoByMatricula :: Int-> [Aluno] -> Aluno
getAlunoByMatricula _ [] = Aluno (-1) ""
getAlunoByMatricula matriculaProcurada (x:xs)
 | (matricula x) == matriculaProcurada = x
 | otherwise = getAlunoByMatricula matriculaProcurada xs





