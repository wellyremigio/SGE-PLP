module Function.AlunoFunction where
import Model.Aluno
import Model.Disciplina
import Data.List (deleteBy)
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

organizaListagem :: Show t => [t] -> String
organizaListagem [] = ""
organizaListagem (x:xs) = show x ++ "\n" ++ organizaListagem xs

listagemDisciplinaALuno :: String -> IO String
listagemDisciplinaALuno matriculaAluno = do 
    disciplinasAluno <- getDisciplinasAluno matriculaAluno
    if null disciplinasAluno then 
        return "Nenhuma disciplina cadastrada!"
    else 
        return (organizaListagem disciplinasAluno)

disciplinaExiste :: Int -> [Disciplina] -> Bool
disciplinaExiste idDisciplina disciplinas = any (\disciplina -> Model.Disciplina.id disciplina == idDisciplina) disciplinas
        
adicionarDisciplina :: String -> Int -> String -> String -> String -> IO Bool
adicionarDisciplina matriculaAluno idDisciplina nome professor periodo = do
     alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json" 
     let alunoExistente = getAlunoByMatricula matriculaAluno alunos
     let disciplinaNova = Disciplina idDisciplina nome professor periodo []
     let japossuiDisciplina = disciplinaExiste idDisciplina (disciplinas alunoExistente)
     
     if not japossuiDisciplina then do
        let disciplinasExistente = disciplinas alunoExistente
        let novoAluno = alunoExistente { Model.Aluno.disciplinas = disciplinasExistente ++ [disciplinaNova] }
        alunosAtualizados <- removeAlunoByMatricula matriculaAluno
        let newListAluno = alunosAtualizados ++ [novoAluno]
        saveAlunoAlteracoes newListAluno
        return True
     else 
        return False

removerDisciplinaAluno :: String -> Int -> IO Bool
removerDisciplinaAluno matriculaAluno idDisciplina = do
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let alunoExistente = getAlunoByMatricula matriculaAluno alunos
    let japossuiDisciplina = disciplinaExiste idDisciplina (disciplinas alunoExistente)
    if japossuiDisciplina then do
        let disciplinasAtualizadas = removeDisciplinaPorID idDisciplina (disciplinas alunoExistente)
        
        let novoAluno = alunoExistente { Model.Aluno.disciplinas = disciplinasAtualizadas }
        alunosAtualizados <- removeAlunoByMatricula matriculaAluno
        let newListAluno = novoAluno : alunosAtualizados
        saveAlunoAlteracoes newListAluno
        return True
    else
        return False
        
-- Função para remover uma disciplina por ID
removeDisciplinaPorID :: Int -> [Disciplina] -> [Disciplina]
removeDisciplinaPorID _ [] = []
removeDisciplinaPorID idToRemove disciplinas = deleteBy (\disciplina1 disciplina2 -> Model.Disciplina.id disciplina1 == Model.Disciplina.id disciplina2) (Disciplina idToRemove "" "" "" []) disciplinas
