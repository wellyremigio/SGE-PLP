module Function.DisciplinaFunction where

import DataBase.Gerenciador.DisciplinaGerenciador as DisciplinaG
import DataBase.Gerenciador.AlunoGerenciador as A
import Data.List (deleteBy)
import Model.Aluno
import Model.Disciplina

--cadastraResumo id nome conteudo
cadastraResumo :: String -> Int -> String -> String -> IO()
cadastraResumo matricula id nome conteudo = putStr (DisciplinaG.addResumoByID matricula id nome conteudo)

organizaListagem :: Show t => [t] -> String
organizaListagem [] = ""
organizaListagem (x:xs) = show x ++ "\n" ++ organizaListagem xs

listagemDisplinaALuno :: String -> IO String
listagemDisplinaALuno matriculaAluno = do 
    disciplinasAluno <- A.getDisciplinasAluno matriculaAluno
    if null disciplinasAluno then 
        return "Nenhuma disciplina cadastrada!"
    else 
        return (organizaListagem disciplinasAluno)

disciplinaExiste :: Int -> [Disciplina] -> Bool
disciplinaExiste idDisciplina disciplinas = any (\disciplina -> Model.Disciplina.id disciplina == idDisciplina) disciplinas
        
adicionarDisciplina :: String -> Int -> String -> String -> String -> IO Bool
adicionarDisciplina matriculaAluno idDisciplina nome professor periodo = do
     alunos <- A.getAlunoJSON "src/DataBase/Data/Aluno.json" 
     let alunoExistente = getAlunoByMatricula matriculaAluno alunos
     let disciplinaNova = Disciplina idDisciplina nome professor periodo []
     let japossuiDisciplina = disciplinaExiste idDisciplina (disciplinas alunoExistente)
     
     if not japossuiDisciplina then do
        let disciplinasExistente = disciplinas alunoExistente
        let novoAluno = alunoExistente { Model.Aluno.disciplinas = disciplinasExistente ++ [disciplinaNova] }
        alunosAtualizados <- A.removeAlunoByMatricula matriculaAluno
        let newListAluno = alunosAtualizados ++ [novoAluno]
        A.saveAlunoAlteracoes newListAluno
        return True
     else 
        return False


removerDisciplinaAluno :: String -> Int -> IO Bool
removerDisciplinaAluno matriculaAluno idDisciplina = do
    alunos <- A.getAlunoJSON "src/DataBase/Data/Aluno.json"
    let alunoExistente = getAlunoByMatricula matriculaAluno alunos
    let japossuiDisciplina = disciplinaExiste idDisciplina (disciplinas alunoExistente)
    if japossuiDisciplina then do
        let disciplinasAtualizadas = removeDisciplinaPorID idDisciplina (disciplinas alunoExistente)
        let novoAluno = alunoExistente { Model.Aluno.disciplinas = disciplinasAtualizadas }
        alunosAtualizados <- A.removeAlunoByMatricula matriculaAluno
        let newListAluno = novoAluno : alunosAtualizados
        A.saveAlunoAlteracoes newListAluno
        return True -- Indica que a disciplina foi removida com sucesso
    else
        return False -- Indica que a disciplina não foi encontrada ou não foi removida
        
        

        

-- Função para remover uma disciplina por ID
removeDisciplinaPorID :: Int -> [Disciplina] -> [Disciplina]
removeDisciplinaPorID _ [] = [] -- Caso base: a lista está vazia, não há nada a fazer
removeDisciplinaPorID idToRemove disciplinas = deleteBy (\disciplina1 disciplina2 -> Model.Disciplina.id disciplina1 == Model.Disciplina.id disciplina2) (Disciplina idToRemove "" "" "" []) disciplinas

