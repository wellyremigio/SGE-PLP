module DataBase.AlunoGerenciador (module DataBase.AlunoGerenciador) where

import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC

import Model.Aluno

instance FromJSON Aluno
instance ToJSON Aluno

cadastrarAlunoJSON :: String -> Int -> String -> String -> IO ()
cadastrarAlunoJSON jsonFilePath matricula nome senha = do
    let aluno = Aluno matricula nome senha
    let alunoList = (getAlunos jsonFilePath) ++ [aluno]

    B.writeFile "../Temp.json" $ encode alunoList
    removeFile jsonFilePath
    renameFile "../Temp.json" jsonFilePath

getAlunoByMatricula :: Int-> [Aluno] -> Aluno
getAlunoByMatricula _ [] = Aluno (-1) ""
getAlunoByMatricula matriculaProcurada (x:xs)
 | (matricula x) == matriculaProcurada = x
 | otherwise = getAlunoByMatricula matriculaProcurada xs

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




