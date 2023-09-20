module Function.DisciplinaFunction where

import DataBase.Gerenciador.DisciplinaGerenciador as DisciplinaG
import DataBase.Gerenciador.AlunoGerenciador as AlunoG
import DataBase.Gerenciador.GrupoGerenciador as GrupoG
import Data.List (deleteBy)
import Model.Aluno
import Model.Disciplina
import Model.Grupo
import Model.LinksUteis
import Model.Resultado

-- Função para cadastrar um link em uma disciplina pelo seu ID
{-cadastraLink :: Int -> Int -> Int -> String -> String -> IO ()
cadastraLink idGrupo idDisciplina idLink titulo url = do
    -- Carregar os grupos do arquivo JSON
    grupos <- getGruposJSON "DataBase/Data/Grupos.json"
    -- Encontrar o grupo específico pelo idGrupo
    let grupoEspecifico = getGruposByCodigo idGrupo grupos
    case grupoEspecifico of
        Nothing -> putStrLn "Grupo não encontrado."
        Just grupo -> do
            let disciplinaEncontrada = DisciplinaG.getDisciplinaByCodigo idDisciplina (Model.Grupo.disciplinas grupo)
            case disciplinaEncontrada of
                Nothing -> putStrLn "Disciplina não encontrada."
                Just disciplina -> do
                    let novoLink = LinksUteis idLink titulo url
                    let linksUteisAtualizados = novoLink : Model.Disciplina.links disciplina
                    let disciplinaAtualizada = disciplina { Model.Disciplina.links = linksUteisAtualizados }

                    let grupoAtualizado = grupo { Model.Grupo.disciplinas = replaceDisciplina idDisciplina disciplinaAtualizada (Model.Grupo.disciplinas grupo) }
                    saveAlteracoesGrupo grupoAtualizado
                    putStrLn "Link cadastrado com sucesso!"-}

-- Função para cadastrar um link em uma disciplina pelo seu ID
cadastraLink :: Int -> Int -> Int -> String -> String -> IO String
cadastraLink idGrupo idDisciplina idLink titulo url = do
    grupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let grupoEspecifico = getGruposByCodigoCadastraMaterial idGrupo grupos
    case grupoEspecifico of
        NaoEncontrado -> return "Erro: Grupo não encontrado."
        Encontrado grupo -> do
            case getDisciplinaByCodigoCadastroMaterial idDisciplina (Model.Grupo.disciplinas grupo) of
                NaoEncontrado -> return "Erro: Disciplina não encontrada."
                Encontrado disciplina -> do
                    let novoLink = LinksUteis idLink titulo url
                    let linksUteisAtualizados = novoLink : Model.Disciplina.links disciplina
                    let disciplinaAtualizada = disciplina { Model.Disciplina.links = linksUteisAtualizados }
                    let novasDisciplinas = replaceDisciplina idDisciplina disciplinaAtualizada (Model.Grupo.disciplinas grupo)
                    let grupoAtualizado = grupo { Model.Grupo.disciplinas = novasDisciplinas }
                    atualizaGrupoNoJSON idGrupo grupoAtualizado
                    return "Link cadastrado com sucesso!"




-- Função para substituir uma disciplina por ID em uma lista de disciplinas
replaceDisciplina :: Int -> Disciplina -> [Disciplina] -> [Disciplina]
replaceDisciplina _ _ [] = []
replaceDisciplina idDisciplina novaDisciplina (d:ds)
    | Model.Disciplina.id d == idDisciplina = novaDisciplina : ds
    | otherwise = d : replaceDisciplina idDisciplina novaDisciplina ds

--cadastraResumo id nome conteudo
cadastraResumo :: String -> Int -> String -> String -> IO()
cadastraResumo matricula id nome conteudo = putStr (DisciplinaG.addResumoByID matricula id nome conteudo)