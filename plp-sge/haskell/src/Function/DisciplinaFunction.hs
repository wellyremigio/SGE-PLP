module Function.DisciplinaFunction where

import DataBase.Gerenciador.DisciplinaGerenciador as DisciplinaG
import DataBase.Gerenciador.AlunoGerenciador as A
import Data.List (deleteBy)
import Model.Aluno
import Model.Disciplina

--cadastraResumo id nome conteudo
cadastraResumo :: String -> Int -> String -> String -> IO()
cadastraResumo matricula id nome conteudo = putStr (DisciplinaG.addResumoByID matricula id nome conteudo)