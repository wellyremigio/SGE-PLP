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

 -- Função para carregar os alunos do arquivo JSON
 getAlunos :: FilePath -> IO [Aluno]
 getAlunos path = do
   let filePath = path </> "aluno.json"
   conteudo <- B.readFile filePath
   let alunos = fromMaybe [] (decode conteudo)
   return alunos

verificarLogin :: Int -> String -> IO Bool
verificarLogin matricula senha = do
 alunos <- getAlunos
 let alunoEncontrado = find (\aluno -> matricula == matricula aluno && senha == senha aluno) alunos
 return (isJust alunoEncontrado)



