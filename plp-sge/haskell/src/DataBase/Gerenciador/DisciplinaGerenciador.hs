module DataBase.Gerenciador.DisciplinaGerenciador where
import Model.Grupo
import Model.Aluno
import Model.Disciplina
import Model.LinksUteis
import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as B
import System.Directory
import DataBase.Gerenciador.AlunoGerenciador as A
import DataBase.Gerenciador.GrupoGerenciador as G
--import qualified Data.ByteString.Lazy.Char8 as BC
import Data.List
import Model.Resultado
-- import Data.Aeson
-- import GHC.Generics
-- import qualified Data.ByteString.Lazy as B
-- import qualified Data.ByteString.Lazy.Char8 as BC
-- import System.Directory
-- import Data.Maybe

-- import Model.Disciplina

-- instance FromJSON Disciplina
-- instance ToJSON Disciplina

-- -- Função para obter todas as disciplinas em formato JSON
-- getDisciplinasJSON :: FilePath -> IO [Disciplina]
-- getDisciplinasJSON path = do
--     let filePath = path </> "disciplina.json"
--     conteudo <- B.readFile filePath
--     let disciplinas = fromMaybe [] (decode conteudo)
--     return disciplinas

-- -- Função para obter uma disciplina por ID
-- getDisciplinaByID :: Int -> [Disciplina] -> Maybe Disciplina
-- getDisciplinaByID _ [] = Nothing
-- getDisciplinaByID disciplinaID (disciplina:outrasDisciplinas)
--      | id disciplina == disciplinaID = Just disciplina
--      | otherwise = getDisciplinaByID disciplinaID outrasDisciplinas

addResumoByID ::String -> Int -> String -> String -> String 
addResumoByID matricula id nome conteudo = "CHIP"

--Função que pega as disciplinas de determinado grupo.
getDisciplinasDoGrupo :: Int -> IO [Disciplina]
getDisciplinasDoGrupo grupoID = do
    grupos <- getGruposJSON "DataBase/Data/Grupo.json" -- Substitua pelo caminho real
    let grupo = find (\g -> codigo g == grupoID) grupos
    case grupo of
        Just g -> return (Model.Grupo.disciplinas g)
        Nothing -> return []

getDisciplinaByCodigo :: Int -> [Disciplina] -> Maybe Disciplina
getDisciplinaByCodigo _ [] = Nothing
getDisciplinaByCodigo codigoDisciplina (d:ds)
    | Model.Disciplina.id d == codigoDisciplina = Just d
    | otherwise = getDisciplinaByCodigo codigoDisciplina ds

getDisciplinaByCodigoCadastroMaterial :: Int -> [Disciplina] -> Resultado Disciplina
getDisciplinaByCodigoCadastroMaterial codigo disciplinas =
    case find (\disciplina -> Model.Disciplina.id disciplina == codigo) disciplinas of
        Just disciplinaEncontrada -> Encontrado disciplinaEncontrada
        Nothing -> NaoEncontrado


getLinksUteisDasDisciplinas :: [Disciplina] -> [LinksUteis]
getLinksUteisDasDisciplinas disciplinas =
    concatMap links disciplinas

-- 
-- Pegar a disciplina com o ID passado
-- Criar o resumo com os dados passados
-- Criar uma nova lista com os dados antigos acrescidos do novo resumo
-- salvar a nova lista na disciplina

-- -- Função para salvar uma disciplina em formato JSON
-- salvarDisciplina :: String -> String -> String -> String -> IO ()
-- salvarDisciplina jsonFilePath nome professor periodo = do
--     disciplinas <- getDisciplinasJSON jsonFilePath
--     let novaDisciplinaID = 1 + maximum (0 : map id disciplinas)
--     let novaDisciplina = Disciplina novaDisciplinaID nome professor periodo
--     let disciplinaList = disciplinas ++ [novaDisciplina]

--     B.writeFile "../Temp.json" $ encode disciplinaList
--     removeFile jsonFilePath
--     renameFile "../Temp.json" jsonFilePath

-- -- Função para remover uma disciplina por ID
-- removerDisciplina :: String -> Int -> IO ()
-- removerDisciplina jsonFilePath disciplinaID = do
--     disciplinas <- getDisciplinasJSON jsonFilePath
--     let novasDisciplinas = filter (\disciplina -> id disciplina /= disciplinaID) disciplinas

--     B.writeFile "../Temp.json" $ encode novasDisciplinas
--     removeFile jsonFilePath
--     renameFile "../Temp.json" jsonFilePath
