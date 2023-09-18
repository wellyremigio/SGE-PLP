-- Main do programa. Dá boas vindas ao usuário e redireciona as operações para o módulo Menus.
module Main where
import Menus
main :: IO ()
main = do
    putStr "\n =========== Olá! Seja bem vindo ao SGE: Sistema de Gerenciamento de Estudos :D ===========\n"
    putStr "\n Escolha uma opção para começar a navegar no sistema: \n"
    putStr "1. Login\n"
    putStr "2. Cadastrar\n"
    putStr "3. Sair\n"
    op <- readLn :: IO Int
    opSelecionada op

-- Função que redireciona a escolha do usuário para a parte competente.
opSelecionada :: Int -> IO ()
opSelecionada op
    -- | op == 1 = --menuLogin
    | op == 1 = menuLogin
    | op == 2 = menuCadastro
    | op == 3 = putStr "Saindo...\n"
    | otherwise = do
        putStr "Ops! Entrada Inválida...\n"
        main
