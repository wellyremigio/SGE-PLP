module DisciplinaGerenciador  where

import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC
import System.Directory
import Data.Maybe

import Model.Disciplina

instance FromJSON Disciplina
instance ToJSON Disciplina

-- Função para obter todas as disciplinas em formato JSON
getDisciplinasJSON :: FilePath -> IO [Disciplina]
getDisciplinasJSON path = do
    let filePath = path </> "disciplina.json"
    conteudo <- B.readFile filePath
    let disciplinas = fromMaybe [] (decode conteudo)
    return disciplinas

-- Função para obter uma disciplina por ID
getDisciplinaByID :: Int -> [Disciplina] -> Maybe Disciplina
getDisciplinaByID _ [] = Nothing
getDisciplinaByID disciplinaID (disciplina:outrasDisciplinas)
    | id disciplina == disciplinaID = Just disciplina
    | otherwise = getDisciplinaByID disciplinaID outrasDisciplinas

-- Função para salvar uma disciplina em formato JSON
salvarDisciplina :: String -> String -> String -> String -> IO ()
salvarDisciplina jsonFilePath nome professor periodo = do
    disciplinas <- getDisciplinasJSON jsonFilePath
    let novaDisciplinaID = 1 + maximum (0 : map id disciplinas)
    let novaDisciplina = Disciplina novaDisciplinaID nome professor periodo
    let disciplinaList = disciplinas ++ [novaDisciplina]

    B.writeFile "../Temp.json" $ encode disciplinaList
    removeFile jsonFilePath
    renameFile "../Temp.json" jsonFilePath

-- Função para remover uma disciplina por ID
removerDisciplina :: String -> Int -> IO ()
removerDisciplina jsonFilePath disciplinaID = do
    disciplinas <- getDisciplinasJSON jsonFilePath
    let novasDisciplinas = filter (\disciplina -> id disciplina /= disciplinaID) disciplinas

    B.writeFile "../Temp.json" $ encode novasDisciplinas
    removeFile jsonFilePath
    renameFile "../Temp.json" jsonFilePath