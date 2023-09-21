module DataBase.Gerenciador.GrupoGerenciador where
import Model.Grupo
import Model.Aluno
import Model.Disciplina
import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as B
import System.Directory
import DataBase.Gerenciador.AlunoGerenciador (getAlunoByMatricula, getAlunoJSON)
import Data.List

instance FromJSON Grupo
instance ToJSON Grupo

-- Salva o grupo no json.
saveGrupo :: String ->  Int  -> String -> IO()
saveGrupo nomeGrupo  codigo  matAdm = do
    let grupo = Grupo nomeGrupo [] codigo [] matAdm
    grupoList <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let newGrupoList = grupoList ++ [grupo]
    saveAlteracoesGrupo newGrupoList

--Salva alterações feitas no grupo.
saveAlteracoesGrupo :: [Grupo] -> IO ()
saveAlteracoesGrupo grupoList = do
  B.writeFile "../Temp.json" $ encode grupoList
  removeFile "src/DataBase/Data/Grupo.json"
  renameFile "../Temp.json" "src/DataBase/Data/Grupo.json"


--Pega os grupos do json.
getGruposJSON :: FilePath -> IO [Grupo]
getGruposJSON path = do
  contents <- B.readFile path
  case eitherDecode' contents of
    Left err -> error err
    Right grupos -> return grupos


--Pega um grupo pelo codigo e retorna um IO Grupo.
getGruposByCodigoIO :: Int -> [Grupo] -> IO Grupo
getGruposByCodigoIO _ [] = do
  let alunoList = [] :: [Aluno]
  let disciplinaList = [] :: [Disciplina]
  return $ Grupo "" alunoList (-1) disciplinaList ""
getGruposByCodigoIO codigoGrupo (x:xs)
    | codigo x == codigoGrupo = return x
    | otherwise = getGruposByCodigoIO codigoGrupo xs

-- Pega um grup pelo codigo e retorna esse grupo.
getGruposByCodigo :: Int -> [Grupo] -> Grupo
getGruposByCodigo _ [] = Grupo "" [] (-1) [] ""
getGruposByCodigo codigoGrupo (x:xs)
    | codigo x == codigoGrupo = x
    | otherwise = getGruposByCodigo codigoGrupo xs


-- Pega os grupos de um aluno.
getGruposDoAluno :: String -> IO [Grupo]
getGruposDoAluno matriculaProcurada = do
    grupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    return $ filter (alunoPertenceAoGrupo matriculaProcurada) grupos


--Confere se o aluno pertence ao grupo.
alunoPertenceAoGrupo :: String -> Grupo -> Bool
alunoPertenceAoGrupo matriculaProcurada grupo =
    any (\aluno -> matricula aluno == matriculaProcurada) (alunos grupo)

-- Função que pega os alunos pertencentes a um grupo específico.
getAlunoGrupo :: Int -> IO [Aluno]
getAlunoGrupo codGrupo = do
  listaGrupo <- getGruposJSON "src/DataBase/Data/Grupo.json"
  let grupo = getGruposByCodigo codGrupo listaGrupo
  return (getAlunos grupo)
 
  
--Remove o grupo pelo código.
removeGrupoByCodigo :: Int -> [Grupo] -> [Grupo]
removeGrupoByCodigo codigoGrupo grupos = deleteGrupo grupos
  where
    deleteGrupo [] = []
    deleteGrupo (g : gs)
      | codigo g == codigoGrupo = deleteGrupo gs
      | otherwise = g : deleteGrupo gs

--Remove o grupo pelo código.
removeGrupoByCodigoIO :: Int -> IO [Grupo]
removeGrupoByCodigoIO codGrupo = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json" -- Substitua pelo caminho correto
    let gruposAtualizados = deleteGrupo codGrupo listaGrupos
    return gruposAtualizados
    where
        deleteGrupo _ [] = []
        deleteGrupo codGrupo (a : as)
            | codigo a == codGrupo = deleteGrupo codGrupo as
            | otherwise = a : deleteGrupo codGrupo as
    
--Pega os alunos dos grupos.
getAlunos :: Grupo -> [Aluno]
getAlunos = alunos

--Adiciona alunos no grupo.
adicionarAlunoLista :: Aluno -> Int -> IO ()
adicionarAlunoLista aluno codGrupo = do
  existingGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
  g <- getGruposByCodigoIO codGrupo existingGrupos
  let newListAluno = Model.Grupo.alunos g ++ [aluno]
  let newGrupo = Grupo  (Model.Grupo.nome g) newListAluno (Model.Grupo.codigo g) (Model.Grupo.disciplinas g) (Model.Grupo.adm g)
  let newAlunoList = removeGrupoByCodigo codGrupo existingGrupos ++ [newGrupo]
  saveAlteracoesAluno newAlunoList

--Salva a mudança na lista de alunos no json.
saveAlteracoesAluno :: [Grupo] -> IO ()
saveAlteracoesAluno grupoList = do
  B.writeFile "../Temp.json" $ encode grupoList
  removeFile "src/DataBase/Data/Grupo.json"
  renameFile "../Temp.json" "src/DataBase/Data/Grupo.json"

-- Função para obter a lista de disciplinas de um grupo
disciplinasDoGrupo :: Int -> IO [Disciplina]
disciplinasDoGrupo codigoGrupo = do
    grupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let grupo = getGruposByCodigo codigoGrupo grupos
    return (getDisciplinasGrupo grupo)
    