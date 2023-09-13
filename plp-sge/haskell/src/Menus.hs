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

    menuinicial

menuEscolhaLogin:: IO()
menuEscolha = do
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
        foiCadastrada <- cadastraDisciplina -- metodo a ser criado
        if foiCadastrada then putStr "Disciplina adicionado." else putStr "Essa disciplina já está cadastrada."
    | op == 5 = listarDisciplinas -- toString das disciplinas
    | op == 6 = do
        putStrLn "Qual o id da disciplina que você quer remover? "
        id <- readLn:: IO Int
        foiRemovida <- removeDisciplina -- metodo p remover. todos eles retornar boolean
        if foiRemovida then putStr "Removida com sucesso." else "A disciplina não existe."
    | otherwise = do
        putStrLn "Escolha inválida. Tente novamente."
        selecaoMenuMeusGrupos

menuMinhasDisciplinas:: IO()
menuMinhasDisciplinas = do
    