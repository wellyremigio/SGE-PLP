module Main where

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

main:: IO()
main = do
    putStr "\n =========== Olá! Seja bem vindo ao SGE: Sistema de Gerenciamento de Estudos :D ===========\n"
    putStr "\n Escolha uma opção para começar a navegar no sistema: \n"
    putStr "1. Login\n"
    putStr "2. Cadastrar\n"
    op <- readLn:: IO Int
    opSelecionada op

opSelecionada:: Int -> IO()
opSelecionada op
    | op == 1 = menuLogin
    | op == 2 = menuCadastro

    | otherwise = do
        putStr "Ops! Entrada Inválida...\n"
        main

        init:: IO()
init = do
    putStr "\nEscolha uma opção\n"
    putStr "1- Criar grupo\n"
    putStr "2- Remover grupo\n"
    putStr "3- Meus grupos\n"
    putStr "4- Minhas disciplinas\n"
    putStr "5- Contribuir\n"
    putStr "6- Consultar\n"
    putStr "7- Favoritos\n"
    op <- readLn :: IO Int
    menuInit op

menuInit:: Int -> IO()
menuInit op
    | op == 1 = do
        putStr "Nome do grupo: "
        nomeGrupo <- getLine
        resultado <- _____
        putStrLn resultado
    | op == 2 = do
        putStr "Nome do grupo: "
        nomeGrupo <- getLine
        putStr "Matricula: "
        matricula <- readLn:: IO Int
        resultado <- -----
        putStrLn resultado
    | op == 3 = do
