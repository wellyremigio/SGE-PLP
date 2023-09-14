-- TesteAluno.hs
module TesteAluno where

import DataBase.Gerenciador.AlunoGerenciador
import Model.Aluno

-- Função para realizar o teste das funcionalidades relacionadas ao aluno
testeAluno :: IO ()
testeAluno = do
    putStrLn "Teste do AlunoGerenciador"

    -- Caminho para o arquivo JSON (ajuste conforme necessário)
    let jsonFilePath = "caminho_para_o_arquivo/aluno.json"

    -- Teste da função salvarAlunoJSON
    salvarAlunoJSON jsonFilePath 123 "João" "senha123"

    putStrLn "Aluno cadastrado com sucesso!"

    -- Teste da função getAlunoByMatricula
    let matriculaProcurada = 123
    alunos <- getAlunosJSON jsonFilePath
    case getAlunoByMatricula matriculaProcurada alunos of
        Aluno (-1) _ -> putStrLn "Aluno não encontrado."
        alunoEncontrado -> putStrLn $ "Aluno encontrado: " ++ show alunoEncontrado

    -- Teste da função getAlunosJSON
    putStrLn "Listando todos os alunos:"
    alunos <- getAlunosJSON jsonFilePath
    mapM_ (printAluno) alunos

printAluno :: Aluno -> IO ()
printAluno aluno = putStrLn $ "Matrícula: " ++ show (matricula aluno) ++ ", Nome: " ++ nome aluno
