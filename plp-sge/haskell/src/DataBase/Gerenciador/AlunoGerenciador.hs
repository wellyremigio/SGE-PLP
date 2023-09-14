module DataBase.Gerenciador.AlunoGerenciador where

import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC

import Model.Aluno

instance FromJSON Aluno
instance ToJSON Aluno

salvarAlunoJSON :: String -> Int -> String -> String -> IO ()
salvarAlunoJSON jsonFilePath matricula nome senha = do
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

getAlunosJSON :: FilePath -> IO [Aluno]
getAlunosJSON path = do
    let filePath = path </> "aluno.json"
    conteudo <- B.readFile filePath
    let alunos = fromMaybe [] (decode conteudo)
    return alunos