module Function.DisciplinaFunction where

import DataBase.Gerenciador.DisciplinaGerenciador as DisciplinaG
import DataBase.Gerenciador.AlunoGerenciador as A
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



