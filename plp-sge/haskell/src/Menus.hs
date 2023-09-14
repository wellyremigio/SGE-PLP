module Menus where

{-import DataBase.Gerenciador as BD--
import Function.AlunoFunction as AlunoF
import Function.ComentarioFunction as ComentarioF
import Function.DataFunction as DataF
import Function.DisciplinaFunction as DisciplinaF
import Function.GrupoFunction as GrupoF
import Function.LinksUteisFunction as LinksF
import Function.ResumoFunction as ResumoF

import Model.Aluno
import Model.Comentario
import Model.Data
import Model.Disciplina
import Model.Grupo
import Model.LinksUteis
import Model.Resumo-}

import Data.Time.Clock ()
import qualified Data.Time.Format as TimeFormat

menuLogin:: IO()
menuLogin = do
    putStr "Matrícula?\n"
    matriculaInput <- readLn:: IO Int
    putStr "Senha?\n"
    senhaInput <- getLine
    resposta <- verificaLogin -- função a ser criada
    if (resposta) then menuInicial else do
        putStr "Cadastro não econtrando :/\n"
        menuEscolha
        putStrLn "1. Tentar novamente ou se cadastrar?\n"

        menuInicial

menuEscolhaLogin:: IO()
menuEscolhaLogin = do
    putStr "Escolha uma opção para seguir:\n"
    putStr "1. Tentar Novamente\n2. Fazer cadastro.\n"
    op <- readLn:: IO Int
    verificaSolucao

verificaSolucao:: Int -> IO()
verificaSolucao op
    | op == 1 = menuLogin
    | op == 2 = menuCadastro
    | otherwise = do 
        putStr "Opção inválida. Escolha corretamente."
        verificaSolucao

menuCadastro:: IO()
menuCadastro = do
    putStr "Qual sua matrícula?\n"
    matriculaCadastrada <- readLn:: IO Int
    putStr "Qual seu nome?\n"
    nomeCadastrado <- getLine
    putStr "Qual será sua senha?\n"
    senhaCadastrada <- getLine
    cadastroRealizado <- cadastraUsuario -- função a ser criada
    if (cadastroRealizado) then menuInicial else do
        putStr "Seu cadastro não foi realizado. Tente novamente!"
        menuCadastro

menuInicial:: IO()
menuInicial = do
    putStr "\nEscolha uma opção\n"
    putStr "1- Criar grupo\n"
    putStr "2- Remover grupo\n"
    putStr "3- Meus grupos\n"
    putStr "4- Minhas disciplinas\n"
    putStr "5- Contribuir\n"
    putStr "6- Consultar\n"
    op <- readLn :: IO Int
    menuInit op

selecaoMenuInicial:: Int -> IO()
selecaoMenuInicial op
    | op == 1 = do
        putStr "Nome do grupo: "
        nomeGrupo <- getLine
        resultado <- cadastraGrupo -- função a ser criada
        putStrLn resultado
    | op == 2 = do
        putStr "Nome do grupo: "
        nomeGrupo <- getLine
        putStr "Matricula: "
        matricula <- readLn:: IO Int
        resultado <- removeGrupo -- função a ser criada
        putStr resultado
    | op == 3 = do
        listaGrupos -- metodo pra listar os grupos existentes. é como um toString
        menuMeusGrupos -- fzr dps. vai mostrar as opções possivies de manipulação dos grpos.
    | op == 4 = menuMinhasDisciplinas -- mostra as opçõs de cadastrar, ver e remover disciplina
    | op == 5 = menuMateriais -- opção de adicionar ou remover materiais
    | op == 6 = menuConsulta -- vai perguntar quais materiais quer ver e a opção de comentar/responder comentário.
    | otherwise = do
        putStrLn "Opção inválida. Tente de novo!"
        selecaoMenuInicial

menuMeusGrupos:: IO()
menuMeusGrupos = do
    putStrLn "Escolha o que você quer fazer: "
    putStrLn "1. Adicionar Aluno"
    putStrLn "2. Remover Aluno"
    putStrLn "3. Visualizar Alunos"
    putStrLn "4. Adicionar Disciplina"
    putStrLn "5. Visualizar Disciplina"
    putStrLn "6. RemoverDisciplina"
    op <- readLn:: IO Int
    selecaoMenuMeusGrupos op

selecaoMenuMeusGrupos:: Int -> IO()
selecaoMenuMeusGrupos op
    | op == 1 = do
        putStrLn "Matricula do aluno?"
        matriculaAluno <- readLn:: IO Int
        putStrLn "Qual a sua matrícula? "
        matriculaAdmin <- readLn:: IO Int
        ehAdm matriculaAdmin -- metodo que vai conferir se a pessoa q quer remover eh o adm
        if ehAdm matriculaAdmin then adicionaAluno matriculaAluno else putStr "O aluno já está cadastrado."
    | op == 2 = do
        putStrLn "Qual a matrícula do aluno que você deseja remover do grupo? "
        matriculaAlunoRemovido <- readLn:: IO Int
        putStrLn "Qual a sua matrícula? "
        matriculaAdmin <- readLn:: IO Int
        ehAdm matriculaAdmin -- metodo que vai conferir se a pessoa q quer remover eh o adm
        if ehAdm then removeAluno matriculaAlunoRemovido else putStr "Você não pode remover o aluno porque não é administrador do grupo."
    | op == 3 = listarAlunos -- toString dos alunos
    | op == 4 = do
        putStrLn "Qual o código da disciplina que você quer adicionar? "
        id <- readLn:: IO Int
        putStrLn "Nome da disciplina?"
        nomeDisciplina <- getLine
        putStrLn "Qual professor ministra?"
        nomeProfessor <- getLine
        putStrLn "Período? "
        periodo <- getLine
        foiCadastrada <- cadastraDisciplina id-- metodo a ser criado
        if foiCadastrada then putStr "Disciplina adicionado." else putStr "Essa disciplina já está cadastrada."
    | op == 5 = listarDisciplinas -- toString das disciplinas
    | op == 6 = do
        putStrLn "Qual o id da disciplina que você quer remover? "
        id <- readLn:: IO Int
        foiRemovida <- removeDisciplina id-- metodo p remover. todos eles retornar boolean
        if foiRemovida then putStr "Removida com sucesso." else "A disciplina não existe."
    | otherwise = do
        putStrLn "Escolha inválida. Tente novamente."
        selecaoMenuMeusGrupos

--Ao selecionar essa opção, o usuário poderá Ver Disciplinas Cadastradas, Cadastrar Disciplina e Remover uma Disciplina.--

menuMinhasDisciplinas:: IO()
menuMinhasDisciplinas = do
    putStrLn "1. Visualizar disciplinas"
    putStrLn "2. Cadastrar disciplina"
    putStrLn "3. Remover disciplina"
    op <- readLn :: IO Int
    selecionaMenuMinhasDisciplinas op

    selecionaMenuMinhasDisciplinas:: Int -> IO()
    selecionaMenuMinhasDisciplinas op
        | op == 1 = listasDisciplinas -- criar metodo
        | op == 2 = do
            putStrLn "Qual o código da disciplina que você quer adicionar? "
            id <- readLn:: IO Int
            putStrLn "Nome da disciplina?"
            nomeDisciplina <- getLine
            putStrLn "Qual professor ministra?"
            nomeProfessor <- getLine
            putStrLn "Período? "
            periodo <- getLine
            foiCadastrada <- cadastraDisciplina id -- metodo a ser criado
            if foiCadastrada then putStr "Disciplina adicionado." else putStr "Essa disciplina já está cadastrada."
        | op == 3 = do
            putStrLn "Qual o id da disciplina que você quer remover? "
            id <- readLn:: IO Int
            foiRemovida <- removeDisciplina id -- metodo p remover. todos eles retornar boolean
            if foiRemovida then putStr "Removida com sucesso." else "A disciplina não existe."
        | otherwise = do
            putStrLn "Escolha inválida. Tente novamente."
            selecionaMenuMinhasDisciplinas 

menuMateriais:: IO()
menuMateriais = do
    putStrLn "1. Ver materiais"
    putStrLn "2. Adicionar materiais"
    putStrLn "3. Remover materiais"
    putStrLn "4. Editar materiais"
    op <- readLn :: IO Int
    selecionaMateriais op

selecionaMateriais:: Int -> IO()
selecionaMateriais op
    | op == 1 = listarMateriais
    | op == 2 = do
        menuCadastraMateriais
    | op == 3 = do
        menuRemoverMateriais
    | op == 4 = do
        menuEditaMaterias
    | otherwise = do 
        putStrLn "Digite novamente" 
        selecionaMateriais


menuCadastraMateriais:: IO()
menuCadastraMaterias = do
    putStrLn "1. Resumo"
    putStrLn "2. Links"
    putStrLn "3. Datas"
    op <- readLn :: IO Int
    selecionaMenuCadastroMateriais op

selecionaMenuCadastroMateriais:: Int -> IO()
selecionaMenuCadastroMateriais op
    | op == 1 = do
        putStrln "ID disciplina: "
        id <- readLn :: IO Int
        putStrln "Nome do resumo: "
        nome <- getLine
        putStrln "Conteudo do resumo: "
        conteudo <- getLine
        cadastraResumo id nome conteudo
        putStrLn "Cadastrado com sucesso"
    | op == 2 = do
        putStrln "ID disciplina: "
        id <- readLn :: IO Int
        putStrLn "Link: "
        link <- getLine
        cadastraLink id link
        putStrLn "Cadastrado com sucesso"
    | op == 3 = do
        putStrln "ID disciplina: "
        id <- readLn :: IO Int
        putStrLn "Titulo: "
        titulo <- getLine
        putStrLn "Data: "
        dt <- getLine
        cadastraData id titulo dt
        putStrLn "Cadastrado com sucesso"

menuRemoveMateriais:: IO()
menuRemoveMaterias = do
    putStrLn "1. Resumo"
    putStrLn "2. Links"
    putStrLn "3. Datas"
    op <- readLn :: IO Int
    selecionaMenuRemoveMateriais op

selecionaMenuRemoveMateriais:: Int -> IO()
selecionaMenuRemoveMateriais op
    | op == 1 = do
        putStrln "ID disciplina: "
        id <- readLn :: IO Int
        putStrln "Nome do resumo: "
        nome <- getLine
        removeResumo id nome
        if (removeResumo) then do putStrLn "Removido com sucesso" else putStrLn "Não encontrado" 
    | op == 2 = do
        putStrln "ID disciplina: "
        id <- readLn :: IO Int
        putStrLn "Link: "
        link <- getLine
        removeLink id link
        if (removeLink) then do putStrLn "Removido com sucesso" else putStrLn "Não encontrado" 
    | op == 3 = do
        putStrln "ID disciplina: "
        id <- readLn :: IO Int
        putStrLn "Titulo: "
        titulo <- getLine
        removeData id titulo
        if (removeData) then do putStrLn "Removido com sucesso" else putStrLn "Não encontrado"

menuEditaMaterias:: IO()
menuEditaMaterias = do
    putStrLn "1. Resumo"
    putStrLn "2. Links"
    putStrLn "3. Datas"
    op <- readLn :: IO Int
    selecionaMenuEditaMateriais op

selecionaMenuEditaMateriais:: Int -> IO()
selecionaMenuEditaMateriais op
    | op == 1 = do
        putStrln "ID disciplina: "
        id <- readLn :: IO Int
        putStrln "Nome do resumo: "
        nome <- getLine
        
        removeResumo id nome
        if (removeResumo) then do putStrLn "Removido com sucesso" else putStrLn "Não encontrado" 
    | op == 2 = do
        putStrln "ID disciplina: "
        id <- readLn :: IO Int
        putStrLn "Link: "
        link <- getLine
        removeLink id link
        if (removeLink) then do putStrLn "Removido com sucesso" else putStrLn "Não encontrado" 
    | op == 3 = do
        putStrln "ID disciplina: "
        id <- readLn :: IO Int
        putStrLn "Titulo: "
        titulo <- getLine
        removeData id titulo
        if (removeData) then do putStrLn "Removido com sucesso" else putStrLn "Não encontrado" 