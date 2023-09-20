module Function.LinksUteisFunction where
import Model.LinksUteis
import Function.GrupoFunction (organizaListagem)
import Function.AlunoFunction
import Function.DisciplinaFunction
import Model.Disciplina
import Model.Grupo
import DataBase.Gerenciador.DisciplinaGerenciador as D
import DataBase.Gerenciador.GrupoGerenciador as G


-- Função que lista todos os links úteis de um grupo
{-listaLinks :: Int -> IO String
listaLinks codGrupo = do
    grupos <- G.getGruposJSON "scr/DataBase/Data/Grupo.json"
    case getGruposByCodigo codGrupo grupos of
        Just grupo -> do
            let disciplinasDoGrupo = D.getDisciplinasDoGrupo codGrupo
            let linksUteis = getLinksUteisDasDisciplinas disciplinasDoGrupo
            return $ organizaListagem linksUteis
        Nothing -> do
            return "Grupo não encontrado."-}