module DataBase.Gerenciador.DisciplinaGerenciador where
import Model.Grupo
import Model.Aluno
import Model.Disciplina
import Model.LinkUtil
import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as B
import System.Directory
import DataBase.Gerenciador.AlunoGerenciador as A
import DataBase.Gerenciador.GrupoGerenciador as G
import Data.List

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

--Pega as disciplinas pelo código.
getDisciplinaByCodigo :: Int -> [Disciplina] -> Maybe Disciplina
getDisciplinaByCodigo _ [] = Nothing
getDisciplinaByCodigo codigoDisciplina (d:ds)
    | Model.Disciplina.id d == codigoDisciplina = Just d
    | otherwise = getDisciplinaByCodigo codigoDisciplina ds

--Pega os links da disciplina.
getLinksUteisDasDisciplinas :: [Disciplina] -> [LinkUtil]
getLinksUteisDasDisciplinas disciplinas =
    concatMap links disciplinas