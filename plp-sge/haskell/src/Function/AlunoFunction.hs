module Function.AlunoFunction where

import DataBase.Gerenciador.AlunoGerenciador

-- cadastrarCliente :: String -> String -> String -> String -> IO String
--     cadastrarCliente nome idCliente idFun senha
--         | any null [filter (/= ' ') idCliente, filter (/= ' ') nome] = return "Cadastro falhou!"
--         | otherwise = do
--             valida <- validaFuncionario idFun senha
--             if valida then do
--                 BD.saveClienteJSON idCliente nome
--                 clientes <- getClienteJSON "app/DataBase/Cliente.json"
--                 cliente <- getClienteByID idCliente clientes
--                 return (show cliente)
--             else return "Cadastro falhou!"

cadastraUsuario :: String -> String -> String -> IO String
cadastraUsuario matricula nome senha = do
    saveAluno matricula nome senha
    return "OK"

