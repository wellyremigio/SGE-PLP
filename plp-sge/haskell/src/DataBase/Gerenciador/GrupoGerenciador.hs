module DataBase.Gerenciador.GrupoGerenciador  where
import Model.Grupo
import Model.Aluno
import Model.Disciplina
import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as B
import System.Directory
--import qualified Data.ByteString.Lazy.Char8 as BC
import Data.List

instance FromJSON Grupo
instance ToJSON Grupo
instance FromJSON Aluno
instance ToJSON Aluno
instance FromJSON Disciplina
instance ToJSON Disciplina

--salvarGrupoJSON :: String -> String -> [Aluno] -> Int -> [Disciplina] -> Int -> IO()
--salvarGrupoJSON jsonFilePath nome listaAlunos codigo listaDisciplinas adm = do
 --   let grupo = Grupo nome listaAlunos codigo listaDisciplinas 
  --  let grupoList = (getGrupoJSON jsonFilePath) ++ [grupo]

    --B.writeFile "../Temp.json" $ encode grupoList
    --removeFile jsonFilePath
    --renameFile "../Temp.json" jsonFilePath


saveGrupo :: String ->  Int  -> String -> IO()
saveGrupo nomeGrupo  codigo  matAdm = do
    let grupo = Grupo nomeGrupo [] codigo [] matAdm
    grupoList <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let newGrupoList = grupoList ++ [grupo]
    saveAlteracoesGrupo newGrupoList

saveAlteracoesGrupo :: [Grupo] -> IO ()
saveAlteracoesGrupo grupoList = do
  B.writeFile "../Temp.json" $ encode grupoList
  removeFile "src/DataBase/Data/Grupo.json"
  renameFile "../Temp.json" "src/DataBase/Data/Grupo.json"

getGruposJSON :: FilePath -> IO [Grupo]
getGruposJSON path = do
  contents <- B.readFile path
  case eitherDecode' contents of
    Left err -> error err
    Right grupos -> return grupos
    
getGruposByCodigoIO :: Int -> [Grupo] -> IO Grupo
getGruposByCodigoIO _ [] = do
  let alunoList = [] :: [Aluno]
  let disciplinaList = [] :: [Disciplina]
  return $ Grupo "" alunoList (-1) disciplinaList ""
getGruposByCodigoIO codigoGrupo (x:xs)
    | codigo x == codigoGrupo = return x
    | otherwise = getGruposByCodigoIO codigoGrupo xs

getGruposByCodigo :: Int -> [Grupo] -> Grupo
getGruposByCodigo _ [] = Grupo "" [] (-1) [] ""
getGruposByCodigo codigoGrupo (x:xs)
    | codigo x == codigoGrupo = x
    | otherwise = getGruposByCodigo codigoGrupo xs

listaDeListasDeDisciplinas :: IO [[Disciplina]]
listaDeListasDeDisciplinas = do
    grupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    return (map disciplinasDoGrupo grupos)
    
     
-- Função para obter a lista de disciplinas de um grupo
disciplinasDoGrupo :: Grupo -> [Disciplina]
disciplinasDoGrupo grupo = getDisciplinasGrupo grupo

removeGrupoByCodigo :: Int -> [Grupo] -> [Grupo]
removeGrupoByCodigo codigoGrupo grupos = deleteGrupo grupos
  where
    deleteGrupo [] = []
    deleteGrupo (g : gs)
      | codigo g == codigoGrupo = deleteGrupo gs
      | otherwise = g : deleteGrupo gs


getAlunos :: Grupo -> [Aluno]
getAlunos = alunos


adicionarAlunoLista :: Aluno -> Int -> IO ()
adicionarAlunoLista aluno codGrupo = do
  existingGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
  g <- getGruposByCodigoIO codGrupo existingGrupos
  let newListAluno = Model.Grupo.alunos g ++ [aluno]
  let newGrupo = Grupo  (Model.Grupo.nome g) newListAluno (Model.Grupo.codigo g) (Model.Grupo.disciplinas g) (Model.Grupo.adm g)
  let newAlunoList = removeGrupoByCodigo codGrupo existingGrupos ++ [newGrupo]
  saveAlteracoesAluno newAlunoList




  --let newAlunosList = aluno : getAlunos grupo
  --let grupoAtualizado = grupo { alunos = newAlunosList }
  --saveAlteracoesAluno grupoAtualizado 267
  --return grupoAtualizado



saveAlteracoesAluno :: [Grupo] -> IO ()
saveAlteracoesAluno grupoList = do
  B.writeFile "../Temp.json" $ encode grupoList
  removeFile "src/DataBase/Data/Grupo.json"
  renameFile "../Temp.json" "src/DataBase/Data/Grupo.json"

--saveAlteracoesAluno :: Grupo -> IO ()
--saveAlteracoesAluno grupo = do
  -- Ler o conteúdo atual do arquivo JSON
--  existingContent <- B.readFile "src/DataBase/Data/Grupo.json"

  -- Decodificar o conteúdo JSON existente em um valor Haskell
--  case decode existingContent of
--    Just existingGrupo -> do
      -- Mesclar os dados existentes com os novos dados do grupo
--      let mergedGrupo = existingGrupo { alunos = getAlunos grupo }

      -- Codificar o valor Haskell de volta para JSON
  --    let newContent = encode mergedGrupo

      -- Escrever os dados de volta no arquivo JSON
    --  B.writeFile "src/DataBase/Data/Grupo.json" newContent

    --Nothing -> putStrLn "Erro: Não foi possível decodificar o arquivo JSON existente."