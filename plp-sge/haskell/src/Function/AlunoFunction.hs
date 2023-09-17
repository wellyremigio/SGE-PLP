module Function.AlunoFunction where
import Model.Aluno
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
    return "Cadastro realizado com sucesso!\n"

verificaLogin :: String -> String -> IO Bool
verificaLogin matricula senha = do
    listaAlunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let aluno = getAlunoByMatricula matricula listaAlunos
    senhaValida <- verificaSenha senha
    return $ Model.Aluno.matricula aluno /= "" && senhaValida

verificaSenha :: String -> IO Bool
verificaSenha senha = do
    listaAlunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let aluno = getAlunoBySenha senha listaAlunos
    return $ Model.Aluno.senha aluno /= ""