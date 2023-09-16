

module Menus where
import Function.AlunoFunction
import Function.GrupoFunction
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

-- import Data.Time.Clock ()
-- import qualified Data.Time.Format as TimeFormat

menuLogin:: IO()
menuLogin = do
    putStr "Matrícula?\n"
    matriculaInput <- getLine
    putStr "Senha?\n"
    senhaInput <- getLine
    resposta <- verificaLogin matriculaInput senhaInput
    if (resposta) then menuInicial matriculaInput else do
        putStr "Cadastro não econtrando :/\n"
        menuEscolhaLogin


menuEscolhaLogin:: IO()
menuEscolhaLogin = do
    putStr "\nEscolha uma opção para seguir:\n"
    putStr "1. Tentar Novamente\n2. Fazer cadastro.\n"
    op <- readLn:: IO Int
    verificaSolucao op

verificaSolucao:: Int -> IO()
verificaSolucao op
    | op == 1 = menuLogin
    | op == 2 = menuCadastro
    | otherwise = do 
        putStr "\nOpção inválida. Escolha corretamente."
        op <- readLn:: IO Int
        verificaSolucao op

menuCadastro:: IO()
menuCadastro = do
    putStr "Qual sua matrícula?\n"
    -- matriculaCadastrada <- readLn:: IO Int
    matriculaCadastrada <- getLine
    putStr "Qual seu nome?\n"
    nomeCadastrado <- getLine
    putStr "Qual será sua senha?\n"
    senhaCadastrada <- getLine
    cadastroRealizado <- cadastraUsuario matriculaCadastrada nomeCadastrado senhaCadastrada

    putStr cadastroRealizado
    menuInicial matriculaCadastrada

    -- if (cadastroRealizado) then menuInicial else do
    --     putStr "Seu cadastro não foi realizado. Tente novamente!"
    --     menuCadastro

menuInicial :: String -> IO()
menuInicial matricula = do
    putStrLn ("\nEscolha uma opção:")
    putStr "1- Criar grupo\n"
    putStr "2- Remover grupo\n"
    putStr "3- Meus grupos\n"
    putStr "4- Minhas disciplinas\n"
    putStr "5- Contribuir\n"
    putStr "6- Consultar\n"
    putStr "7- Sair\n"
    op <- readLn :: IO Int
    selecaoMenuInicial op matricula
    

selecaoMenuInicial:: Int -> String -> IO()
selecaoMenuInicial op matricula
    | op == 1 = do
        putStr "Nome do grupo: \n"
        nomeGrupo <- getLine
        putStr "Codigo do grupo: \n"
        codigo <- readLn :: IO Int
        putStr "Matrícula do adm do grupo: \n"
        adm <- getLine
        resposta <- verificaIdGrupo codigo
        if not resposta then do 
            cadastraGrupo nomeGrupo codigo adm
            menuInicial matricula
        else do 
            putStrLn "Já existe um grupo com esse ID. Cadastre um grupo novo!"
            menuInicial matricula
        {-resultado <- cadastraGrupo nomeGrupo codigo adm-- função a ser criada
        putStrLn resultado
        menuInicial-}

   -- | op == 2 = do
   --     putStr "Nome do grupo: "
  --      nomeGrupo <- getLine
  --      putStr "Matricula: "
  --      matricula <- readLn:: IO Int
   --     resultado <- removeGrupo -- função a ser criada
       -- putStr resultado
    | op == 3 = do
     resultado <- listaGrupos -- metodo pra listar os grupos existentes. é como um toString
     putStr resultado
     menuMeusGrupos -- fzr dps. vai mostrar as opções possivies de manipulação dos grpos.
   -- | op == 4 = menuMinhasDisciplinas -- mostra as opçõs de cadastrar, ver e remover disciplina
   -- | op == 5 = menuMateriais -- opção de adicionar ou remover materiais
   -- | op == 6 = menuConsulta -- vai perguntar quais materiais quer ver e a opção de comentar/responder comentário.
    | otherwise = do
        putStrLn "Opção inválida. Tente de novo!"
        menuInicial matricula

menuMeusGrupos:: IO()
menuMeusGrupos = do
    putStrLn "Escolha o que você quer fazer: "
    putStrLn "1. Adicionar Aluno"
    putStrLn "2. Remover Aluno"
    putStrLn "3. Visualizar Alunos"
    putStrLn "4. Adicionar Disciplina"
    putStrLn "5. Visualizar Disciplina"
    putStrLn "6. RemoverDisciplina"
    --op <- readLn:: IO Int
    --selecaoMenuMeusGrupos op

--selecaoMenuMeusGrupos:: Int -> IO()
--selecaoMenuMeusGrupos op
--    | op == 1 = do
--         putStrLn "Matricula do aluno?"
--         matriculaAluno <- readLn:: IO Int
--         putStrLn "Qual a sua matrícula? "
--         matriculaAdmin <- readLn:: IO Int
--         ehAdm matriculaAdmin -- metodo que vai conferir se a pessoa q quer remover eh o adm
--         if ehAdm matriculaAdmin then adicionaAluno matriculaAluno else putStr "O aluno já está cadastrado."
--     | op == 2 = do
--         putStrLn "Qual a matrícula do aluno que você deseja remover do grupo? "
--         matriculaAlunoRemovido <- readLn:: IO Int
--         putStrLn "Qual a sua matrícula? "
--         matriculaAdmin <- readLn:: IO Int
--         ehAdm matriculaAdmin -- metodo que vai conferir se a pessoa q quer remover eh o adm
--         if ehAdm then removeAluno matriculaAlunoRemovido else putStr "Você não pode remover o aluno porque não é administrador do grupo."
--     | op == 3 = listarAlunos -- toString dos alunos
--     | op == 4 = do
--         putStrLn "Qual o código da disciplina que você quer adicionar? "
--         id <- readLn:: IO Int
--         putStrLn "Nome da disciplina?"
--         nomeDisciplina <- getLine
--         putStrLn "Qual professor ministra?"
--         nomeProfessor <- getLine
--         putStrLn "Período? "
--         periodo <- getLine
--         foiCadastrada <- cadastraDisciplina id-- metodo a ser criado
--         if foiCadastrada then putStr "Disciplina adicionado." else putStr "Essa disciplina já está cadastrada."
--     | op == 5 = listarDisciplinas -- toString das disciplinas
--     | op == 6 = do
--         putStrLn "Qual o id da disciplina que você quer remover? "
--         id <- readLn:: IO Int
--         foiRemovida <- removeDisciplina id-- metodo p remover. todos eles retornar boolean
--         if foiRemovida then putStr "Removida com sucesso." else "A disciplina não existe."
--     | otherwise = do
--         putStrLn "Escolha inválida. Tente novamente."
--         selecaoMenuMeusGrupos

-- --Ao selecionar essa opção, o usuário poderá Ver Disciplinas Cadastradas, Cadastrar Disciplina e Remover uma Disciplina.--

-- menuMinhasDisciplinas:: IO()
-- menuMinhasDisciplinas = do
--     putStrLn "1. Visualizar disciplinas"
--     putStrLn "2. Cadastrar disciplina"
--     putStrLn "3. Remover disciplina"
--     op <- readLn :: IO Int
--     selecionaMenuMinhasDisciplinas op

--     selecionaMenuMinhasDisciplinas:: Int -> IO()
--     selecionaMenuMinhasDisciplinas op
--         | op == 1 = listasDisciplinas -- criar metodo
--         | op == 2 = do
--             putStrLn "Qual o código da disciplina que você quer adicionar? "
--             id <- readLn:: IO Int
--             putStrLn "Nome da disciplina?"
--             nomeDisciplina <- getLine
--             putStrLn "Qual professor ministra?"
--             nomeProfessor <- getLine
--             putStrLn "Período? "
--             periodo <- getLine
--             foiCadastrada <- cadastraDisciplina id -- metodo a ser criado
--             if foiCadastrada then putStr "Disciplina adicionado." else putStr "Essa disciplina já está cadastrada."
--         | op == 3 = do
--             putStrLn "Qual o id da disciplina que você quer remover? "
--             id <- readLn:: IO Int
--             foiRemovida <- removeDisciplina id -- metodo p remover. todos eles retornar boolean
--             if foiRemovida then putStr "Removida com sucesso." else "A disciplina não existe."
--         | otherwise = do
--             putStrLn "Escolha inválida. Tente novamente."
--             selecionaMenuMinhasDisciplinas 

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


-- menuCadastraMateriais:: IO()
-- menuCadastraMaterias = do
--     putStrLn "1. Resumo"
--     putStrLn "2. Links"
--     putStrLn "3. Datas"
--     op <- readLn :: IO Int
--     selecionaMenuCadastroMateriais op

-- selecionaMenuCadastroMateriais:: Int -> IO()
-- selecionaMenuCadastroMateriais op
--     | op == 1 = do
--         putStrln "ID disciplina: "
--         id <- readLn :: IO Int
--         putStrln "Nome do resumo: "
--         nome <- getLine
--         putStrln "Conteudo do resumo: "
--         conteudo <- getLine
--         cadastraResumo id nome conteudo
--         putStrLn "Cadastrado com sucesso"
--     | op == 2 = do
--         putStrln "ID disciplina: "
--         id <- readLn :: IO Int
--         putStrLn "Link: "
--         link <- getLine
--         cadastraLink id link
--         putStrLn "Cadastrado com sucesso"
--     | op == 3 = do
--         putStrln "ID disciplina: "
--         id <- readLn :: IO Int
--         putStrLn "Titulo: "
--         titulo <- getLine
--         putStrLn "Data: "
--         dt <- getLine
--         cadastraData id titulo dt
--         putStrLn "Cadastrado com sucesso"

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