module DataBase.Gerenciador.AlunoGerenciador where
import Model.Aluno
import Model.Disciplina
import Model.Data
import Model.Resumo
import Model.LinksUteis
import Model.Comentario

import Data.Aeson ( eitherDecode', encode, FromJSON, ToJSON )
import qualified Data.ByteString.Lazy as B
import System.Directory

-- import Data.Aeson
-- import GHC.Generics
-- import qualified Data.ByteString.Lazy as B
-- import qualified Data.ByteString.Lazy.Char8 as BC
-- import Data.Maybe (fromMaybe)
-- import System.Directory (renameFile)  -- Adicione esta linha
-- import System.FilePath ((</>))
-- import Model.Aluno
-- import System.Directory (removeFile)

instance FromJSON Aluno
instance ToJSON Aluno
instance FromJSON Disciplina
instance ToJSON Disciplina
instance FromJSON Data
instance ToJSON Data
instance FromJSON Resumo
instance ToJSON Resumo
instance FromJSON LinksUteis
instance ToJSON LinksUteis
instance FromJSON Comentario
instance ToJSON Comentario

-- salvarAlunoJSON :: String -> Int -> String -> String -> IO ()
-- salvarAlunoJSON jsonFilePath matricula nome senha = do
--     let aluno = Aluno matricula nome senha
--     alunos <- getAlunosJSON jsonFilePath -- Obtém a lista de alunos do arquivo JSON
--     let alunoList = alunos ++ [aluno] -- Concatena o novo aluno à lista existente

--     B.writeFile "../Temp.json" $ encode alunoList
--     removeFile jsonFilePath
--     renameFile "../Temp.json" jsonFilePath


-- getAlunoByMatricula :: Int -> [Aluno] -> Aluno
-- getAlunoByMatricula _ [] = Aluno 0 "" ""
-- getAlunoByMatricula matriculaProcurada (x:xs)
--     | matricula x == matriculaProcurada = x
--     |  otherwise = getAlunoByMatricula matriculaProcurada xs    
    

-- getAlunosJSON :: FilePath -> IO [Aluno]
-- getAlunosJSON path = do
--     let filePath = path </> "aluno.json"
--     conteudo <- B.readFile filePath
--     let alunos = fromMaybe [] (decode conteudo)
--     return alunos

-- -- Salva um novo filme no arquivos de filmes --
-- saveFilmeJSON :: String -> String -> String -> String -> Float -> IO ()
-- saveFilmeJSON identificador nome descricao categoria preco = do
--   let p = Filme identificador nome descricao categoria 0 preco
--   filmeList <- getFilmeJSON "app/DataBase/Filme.json" 
--   let newFilmeList = filmeList ++ [p]

--   saveAlteracoesFilme newFilmeList

saveAlunoAlteracoes :: [Aluno] -> IO ()
saveAlunoAlteracoes alunoList = do
  B.writeFile "../Temp.json" $ encode alunoList
  removeFile "src/DataBase/Data/Aluno.json"
  renameFile "../Temp.json" "src/DataBase/Data/Aluno.json"

getAlunoJSON :: FilePath -> IO [Aluno]
getAlunoJSON path = do
  contents <- B.readFile path
  case eitherDecode' contents of
    Left err -> error err
    Right alunos -> return alunos


saveAluno :: String -> String -> String -> IO()
saveAluno matricula nome senha = do
    let disciplinas = [] :: [Disciplina]
    let a = Aluno matricula nome senha disciplinas

    alunoList <- getAlunoJSON "src/DataBase/Data/Aluno.json" 
    let newAlunoList = alunoList ++ [a]
    saveAlunoAlteracoes newAlunoList

getAlunoByMatricula :: String -> [Aluno] -> Aluno
getAlunoByMatricula _ [] = Aluno "" "" "" []
getAlunoByMatricula matriculaProcurada (x:xs)
    | matricula x == matriculaProcurada = x
    | otherwise = getAlunoByMatricula matriculaProcurada xs

getAlunoBySenha :: String -> [Aluno] -> Aluno
getAlunoBySenha _ [] = Aluno "" "" "" []
getAlunoBySenha senhaProcurada (x:xs)
    | senha x == senhaProcurada = x
    | otherwise = getAlunoBySenha senhaProcurada xs

getDisciplinasAluno :: String -> IO [Disciplina]
getDisciplinasAluno idAluno = do
    existingAluno <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let aluno = getAlunoByMatricula idAluno existingAluno
    
    return (getDisciplinas aluno)

removeAlunoByMatricula :: String -> IO [Aluno]
removeAlunoByMatricula matriculaAluno = do
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json" -- Substitua pelo caminho correto
    let alunosAtualizados = deleteAluno matriculaAluno alunos
    return alunosAtualizados
    where
        deleteAluno _ [] = []
        deleteAluno matriculaAluno (a : as)
            | matricula a == matriculaAluno = deleteAluno matriculaAluno as
            | otherwise = a : deleteAluno matriculaAluno as
    