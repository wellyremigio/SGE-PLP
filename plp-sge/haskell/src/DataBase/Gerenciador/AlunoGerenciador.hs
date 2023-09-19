module DataBase.Gerenciador.AlunoGerenciador where
import Model.Aluno
import Model.Disciplina
import Model.Data
import Model.Resumo
import Model.LinksUteis

import Data.Aeson ( eitherDecode', encode, FromJSON, ToJSON )
import qualified Data.ByteString.Lazy as B
import System.Directory

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
    