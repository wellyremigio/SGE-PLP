

module Menus where
import Function.AlunoFunction
import Function.GrupoFunction
import Function.DisciplinaFunction as DisciplinaF
{-import DataBase.Gerenciador as BD--
import Function.AlunoFunction as AlunoF
import Function.ComentarioFunction as ComentarioF
import Function.DataFunction as DataF

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

-- import Data.Time.Clock ()
-- import qualified Data.Time.Format as TimeFormat

menuLogin:: IO()
menuLogin = do
    putStr "Matrícula: \n"
    matriculaInput <- getLine
    putStr "Senha: \n"
    senhaInput <- getLine
    resposta <- verificaLogin matriculaInput senhaInput
    if (resposta) then menuInicial matriculaInput else do
        putStr "Cadastro não econtrando :/\n"
        menuEscolhaLogin



menuEscolhaLogin:: IO()
menuEscolhaLogin = do
    putStr "\nEscolha uma opção para seguir:\n"
    putStr "1. Tentar Fazer login\n2. Fazer cadastro.\n3. Sair\n"
    op <- readLn:: IO Int
    verificaSolucao op

verificaSolucao:: Int -> IO()
verificaSolucao op
    | op == 1 = menuLogin
    | op == 2 = menuCadastro
    | op == 3 =  putStr "Saindo..."
    | otherwise = do 
        putStr "\nOpção inválida. Escolha corretamente."
        op <- readLn:: IO Int
        verificaSolucao op

menuCadastro :: IO ()
menuCadastro = do
    putStr "\nMatrícula: \n"
    matriculaCadastrada <- getLine
    putStr "Nome: \n"
    nomeCadastrado <- getLine
    putStr "Senha: \n"
    senhaCadastrada <- getLine

    verificacao <- verificaLogin matriculaCadastrada senhaCadastrada
    if verificacao
        then do
            putStr "Aluno já cadastrado!"
            menuEscolhaLogin
        else do
            cadastroRealizado <- cadastraUsuario matriculaCadastrada nomeCadastrado senhaCadastrada
            putStr "Cadastro Realizado!!"
            menuInicial matriculaCadastrada



menuInicial :: String -> IO()
menuInicial matricula = do
    putStrLn ("\nEscolha uma opção:")
    putStr "1- Criar grupo\n"
    putStr "2- Remover grupo\n"
    putStr "3- Meus grupos\n"
    putStr "4- Minhas disciplinas\n"
    putStr "5- Contribuir\n"
    putStr "6- Consultar\n"
    putStr "7- Procurar Grupo\n"
    putStr "8- Cadastrar Material na Disciplina\n"
    putStr "9- Sair\n"
    op <- readLn :: IO Int
    selecaoMenuInicial op matricula

selecaoMenuInicial:: Int -> String -> IO()
selecaoMenuInicial op matricula
    | op == 1 = do
        putStrLn "\n==Cadastrando Aluno=="
        putStrLn "Nome do grupo: "
        nomeGrupo <- getLine
        putStrLn "Codigo do grupo: "
        codigo <- readLn :: IO Int
        resposta <- verificaIdGrupo codigo
        if not resposta then do 
            cadastraGrupo nomeGrupo codigo matricula
            putStr "Grupo cadastrado com sucesso!\n "
            menuInicial matricula
        else do 
            putStrLn "Já existe um grupo com esse ID. Cadastre um grupo novo!\n"
            menuInicial matricula

    | op == 2 = do
        putStrLn "\n==Removendo aluno=="
        putStrLn "Id do grupo: "
        idGrupo <- readLn :: IO Int
        ehAdm <- verificarAdmDeGrupo idGrupo matricula
        if(ehAdm) then do
            resultado <- removeGrupo idGrupo
            print resultado
        else
            putStrLn "Você nao é Adm do grupo"
        menuInicial matricula
    
    | op == 3 = do
        putStrLn "\n==Lista dos meus grupos=="
        resultado <- listaGrupos -- metodo pra listar os grupos existentes. é como um toString
        putStr resultado
        menuMeusGrupos matricula -- fzr dps. vai mostrar as opções possivies de manipulação dos grpos.
    | op == 4 = menuMinhasDisciplinas matricula
   -- | op == 5 = menuMateriais -- opção de adicionar ou remover materiais
   -- | op == 6 = menuConsulta -- vai perguntar quais materiais quer ver e a opção de comentar/responder comentário.
    | op == 7 = do
        result <- listagemDeGruposEmComum matricula
        putStr result
    | op == 8 = do
        menuCadastraMateriais matricula

    | otherwise = do
        putStrLn "Opção inválida. Tente de novo!"
        menuInicial matricula

menuMeusGrupos:: String -> IO()
menuMeusGrupos matricula = do
    putStrLn "\nEscolha o que você quer fazer: "
    putStrLn "1. Adicionar Aluno "
    putStrLn "2. Remover Aluno "
    putStrLn "3. Visualizar Alunos "
    putStrLn "4. Adicionar Disciplina "
    putStrLn "5. Visualizar Disciplina "
    putStrLn "6. RemoverDisciplina "
    putStrLn "8. Sair"
    op <- readLn:: IO Int
    selecaoMenuMeusGrupos op matricula

selecaoMenuMeusGrupos::  Int -> String -> IO()
selecaoMenuMeusGrupos op matricula
    | op == 1 = do
         putStrLn "\n==Adicionando aluno ao grupo=="
         putStrLn "Matrícula do aluno: "
         matriculaAluno <- getLine
         putStrLn "Código do grupo: "
         codigo <- readLn :: IO Int
         resposta <- verificaAdmGrupo matricula codigo-- metodo que vai conferir se a pessoa q quer remover eh o adm
         if resposta then do
            resultado <- adicionarAluno matriculaAluno codigo
            putStrLn resultado
            else putStr "O aluno já está cadastrado."
         menuMeusGrupos matricula
    | op == 2 = do
        putStrLn "\n==Removendo aluno do grupo=="
        putStrLn "Código do grupo: "
        idGrupo <- readLn :: IO Int
        putStrLn "Matrícula do aluno a ser removido: "
        matriculaAlunoRemovido <- getLine
        result <- verificaAdmGrupo matricula idGrupo
        if result then do
            saida <- removerAlunoGrupo idGrupo matriculaAlunoRemovido
            print saida
        else
            putStrLn "Você nao é Adm do grupo"
        menuMeusGrupos matricula
    | op == 3 = do
        putStrLn "Digite o código do grupo para listar os alunos"
        codGrupo <- readLn :: IO Int
        result <- listagemAlunoGrupo codGrupo-- toString dos alunos
        putStr result
        menuMeusGrupos matricula
    | op == 4 = do
        putStrLn "\n==Adicionando disciplina a grupo=="
        putStrLn "Código do grupo: "
        codGrupo <- readLn :: IO Int
        putStrLn "Qual o código da disciplina que você quer adicionar? "
        idDisciplina <- readLn:: IO Int
        putStrLn "Nome da disciplina?"
        nomeDisciplina <- getLine
        putStrLn "Qual professor ministra?"
        nomeProfessor <- getLine
        putStrLn "Período? "
        periodo <- getLine
        result <- cadastraDisciplina codGrupo idDisciplina nomeDisciplina nomeProfessor periodo
        if(result) then
            putStrLn "Discplina Adicionada!"
        else
            putStrLn "Erro...A Disciplina ja foi cadastrada"
    | op == 5 = do 
        putStrLn "Digite o código do grupo para listar as disciplinas do grupo"
        codGrupo <- readLn :: IO Int
        result <- listagemDisciplinaGrupo codGrupo matricula
        putStrLn result
        menuMeusGrupos matricula
    | op == 6 = do
        putStrLn "\n==Remover disciplina de grupo=="
        putStrLn "Id da disciplina a ser removida: "
        idDisciplina <- readLn:: IO Int
        putStrLn "Codigo do grupo: "
        idGrupo <- readLn:: IO Int
        saida <- removerDisciplinaGrupo idGrupo idDisciplina 
        print saida
        menuMeusGrupos matricula
    | op == 8 = do
        putStrLn "Saindo..."
    | otherwise = do
        putStrLn "Escolha inválida. Tente novamente."
        selecaoMenuMeusGrupos op matricula

-- --Ao selecionar essa opção, o usuário poderá Ver Disciplinas Cadastradas, Cadastrar Disciplina e Remover uma Disciplina.--

menuMinhasDisciplinas::String -> IO()
menuMinhasDisciplinas matricula = do
    putStrLn "1. Visualizar disciplinas"
    putStrLn "2. Cadastrar disciplina"
    putStrLn "3. Remover disciplina"
    putStrLn "4. Voltar"
    putStrLn "5. Sair"
    op <- readLn :: IO Int
    selecionaMenuMinhasDisciplinas op matricula


selecionaMenuMinhasDisciplinas:: Int -> String -> IO()
selecionaMenuMinhasDisciplinas op matricula
    | op == 1 = do 
        result <- listagemDisciplinaALuno matricula
        putStrLn result
        menuMinhasDisciplinas matricula

    | op == 2 = do
        putStrLn "-Qual o código da disciplina que você quer adicionar ?"
        id <- readLn:: IO Int
        putStrLn "-Nome da disciplina ?"
        nomeDisciplina <- getLine
        putStrLn "-Qual professor ministra ?"
        nomeProfessor <- getLine
        putStrLn "-Período ?"
        periodo <- getLine
        result <- adicionarDisciplina matricula id nomeDisciplina nomeProfessor periodo
        if(result) then
            putStrLn "Discplina Adicionada!"
        else
            putStrLn "Erro...A Disciplina ja foi cadastrada"
        menuMinhasDisciplinas matricula

    | op == 3 = do
         putStrLn "Qual o id da disciplina que você quer remover? "
         id <- readLn:: IO Int
         result <- removerDisciplinaAluno matricula id
         if(result) then
            putStrLn "Discplina Removida"
         else
            putStrLn "Erro...A Disciplina não existe!"
         menuMinhasDisciplinas matricula

    | op == 4 = do
        putStrLn "Voltando..."
        menuInicial matricula
    | op == 5 = do
        putStrLn "Saindo..."

    | otherwise = do
        putStrLn "Escolha inválida. Tente novamente."
        menuMinhasDisciplinas matricula
-- menuMateriais:: IO()
-- menuMateriais = do
--     putStrLn "1. Ver materiais"
--     putStrLn "2. Adicionar materiais"
--     putStrLn "3. Remover materiais"
--     putStrLn "4. Editar materiais"
--     op <- readLn :: IO Int
--     selecionaMateriais op

-- selecionaMateriais:: Int -> IO()
-- selecionaMateriais op
--     | op == 1 = listarMateriais
--     | op == 2 = do
--         menuCadastraMateriais
--     | op == 3 = do
--         menuRemoverMateriais
--     | op == 4 = do
--         menuEditaMaterias
--     | otherwise = do 
--         putStrLn "Digite novamente" 
--         selecionaMateriais


menuCadastraMateriais:: String -> IO()
menuCadastraMateriais matricula = do
    putStrLn "\nSelecione o tipo de material que você gostaria de cadastrar:"
    putStrLn "1. Resumo"
    putStrLn "2. Links"
    putStrLn "3. Datas"
    op <- readLn :: IO Int
    selecionaMenuCadastroMateriais op matricula

selecionaMenuCadastroMateriais:: Int -> String -> IO()
selecionaMenuCadastroMateriais op matricula
    | op == 1 = do
        putStrLn "ID disciplina: "
        id <- readLn :: IO Int
        putStrLn "Nome do resumo: "
        nome <- getLine
        putStrLn "Conteudo do resumo: "
        conteudo <- getLine
        DisciplinaF.cadastraResumo matricula id nome conteudo
        putStrLn "Cadastrado com sucesso"
    -- | op == 2 = do
    --     putStrLn "ID disciplina: "
    --     id <- readLn :: IO Int
    --     putStrLn "Link: "
    --     link <- getLine
    --     cadastraLink id link
    --     putStrLn "Cadastrado com sucesso"
    -- | op == 3 = do
    --     putStrln "ID disciplina: "
    --     id <- readLn :: IO Int
    --     putStrLn "Titulo: "
    --     titulo <- getLine
    --     putStrLn "Data: "
    --     dt <- getLine
    --     cadastraData id titulo dt
    --     putStrLn "Cadastrado com sucesso"

-- menuRemoveMateriais:: IO()
-- menuRemoveMaterias = do
--     putStrLn "1. Resumo"
--     putStrLn "2. Links"
--     putStrLn "3. Datas"
--     op <- readLn :: IO Int
--     selecionaMenuRemoveMateriais op

-- selecionaMenuRemoveMateriais:: Int -> IO()
-- selecionaMenuRemoveMateriais op
--     | op == 1 = do
--         putStrln "ID disciplina: "
--         id <- readLn :: IO Int
--         putStrln "Nome do resumo: "
--         nome <- getLine
--         removeResumo id nome
--         if (removeResumo) then do putStrLn "Removido com sucesso" else putStrLn "Não encontrado" 
--     | op == 2 = do
--         putStrln "ID disciplina: "
--         id <- readLn :: IO Int
--         putStrLn "Link: "
--         link <- getLine
--         removeLink id link
--         if (removeLink) then do putStrLn "Removido com sucesso" else putStrLn "Não encontrado" 
--     | op == 3 = do
--         putStrln "ID disciplina: "
--         id <- readLn :: IO Int
--         putStrLn "Titulo: "
--         titulo <- getLine
--         removeData id titulo
--         if (removeData) then do putStrLn "Removido com sucesso" else putStrLn "Não encontrado"

-- menuEditaMaterias:: IO()
-- menuEditaMaterias = do
--     putStrLn "1. Resumo"
--     putStrLn "2. Links"
--     putStrLn "3. Datas"
--     op <- readLn :: IO Int
--     selecionaMenuEditaMateriais op

-- selecionaMenuEditaMateriais:: Int -> IO()
-- selecionaMenuEditaMateriais op
--     | op == 1 = do
--         putStrln "ID disciplina: "
--         id <- readLn :: IO Int
--         putStrln "Nome do resumo: "
--         nome <- getLine
        
--         editarResumo id nome
--         if (editarResumo) then do putStrLn "Editado com sucesso" else putStrLn "Não encontrado" 
--     | op == 2 = do
--         putStrln "ID disciplina: "
--         id <- readLn :: IO Int
--         putStrLn "Link: "
--         link <- getLine
--         editarLink id link
--         if (editarLink) then do putStrLn "Editado com sucesso" else putStrLn "Não encontrado" 
--     | op == 3 = do
--         putStrln "ID disciplina: "
--         id <- readLn :: IO Int
--         putStrLn "Titulo: "
--         titulo <- getLine
--         editaData id titulo
--         if (editaData) then do putStrLn "Editado com sucesso" else putStrLn "Não encontrado" 

-- menuConsulta:: IO()
-- menuConsulta = do
--     putStrLn "Você deseja ver o material de qual disciplia? Informe o id"
--     id <- readLn::IO Int
--     putStrLn "Qual o tipo de material?"
--     putStrLn "1. Resumo"
--     putStrLn "2. Links"
--     putStrLn "3. Datas"
--     op <- readLn :: IO Int
--     selecionaMenuConsulta op

-- selecionaMenuConsulta:: IO()
-- selecionaMenuConsulta op
--     | op == 1 = do
--         putStrLn "Nome do Resumo? "
--         nome <- getLine
--         achaResumo
--         menuEscolhaResumo nome
--     | op == 2 = do
--         putStrLn "Nome do Link? "
--         nome <- getLine
--         achaLink
--         menuEscolhaLink nome
--     | op == 1 = do
--         putStrLn "Nome da Data? "
--         nome <- getLine
--         achaData
--         menuEscolhaData nome

    
-- menuEscolhaResumo:: Resumo -> IO()
-- menuEscolhaResumo = do
--     putStrLn "Você deseja ver material ou comentar? (VER/COMENTAR): "
--     resposta <- getLine
--     if resposta == VER then mostraResumo nome else if resposta == "COMENTAR" then comentarResumo nome else do "Resposta inválida" menuEscolhaResumo

-- menuEscolhaLink:: Link -> IO()
-- menuEscolhaLink = do
--     putStrLn "Você deseja ver material ou comentar? (VER/COMENTAR): "
--     resposta <- getLine
--     if resposta == VER then mostraLink nome else if resposta == "COMENTAR" then comentarLink nome else do "Resposta inválida" menuEscolhaLink


-- menuEscolhaData:: Link -> IO()
-- menuEscolhaData = do
--     putStrLn "Você deseja ver material ou comentar? (VER/COMENTAR): "
--     resposta <- getLine
--     if resposta == VER then mostraData nome else if resposta == "COMENTAR" then comentarData nome else do "Resposta inválida" menuEscolhaLink