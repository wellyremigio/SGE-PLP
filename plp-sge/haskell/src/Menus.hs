--Módulo responsável por receber a escolha inicial do usuário vinda no Main e redirecionar as operações para os módulos responsáveis.
-- Esse módulo também lê os dados do usuário.
module Menus where
import Function.AlunoFunction
import Function.GrupoFunction

-- Função que lê os dados de login do usuário.
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

-- Função que dá alternativas ao usuário caso ele não tenha cadastro ainda.
menuEscolhaLogin:: IO()
menuEscolhaLogin = do
    putStrLn "\nEscolha uma opção para seguir:\n"
    putStrLn "1. Tentar Fazer login\n2. Fazer cadastro.\n3. Sair\n"
    op <- readLn:: IO Int
    verificaSolucao op

-- Função que verifica a escolha do usuário.
verificaSolucao:: Int -> IO()
verificaSolucao op
    | op == 1 = menuLogin
    | op == 2 = menuCadastro
    | op == 3 =  putStrLn "Saindo..."
    | otherwise = do 
        putStrLn "\nOpção inválida. Escolha corretamente."
        op <- readLn:: IO Int
        verificaSolucao op

-- Função responsável pelo cadastro do usuário.
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
            putStrLn cadastroRealizado
            menuInicial matriculaCadastrada

-- Mostra as opções do SGE para o usuário.
menuInicial :: String -> IO()
menuInicial matricula = do
    putStrLn ("\nEscolha uma opção:\n")
    putStrLn "1- Criar grupo"
    putStrLn "2- Remover grupo"
    putStrLn "3- Meus grupos"
    putStrLn "4- Minhas disciplinas"
    putStrLn "5- Contribuir"
    putStrLn "6- Consultar"
    putStrLn "7- Procurar Grupo"
    putStrLn "8- Sair"
    op <- readLn :: IO Int
    selecaoMenuInicial op matricula

-- Responsável pela manipulação (leitura e redirecionamento) das escolhas referentes ao menuInicial.    
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
        putStrLn "\nEsses são os seus grupos: \n"
        resultado <- listaGrupos matricula -- metodo pra listar os grupos existentes. é como um toString
        putStr resultado
        menuMeusGrupos matricula -- fzr dps. vai mostrar as opções possivies de manipulação dos grpos.
    | op == 4 = menuMinhasDisciplinas matricula
   -- | op == 5 = menuMateriais -- opção de adicionar ou remover materiais
   -- | op == 6 = menuConsulta -- vai perguntar quais materiais quer ver e a opção de comentar/responder comentário.
    | op == 7 = do
        result <- listagemDeGruposEmComum matricula
        putStr result
    | op == 8 = putStrLn "Saindo...\n"
    | otherwise = do
        putStrLn "Opção inválida. Tente de novo!"
        menuInicial matricula

--Menu específico para as funções dos grupos.
menuMeusGrupos:: String -> IO()
menuMeusGrupos matricula = do
    putStrLn "\nEscolha o que você quer fazer: "
    putStrLn "1. Adicionar Aluno"
    putStrLn "2. Remover Aluno"
    putStrLn "3. Visualizar Alunos"
    putStrLn "4. Adicionar Disciplina"
    putStrLn "5. Visualizar Disciplina"
    putStrLn "6. Remover Disciplina"
    putStrLn "7. Materiais"
    putStrLn "8. Ver grupos"
    putStrLn "9. Voltar"
    putStrLn "10. Sair"
    op <- readLn:: IO Int
    selecaoMenuMeusGrupos op matricula

-- Recebe a escolha do usuário e redireciona.
selecaoMenuMeusGrupos::  Int -> String -> IO()
selecaoMenuMeusGrupos op matricula
    | op == 1 = do
         putStrLn "Matrícula do aluno a ser adicionado?"
         matriculaAluno <- getLine
         putStrLn "Código do grupo?"
         codigo <- readLn :: IO Int
         resposta <- verificaAdmGrupo matricula codigo-- metodo que vai conferir se a pessoa q quer remover eh o adm
         if resposta then do
            resultado <- adicionarAluno matriculaAluno codigo
            putStrLn resultado
            else putStr "O aluno já está cadastrado."
         menuMeusGrupos matricula
    | op == 2 = do
        putStrLn "Matrícula do aluno a ser removido?"
        matriculaAlunoRemovido <- getLine
        putStrLn "Código do grupo?"
        idGrupo <- readLn :: IO Int
        result <- verificaAdmGrupo matricula idGrupo
        if result then do
            saida <- removerAlunoGrupo idGrupo matriculaAlunoRemovido
            print saida
        else
            putStrLn "Você nao é administrador do grupo."
        menuMeusGrupos matricula
    | op == 3 = do
        putStrLn "Digite o código do grupo para listar os alunos:"
        codGrupo <- readLn :: IO Int
        result <- listagemAlunoGrupo codGrupo-- toString dos alunos
        putStr result
        menuMeusGrupos matricula
    | op == 4 = do
        putStrLn "Código do grupo?"
        codGrupo <- readLn :: IO Int
        putStrLn "Qual o código da disciplina que você quer adicionar?"
        idDisciplina <- readLn:: IO Int
        putStrLn "Nome da disciplina?"
        nomeDisciplina <- getLine
        putStrLn "Qual professor ministra?"
        nomeProfessor <- getLine
        putStrLn "Período?"
        periodo <- getLine
        result <- cadastraDisciplina codGrupo idDisciplina nomeDisciplina nomeProfessor periodo
        if(result) then do
            putStrLn "Discplina Adicionada!"
            menuMeusGrupos matricula
        else do
            putStrLn "Erro...A Disciplina ja foi cadastrada"
            menuMeusGrupos matricula
    | op == 5 = do 
        putStrLn "Digite o código do grupo para listar as disciplinas do grupo"
        codGrupo <- readLn :: IO Int
        result <- listagemDisciplinaGrupo codGrupo matricula
        putStrLn result
        menuMeusGrupos matricula
    | op == 6 = do
        putStrLn "Remover disciplina de grupo:"
        putStrLn "Id da disciplina a ser removida?"
        idDisciplina <- readLn:: IO Int
        putStrLn "Codigo do grupo?"
        idGrupo <- readLn:: IO Int
        saida <- removerDisciplinaGrupo idGrupo idDisciplina 
        print saida
        menuMeusGrupos matricula
    | op == 7 = menuMateriaisGrupo matricula
    | op == 8 = do
        resultado <- listaGrupos matricula -- metodo pra listar os grupos existentes. é como um toString
        putStr resultado
        menuMeusGrupos matricula
    | op == 9 = menuInicial matricula
    | op == 10 = putStrLn "Saindo..."
    | otherwise = do
        putStrLn "Escolha inválida. Tente novamente."
        menuMeusGrupos matricula

-- Menu com as escolhas do material do grupo
menuMateriaisGrupo :: String -> IO ()
menuMateriaisGrupo matricula = do
    putStrLn "1. Ver materiais"
    putStrLn "2. Adicionar materiais"
    putStrLn "3. Remover materiais"
    putStrLn "4. Editar materiais"
    putStrLn "5. Voltar"
    op <- readLn :: IO Int
    selecionaMateriaisGrupo matricula op

selecionaMateriaisGrupo:: String -> Int -> IO()
selecionaMateriaisGrupo matricula op
   | op == 1 = menuSelecionaMaterial matricula
   | op == 2 = menuCadastraMateriaisGrupo matricula
{-   | op == 3 = menuRemoverMateriaisGrupo
   | op == 4 = menuEditarMateriaisGrupo-}
   | op == 5 = menuMeusGrupos matricula
   | otherwise = do
       putStrLn "Opção inválida! Tente novamente."
       menuMateriaisGrupo matricula

menuSelecionaMaterial:: String -> IO()
menuSelecionaMaterial matricula = do
    putStrLn "Você deseja ver qual material?"
    putStrLn "1. Resumo"
    putStrLn "2. Link Úteis"
    putStrLn "3. Datas Importantes"
    putStrLn "4. Voltar"
    putStrLn "5. teste"
    op <- readLn:: IO Int
    selecionaOpMaterial matricula op

selecionaOpMaterial:: String -> Int -> IO()
selecionaOpMaterial matricula op
    {-| op == 1 = do
        putStrLn "Qual id do grupo que desejas ver os Resumos?" 
        resposta <- readLn:: IO Int
        listaResumos resposta-}
    {-| op == 2 = do
        putStrLn "Qual id do grupo que desejas ver os Links?" 
        resposta <- readLn:: IO Int    
        listaLinks resposta-}
    {-| op == 3 = do
        putStrLn "Qual id do grupo que desejas ver as Datas Importantes?" 
        resposta <- readLn:: IO Int
        listaDatas resposta-}
    | op == 4 = menuMateriaisGrupo matricula
    | op == 5 = putStrLn "foi"
    | otherwise = do
        putStrLn "Opção inválida! Tente novamente."
        menuSelecionaMaterial matricula

menuCadastraMateriaisGrupo:: String -> IO()
menuCadastraMateriaisGrupo matricula = do
    putStrLn "\nSelecione o tipo de material que você gostaria de cadastrar:"
    putStrLn "1. Resumo"
    putStrLn "2. Links"
    putStrLn "3. Datas"
    putStrLn "4. Voltar"
    op <- readLn :: IO Int
    selecionaMenuCadastroMateriaisGrupo op matricula

selecionaMenuCadastroMateriaisGrupo:: Int -> String -> IO()
selecionaMenuCadastroMateriaisGrupo op matricula
    {-| op == 1 = do
        putStrLn "ID disciplina: \n"
        id <- readLn :: IO Int
        putStrLn "Nome do resumo: \n"
        nome <- getLine
        putStrLn "Conteudo do resumo: \n"
        conteudo <- getLine
        DisciplinaF.cadastraResumo matricula id nome conteudo
        putStrLn "Cadastrado com sucesso!\n"-}
    | op == 2 = do
        putStrLn "Id do grupo a ser adicionado o material?"
        idGrupo <- readLn :: IO Int
        putStrLn "ID disciplina a ser adicionado o link?"
        idDisciplina <- readLn :: IO Int
        putStrLn "ID do link?"
        idLink <- readLn :: IO Int
        putStrLn "Titulo do Link: "
        titulo <- getLine
        putStrLn "URL do link?"
        url <- getLine
        --resposta <- cadastraLink idGrupo idDisciplina idLink titulo url
        putStrLn "ok"
        menuSelecionaMaterial matricula
    -- | op == 3 = do
    --     putStrln "ID disciplina: "
    --     id <- readLn :: IO Int
    --     putStrLn "Titulo: "
    --     titulo <- getLine
    --     putStrLn "Data: "
    --     dt <- getLine
    --     cadastraData id titulo dt
    --     putStrLn "Cadastrado com sucesso"
    | op == 4 = menuSelecionaMaterial matricula
    | otherwise = do
        putStrLn "Opção inválida! Tente novamente."
        menuCadastraMateriaisGrupo matricula

-- Menu referente às disciplinas;
menuMinhasDisciplinas::String -> IO()
menuMinhasDisciplinas matricula = do
    putStrLn "1. Visualizar disciplinas"
    putStrLn "2. Cadastrar disciplina"
    putStrLn "3. Remover disciplina"
    putStrLn "4. Materiais"
    putStrLn "5. Voltar"
    putStrLn "6. Sair"
    op <- readLn :: IO Int
    selecionaMenuMinhasDisciplinas op matricula

-- Menu de seleção das ações da disciplina.
selecionaMenuMinhasDisciplinas:: Int -> String -> IO()
selecionaMenuMinhasDisciplinas op matricula
    | op == 1 = do 
        result <- listagemDisciplinaALuno matricula
        putStrLn result
        menuMinhasDisciplinas matricula

    | op == 2 = do
        putStrLn "Qual o código da disciplina que você quer adicionar?"
        id <- readLn:: IO Int
        putStrLn "Nome da disciplina?"
        nomeDisciplina <- getLine
        putStrLn "Qual professor ministra?"
        nomeProfessor <- getLine
        putStrLn "Período?"
        periodo <- getLine
        result <- adicionarDisciplina matricula id nomeDisciplina nomeProfessor periodo
        if(result) then
            putStrLn "Discplina Adicionada!"
        else
            putStrLn "Erro... A Disciplina ja foi cadastrada"
        menuMinhasDisciplinas matricula

    | op == 3 = do
         putStrLn "Qual o id da disciplina que você quer remover?"
         id <- readLn:: IO Int
         result <- removerDisciplinaAluno matricula id
         if(result) then
            putStrLn "Discplina Removida."
         else
            putStrLn "Erro...A Disciplina não existe!"
         menuMinhasDisciplinas matricula
    | op == 4 = menuMateriaisAluno matricula

    | op == 5 = do
        putStrLn "Voltando..."
        menuInicial matricula
    | op == 6 = putStrLn "Saindo..."

    | otherwise = do
        putStrLn "Escolha inválida. Tente novamente."
        menuMinhasDisciplinas matricula


menuMateriaisAluno :: String -> IO ()
menuMateriaisAluno matricula = do
    putStrLn "1. Ver materiais"
    putStrLn "2. Adicionar materiais"
    putStrLn "3. Remover materiais"
    putStrLn "4. Editar materiais"
    putStrLn "5. Voltar"
    putStrLn "6. Sair"
    op <- readLn :: IO Int
    selecionaMateriaisAluno matricula op

selecionaMateriaisAluno :: String -> Int -> IO ()
selecionaMateriaisAluno matricula op
    | op == 1 = menuConsultaAluno matricula
    | op == 2 = menuCadastraMateriaisAluno matricula
    -- | op == 3 = menuRemoverMateriais
    -- | op == 4 = menuEditaMaterias
    | op == 5 = do
        putStrLn "Voltando..."
        menuMinhasDisciplinas matricula
    | op == 6 =  putStrLn "Saindo..."
    | otherwise = do 
        putStrLn "Digite novamente" 
        selecionaMateriaisAluno matricula op


menuCadastraMateriaisAluno:: String -> IO()
menuCadastraMateriaisAluno matricula = do
    putStrLn "\nSelecione o tipo de material que você gostaria de cadastrar:"
    putStrLn "1. Resumo"
    putStrLn "2. Links"
    putStrLn "3. Datas"
    op <- readLn :: IO Int
    selecionaMenuCadastroMateriaisAluno op matricula

selecionaMenuCadastroMateriaisAluno:: Int -> String -> IO()
selecionaMenuCadastroMateriaisAluno op matricula
    | op == 1 = do
        putStrLn "ID disciplina:"
        idDisciplina <- readLn :: IO Int
        putStrLn "Nome do resumo:"
        nome <- getLine
        putStrLn "Conteudo do resumo:"
        conteudo <- getLine
        result <- cadastraResumoDisciplinaAluno idDisciplina matricula nome conteudo
        putStrLn result
    | op == 2 = do
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Titulo: "
        titulo <- getLine
        putStrLn "Link: "
        link <- getLine
        result <- cadastraLinkUtilDisciplinaAluno idDisciplina matricula titulo link
        putStrLn result
     | op == 3 = do
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Titulo: "
        titulo <- getLine
        putStrLn "Data Inicio: "
        dti <- getLine
        putStrLn "Data Fim: "
        dtf <- getLine
        result <- cadastraDataDisciplinaAluno idDisciplina matricula  titulo dti dtf
        putStrLn result
    | otherwise = do 
        putStrLn "Digite novamente" 
        selecionaMenuCadastroMateriaisAluno op matricula 
        
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

menuConsultaAluno::String -> IO()
menuConsultaAluno matricula = do
     putStrLn "Você deseja ver o material de qual disciplia? Informe o id"
     idDisciplina <- readLn::IO Int
     putStrLn "Qual o tipo de material?"
     putStrLn "1. Resumo"
     putStrLn "2. Links"
     putStrLn "3. Datas"
     op <- readLn :: IO Int
     selecionaMenuConsultaAluno matricula idDisciplina op
     

selecionaMenuConsultaAluno::String -> Int -> Int -> IO()
selecionaMenuConsultaAluno matricula idDisciplina op
    | op == 1 = do
        putStrLn "ID do Resumo? "
        idResumo <- getLine
        result <- showResumo matricula idDisciplina idResumo
        putStrLn result
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