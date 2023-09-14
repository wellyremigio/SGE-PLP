module GrupoGerenciador  where

import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC

import Model.Grupo

instance FromJSON Grupo
instance ToJSON Grupo

salvarGrupoJSON :: String -> String -> [Aluno] -> Int -> [Disciplina] -> Int -> IO()
salvarGrupoJSON jsonFilePath nome listaAlunos codigo listaDisciplinas adm = do
    let grupo = Grupo nome listaAlunos codigo listaDisciplinas 
    let grupoList = (getGrupoJSON jsonFilePath) ++ [grupo]

    B.writeFile "../Temp.json" $ encode grupoList
    removeFile jsonFilePath
    renameFile "../Temp.json" jsonFilePath


getGrupoByCodigo :: Int -> [Grupo] -> Grupo
getGrupoByCodigo _ [] = Grupo "" ""
getGrupoByCodigo codigo (x:xs)
    | codigoGrupo x == codigo = x
    | otherwise = getGrupoByCodigo codigo xs

getGrupoJSON :: FilePath -> IO [Grupo]
getGrupoJSON path = do
    let filePath = path </> "grupo.json"
    conteudo <- B.readFile filePath
    let grupos = fromMaybe [] (decode conteudo)
    return grupos
    