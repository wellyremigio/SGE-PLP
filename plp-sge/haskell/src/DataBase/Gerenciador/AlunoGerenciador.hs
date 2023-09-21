module DataBase.Gerenciador.AlunoGerenciador where
import Model.Aluno
import Model.Disciplina
import Model.Data
import Model.Resumo
import Model.LinkUtil
import Model.Comentario

import Data.Aeson ( eitherDecode', encode, FromJSON, ToJSON )
import qualified Data.ByteString.Lazy as B
import System.Directory

instance FromJSON Aluno
instance ToJSON Aluno
instance FromJSON Disciplina
instance ToJSON Disciplina
instance FromJSON Data
instance ToJSON Data
instance FromJSON Resumo
instance ToJSON Resumo
instance FromJSON LinkUtil
instance ToJSON LinkUtil
instance FromJSON Comentario
instance ToJSON Comentario


--Salva alterações da lista de alunos no json.
saveAlunoAlteracoes :: [Aluno] -> IO ()
saveAlunoAlteracoes alunoList = do
  B.writeFile "../Temp.json" $ encode alunoList
  removeFile "src/DataBase/Data/Aluno.json"
  renameFile "../Temp.json" "src/DataBase/Data/Aluno.json"


--Pega alunos no json.
getAlunoJSON :: FilePath -> IO [Aluno]
getAlunoJSON path = do
  contents <- B.readFile path
  case eitherDecode' contents of
    Left err -> error err
    Right alunos -> return alunos

-- Salva o aluno no json.
saveAluno :: String -> String -> String -> IO()
saveAluno matricula nome senha = do
    let disciplinas = [] :: [Disciplina]
    let a = Aluno matricula nome senha disciplinas

    alunoList <- getAlunoJSON "src/DataBase/Data/Aluno.json" 
    let newAlunoList = alunoList ++ [a]
    saveAlunoAlteracoes newAlunoList

--Pega o aluno pela matríecula.
getAlunoByMatricula :: String -> [Aluno] -> Aluno
getAlunoByMatricula _ [] = Aluno "" "" "" []
getAlunoByMatricula matriculaProcurada (x:xs)
    | matricula x == matriculaProcurada = x
    | otherwise = getAlunoByMatricula matriculaProcurada xs


--Pega o aluno pela senha.
getAlunoBySenha :: String -> [Aluno] -> Aluno
getAlunoBySenha _ [] = Aluno "" "" "" []
getAlunoBySenha senhaProcurada (x:xs)
    | senha x == senhaProcurada = x
    | otherwise = getAlunoBySenha senhaProcurada xs


--Pega as disciplinas do aluno.
getDisciplinasAluno :: String -> IO [Disciplina]
getDisciplinasAluno idAluno = do
    existingAluno <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let aluno = getAlunoByMatricula idAluno existingAluno
    
    return (getDisciplinas aluno)

--Remove um aluno pela sua matrícula.
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