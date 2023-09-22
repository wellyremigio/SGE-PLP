--Módulo responsável por receber a escolha inicial do usuário vinda no Main e redirecionar as operações para os módulos responsáveis.
-- Esse módulo também lê os dados do usuário.
module Menus where
import Function.AlunoFunction
import Function.GrupoFunction

-- Função que lê os dados de login do usuário.
menuLogin :: IO ()
menuLogin = do
    putStr "Matrícula: \n"
    matriculaInput <- getLine
    alunoCadastrado <- verificaLogin matriculaInput
    if not alunoCadastrado
        then do
            putStr "Cadastro não encontrado :/\n"
            menuEscolhaLogin
        else do
            putStr "Senha: \n"
            senhaInput <- getLine
            senhaCorreta <- verificaSenhaAluno matriculaInput senhaInput
            if not senhaCorreta
                then do
                    putStr "Senha incorreta! "
                    menuEscolhaLogin
                else do
                    menuInicial matriculaInput

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
    | op == 3 =  putStrLn "Voltar..."
    | otherwise = do 
        putStrLn "\nOpção inválida. Escolha corretamente."
        op <- readLn:: IO Int
        menuLogin

-- Função responsável pelo cadastro do usuário.
menuCadastro :: IO ()
menuCadastro = do
    putStr "\nMatrícula: \n"
    matriculaCadastrada <- getLine
    putStr "Nome: \n"
    nomeCadastrado <- getLine
    putStr "Senha: \n"
    senhaCadastrada <- getLine
    matriculaJaCadastrada <- verificaLogin matriculaCadastrada
    if matriculaJaCadastrada
        then do
            putStr "Aluno já cadastrado! "
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
    putStrLn "5- Procurar Grupo"
    putStrLn "6- Sair"
    op <- readLn :: IO Int
    selecaoMenuInicial op matricula

-- Responsável pela manipulação (leitura e redirecionamento) das escolhas referentes ao menuInicial.
selecaoMenuInicial:: Int -> String -> IO()
selecaoMenuInicial op matricula
    | op == 1 = do
        putStrLn "\n==Cadastrando Grupo=="
        putStrLn "Nome do grupo: "
        nomeGrupo <- getLine
        putStrLn "Codigo do grupo: "
        codigo <- readLn :: IO Int
        resposta <- verificaIdGrupo codigo
        if not resposta then do 
            cadastraGrupo nomeGrupo codigo matricula
            putStr "Grupo cadastrado com sucesso! "
            menuInicial matricula
        else do 
            putStrLn "Já existe um grupo com esse ID. Cadastre um grupo novo!\n"
            menuInicial matricula
    | op == 2 = do
        putStrLn "\n==Removendo Grupo=="
        putStrLn "Id do grupo: "
        idGrupo <- readLn :: IO Int
        ehAdm <- verificaAdmGrupo idGrupo matricula
        if(ehAdm) then do
            resultado <- removeGrupo idGrupo
            print resultado
        else
            putStrLn "Você nao é Adm do grupo"
        menuInicial matricula
    | op == 3 = do
        menuMeusGrupos matricula 
    | op == 4 = menuMinhasDisciplinas matricula

    | op == 5 = do
        result <- listagemDeGruposEmComum matricula
        putStr result
    | op == 6 = putStrLn "Saindo...\n"
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
    op <- readLn:: IO Int
    selecaoMenuMeusGrupos op matricula

-- Recebe a escolha do usuário e redireciona.
selecaoMenuMeusGrupos::  Int -> String -> IO()
selecaoMenuMeusGrupos op matricula
    | op == 1 = do
         putStrLn "\nMatrícula do aluno a ser adicionado?"
         matriculaAluno <- getLine
         putStrLn "Código do grupo?"
         codigo <- readLn :: IO Int
         resposta <- verificaAdmGrupo codigo matricula
         if resposta then do
            resultado <- adicionarAluno matriculaAluno codigo
            putStrLn resultado
            else putStr "O aluno já está cadastrado."
         menuMeusGrupos matricula
    | op == 2 = do
        putStrLn "\nMatrícula do aluno a ser removido?"
        matriculaAlunoRemovido <- getLine
        putStrLn "Código do grupo?"
        idGrupo <- readLn :: IO Int
        result <- verificaAdmGrupo idGrupo matricula
        if result then do
            saida <- removerAlunoGrupo idGrupo matriculaAlunoRemovido
            print saida
        else
            putStrLn "Você nao é administrador do grupo."
        menuMeusGrupos matricula
    | op == 3 = do
        putStrLn "\nDigite o código do grupo para listar os alunos:"
        codGrupo <- readLn :: IO Int
        result <- listagemAlunoGrupo codGrupo-- toString dos alunos
        putStr result
        menuMeusGrupos matricula
    | op == 4 = do
        putStrLn "\nCódigo do grupo?"
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
        putStrLn "\nDigite o código do grupo para listar as disciplinas do grupo"
        codGrupo <- readLn :: IO Int
        result <- listagemDisciplinaGrupo codGrupo matricula
        putStrLn result
        menuMeusGrupos matricula
    | op == 6 = do
        putStrLn "\nRemover disciplina de grupo:"
        putStrLn "Id da disciplina a ser removida?"
        idDisciplina <- readLn:: IO Int
        putStrLn "Codigo do grupo?"
        idGrupo <- readLn:: IO Int
        saida <- removerDisciplinaGrupo idGrupo idDisciplina 
        print saida
        menuMeusGrupos matricula
    | op == 7 = menuMateriaisGrupo matricula
    | op == 8 = do
        putStrLn "\nEsses são os seus grupos: \n"
        resultado <- listaGrupos matricula
        putStr resultado
        menuMeusGrupos matricula
    | op == 9 = menuInicial matricula
    | otherwise = do
        putStrLn "\nEscolha inválida. Tente novamente."
        menuMeusGrupos matricula

-- Menu com as escolhas do material do grupo
menuMateriaisGrupo :: String -> IO ()
menuMateriaisGrupo matricula = do
    putStrLn "\n1. Ver materiais"
    putStrLn "2. Adicionar materiais"
    putStrLn "3. Remover materiais"
    putStrLn "4. Editar materiais"
    putStrLn "5. Comentar no material"
    putStrLn "6. Ver Comentarios do material"
    putStrLn "7. Voltar"
    op <- readLn :: IO Int
    selecionaMateriaisGrupo matricula op

    -- Recebe a escolha do usuário e redireciona.
selecionaMateriaisGrupo:: String -> Int -> IO()
selecionaMateriaisGrupo matricula op
    | op == 1 = menuSelecionaMaterial matricula
    | op == 2 = menuCadastraMateriaisGrupo matricula
    | op == 3 = menuRemoverMateriaisGrupo matricula
    | op == 4 = menuEditaMateriais matricula
    | op == 5 = menuComentarMaterial matricula
    | op == 6 = menuVerComentarioMaterial matricula
    | op == 7 = menuMeusGrupos matricula
    | otherwise = do
       putStrLn "Opção inválida! Tente novamente."
       menuMateriaisGrupo matricula

menuVerComentarioMaterial :: String -> IO()
menuVerComentarioMaterial matricula = do
    putStrLn "\nVocê deseja ver os comentários de qual material?"
    putStrLn "1. Resumo"
    putStrLn "2. Link Util"
    putStrLn "3. Data"
    putStrLn "4. Voltar"
    putStrLn "5. Sair"
    op <- readLn:: IO Int
    selecionaVerComentarioMaterial matricula op

selecionaVerComentarioMaterial :: String -> Int -> IO ()
selecionaVerComentarioMaterial matricula op
    | op == 1 = do
        putStrLn "\nID grupo? "
        idGrupo <- readLn :: IO Int
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "ID Resumo: "
        idResumo <- getLine
        result <- verComentariosResumo idGrupo idDisciplina idResumo matricula
        putStrLn result
        menuVerComentarioMaterial matricula
    | op == 2 = do
        putStrLn "\nID grupo? "
        idGrupo <- readLn :: IO Int
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "ID Link Util: "
        idLinkUtil <- getLine
        result <- verComentariosLinkUtil idGrupo idDisciplina idLinkUtil matricula
        putStrLn result
        menuVerComentarioMaterial matricula
    | op == 3 = do
        putStrLn "\nID grupo? "
        idGrupo <- readLn :: IO Int
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "ID Data: "
        idData <- getLine
        result <-  verComentariosData idGrupo idDisciplina idData matricula
        putStrLn result
        menuVerComentarioMaterial matricula
    
    | op == 4 = do
        putStrLn "Voltando"
        menuMateriaisGrupo matricula
    |  op == 5 = putStrLn "Saindo..."

    | otherwise = do
        putStrLn "Opção inválida! Tente novamente."
        menuVerComentarioMaterial matricula


-- Menu com as escolhas do comentario do material
menuComentarMaterial :: String -> IO()
menuComentarMaterial matricula = do
    putStrLn "\nVocê deseja comentar qual material?"
    putStrLn "1. Resumo"
    putStrLn "2. Link Util"
    putStrLn "3. Data"
    putStrLn "4. Voltar"
    putStrLn "5. Sair"
    op <- readLn:: IO Int
    selecionaMaterialComentario matricula op


-- Recebe a escolha do usuário e redireciona.
selecionaMaterialComentario :: String -> Int -> IO ()
selecionaMaterialComentario matricula op
    | op == 1 = do
        putStrLn "\nID grupo? "
        idGrupo <- readLn :: IO Int
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "ID Resumo: "
        idResumo <- getLine
        putStrLn "Comentario a ser enviado: "
        comentario <- getLine
        result <- adicionarComentarioResumoDisciplinaDoGrupo idGrupo idDisciplina matricula idResumo comentario
        putStrLn result
        menuComentarMaterial matricula
    | op == 2 = do
        putStrLn "\nID grupo? "
        idGrupo <- readLn :: IO Int
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "ID Link Util: "
        idLinkUtil <- getLine
        putStrLn "Comentario a ser enviado: "
        comentario <- getLine
        result <- adicionarComentarioLinkUtilDisciplinaDoGrupo idGrupo idDisciplina matricula idLinkUtil comentario
        putStrLn result
        menuComentarMaterial matricula

    | op == 3 = do
        putStrLn "\nID grupo? "
        idGrupo <- readLn :: IO Int
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "ID data: "
        idData <- getLine
        putStrLn "Comentario a ser enviado: "
        comentario <- getLine
        result <- adicionarComentarioDataDisciplinaDoGrupo  idGrupo idDisciplina matricula idData comentario
        putStrLn result
        menuComentarMaterial matricula

    | op == 4 = do
        putStrLn "Voltando"
        menuMateriaisGrupo matricula    
    |  op == 5 = putStrLn "Saindo..."

    | otherwise = do
        putStrLn "Opção inválida! Tente novamente."
        menuComentarMaterial matricula

--Menu para o usuário escolher qual material quer ver 
menuSelecionaMaterial:: String -> IO()
menuSelecionaMaterial matricula = do
    putStrLn "\nVocê deseja ver o material de qual disciplina? Informe o id"
    idDisciplina <- readLn::IO Int
    putStrLn "Id grupo: "
    idGrupo <- readLn::IO Int
    putStrLn "1. Resumo"
    putStrLn "2. Link Úteis"
    putStrLn "3. Datas Importantes"
    putStrLn "4. Voltar"
    op <- readLn:: IO Int
    selecionaOpMaterial matricula op idDisciplina  idGrupo
-- Recebe a escolha do usuário e redireciona.
selecionaOpMaterial:: String -> Int -> Int -> Int -> IO()
selecionaOpMaterial matricula op idDisciplina  idGrupo 
    | op == 1 = do
        putStrLn "\nQual codigo do resumo: " 
        idResumo <- getLine
        saida <- showResumoGrupo idGrupo idDisciplina idResumo
        putStrLn saida
        menuMateriaisGrupo  matricula
    | op == 2 = do
        putStrLn "\nQual codigo do link: " 
        idResumo <- getLine
        saida <- showLinkUtilGrupo idGrupo idDisciplina idResumo
        putStrLn saida
        menuMateriaisGrupo  matricula
    | op == 3 = do
        putStrLn "\nQual codigo da data: " 
        idResumo <- getLine
        saida <- showDataGrupo idGrupo idDisciplina idResumo
        putStrLn saida
        menuMateriaisGrupo  matricula
    | op == 4 = menuMateriaisGrupo matricula
    | otherwise = do
        putStrLn "Opção inválida! Tente novamente."
        menuSelecionaMaterial matricula   

--Menu para fazer o cadastro de materiais em grupo
menuCadastraMateriaisGrupo:: String -> IO()
menuCadastraMateriaisGrupo matricula = do
    putStrLn "\nSelecione o tipo de material que você gostaria de cadastrar:"
    putStrLn "1. Resumo"
    putStrLn "2. Links"
    putStrLn "3. Datas"
    putStrLn "4. Voltar"
    op <- readLn :: IO Int
    selecionaMenuCadastroMateriaisGrupo op matricula


-- Recebe a escolha do usuário e redireciona.
selecionaMenuCadastroMateriaisGrupo:: Int -> String -> IO()
selecionaMenuCadastroMateriaisGrupo op matricula
    | op == 1 = do
        putStrLn "\nId do grupo a ser adicionado o material? \n"
        idGrupo <- readLn :: IO Int
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Nome do resumo: "
        tituloResumo <- getLine
        putStrLn "Conteudo do resumo: "
        conteudo <- getLine
        resposta <- cadastraResumo idGrupo idDisciplina tituloResumo conteudo
        putStrLn resposta
        menuCadastraMateriaisGrupo matricula
    | op == 2 = do
        putStrLn "\nId do grupo a ser adicionado o material? "
        idGrupo <- readLn :: IO Int
        putStrLn "ID disciplina a ser adicionado o link? "
        idDisciplina <- readLn :: IO Int
        putStrLn "Titulo do Link: "
        titulo <- getLine
        putStrLn "URL do link? "
        url <- getLine
        resposta <- cadastraLink idGrupo idDisciplina titulo url
        putStrLn resposta
        menuCadastraMateriaisGrupo matricula
     | op == 3 = do
        putStrLn "\nId do grupo a ser adicionado o material? "
        idGrupo <- readLn :: IO Int
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Data início (dd/mm/aa): "
        dataInicio <- getLine
        putStrLn "Data fim (dd/mm/aa): "
        dataFim <- getLine
        putStrLn "Tag: "
        tag <- getLine
        resposta <- cadastraData idGrupo idDisciplina tag dataInicio dataFim 
        putStrLn resposta
        menuCadastraMateriaisGrupo matricula
    | op == 4 = menuMateriaisGrupo matricula
    | otherwise = do
        putStrLn "Opção inválida! Tente novamente. \n"
        menuCadastraMateriaisGrupo matricula

-- Menu que mostra ao usuário as opções de remoção dos materiais
menuRemoverMateriaisGrupo:: String -> IO()
menuRemoverMateriaisGrupo matricula = do
    putStrLn "\nSelecione o tipo de material que você gostaria de remover:"
    putStrLn "1. Resumo"
    putStrLn "2. Links"
    putStrLn "3. Datas"
    op <- readLn :: IO Int
    selecionaMenuRemoveMateriaisGrupo op matricula

-- Redireciona a escolha do usuário aos métodos competentes.
selecionaMenuRemoveMateriaisGrupo:: Int -> String -> IO() --  idDisciplina matricula chaveResumo
selecionaMenuRemoveMateriaisGrupo op matricula
    | op == 1 = do
        putStrLn "\nCodigo grupo:"
        codigoGrupo <- readLn :: IO Int
        putStrLn "ID disciplina:"
        idDisciplina <- readLn :: IO Int
        putStrLn "Chave resumo:"
        chaveResumo <- getLine
        result <-  removeMateriaisDisciplinaGrupo  "resumo" idDisciplina codigoGrupo chaveResumo
        putStrLn result
        menuMateriaisAluno  matricula
    | op == 2 = do
        putStrLn "\nCodigo grupo:"
        codigoGrupo <- readLn :: IO Int
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Chave link: "
        chaveLink <- getLine
        result <- removeMateriaisDisciplinaGrupo  "link" idDisciplina codigoGrupo chaveLink
        putStrLn result
        menuMateriaisAluno  matricula
     | op == 3 = do
        putStrLn "\nCodigo grupo:"
        codigoGrupo <- readLn :: IO Int
        putStrLn "ID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Chave data: "
        chaveData <- getLine
        result <- removeMateriaisDisciplinaGrupo "data" idDisciplina codigoGrupo chaveData
        putStrLn result
        menuMateriaisAluno  matricula
    | otherwise = do
        putStrLn "\nDigite novamente" 
        selecionaMenuRemoveMateriaisAluno op matricula


-- Menu referente às disciplinas;
menuMinhasDisciplinas::String -> IO()
menuMinhasDisciplinas matricula = do
    putStrLn "\n1. Visualizar disciplinas"
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
        putStrLn "\nQual o código da disciplina que você quer adicionar?"
        id <- readLn:: IO Int
        putStrLn "Nome da disciplina?"
        nomeDisciplina <- getLine
        putStrLn "Qual professor ministra?"
        nomeProfessor <- getLine
        putStrLn "Período?"
        periodo <- getLine
        result <- adicionarDisciplina matricula id nomeDisciplina nomeProfessor periodo
        if(result) then
            putStrLn "Disciplina Adicionada!"
        else
            putStrLn "Erro... A Disciplina ja foi cadastrada"
        menuMinhasDisciplinas matricula
    | op == 3 = do
         putStrLn "\nQual o id da disciplina que você quer remover?"
         id <- readLn:: IO Int
         result <- removerDisciplinaAluno matricula id
         if(result) then
            putStrLn "Discplina Removida."
         else
            putStrLn "Erro...A Disciplina não existe!"
         menuMinhasDisciplinas matricula
    | op == 4 = menuMateriaisAluno matricula
    | op == 5 = do
        putStrLn "\nVoltando..."
        menuInicial matricula
    | op == 6 = putStrLn "Saindo..."
    | otherwise = do
        putStrLn "\nEscolha inválida. Tente novamente."
        menuMinhasDisciplinas matricula

-- Menu referente aos materiais do aluno
menuMateriaisAluno :: String -> IO ()
menuMateriaisAluno matricula = do
    putStrLn "\n1. Ver materiais"
    putStrLn "2. Adicionar materiais"
    putStrLn "3. Remover materiais"
    putStrLn "4. Voltar"
    putStrLn "5. Sair"
    op <- readLn :: IO Int
    selecionaMateriaisAluno matricula op

-- Recebe a escolha do usuário e redireciona.
selecionaMateriaisAluno :: String -> Int -> IO ()
selecionaMateriaisAluno matricula op
    | op == 1 = menuConsultaAluno matricula
    | op == 2 = menuCadastraMateriaisAluno matricula
    | op == 3 = menuRemoverMateriais matricula
    | op == 4 = do
        putStrLn "Voltando..."
        menuMinhasDisciplinas matricula
    | op == 5 =  putStrLn "Saindo..."
    | otherwise = do 
        putStrLn "Escolha inválida. Tente novamente." 
        menuMateriaisAluno matricula

-- Menu para o usuário cadastrar materiais em aluno
menuCadastraMateriaisAluno:: String -> IO()
menuCadastraMateriaisAluno matricula = do
    putStrLn "\nSelecione o tipo de material que você gostaria de cadastrar:"
    putStrLn "1. Resumo"
    putStrLn "2. Links"
    putStrLn "3. Datas"
    op <- readLn :: IO Int
    selecionaMenuCadastroMateriaisAluno op matricula


-- Recebe a escolha do usuário e redireciona.
selecionaMenuCadastroMateriaisAluno:: Int -> String -> IO()
selecionaMenuCadastroMateriaisAluno op matricula
    | op == 1 = do
        putStrLn "\nID disciplina:"
        idDisciplina <- readLn :: IO Int
        putStrLn "Nome do resumo:"
        nome <- getLine
        putStrLn "Conteudo do resumo:"
        conteudo <- getLine
        result <- cadastraResumoDisciplinaAluno idDisciplina matricula nome conteudo
        putStrLn result
        menuMateriaisAluno matricula
    | op == 2 = do
        putStrLn "\nID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Titulo: "
        titulo <- getLine
        putStrLn "Link: "
        link <- getLine
        result <- cadastraLinkUtilDisciplinaAluno idDisciplina matricula titulo link
        putStrLn result
        menuMateriaisAluno matricula
     | op == 3 = do
        putStrLn "\nID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Titulo: "
        titulo <- getLine
        putStrLn "Data Inicio: "
        dti <- getLine
        putStrLn "Data Fim: "
        menuMateriaisAluno matricula
        dtf <- getLine
        result <- cadastraDataDisciplinaAluno idDisciplina matricula  titulo dti dtf
        putStrLn result
        menuMateriaisAluno matricula
    | otherwise = do 
        putStrLn "\nEscolha inválida. Tente novamente." 
        selecionaMenuCadastroMateriaisAluno op matricula 

-- Menu referente a remoção de algum material
menuRemoverMateriais:: String -> IO()
menuRemoverMateriais matricula = do
    putStrLn "\nSelecione o tipo de material que você gostaria de remover:"
    putStrLn "1. Resumo"
    putStrLn "2. Links"
    putStrLn "3. Datas"
    op <- readLn :: IO Int
    selecionaMenuRemoveMateriaisAluno op matricula

-- Recebe a escolha do usuário e redireciona.
selecionaMenuRemoveMateriaisAluno:: Int -> String -> IO() --  idDisciplina matricula chaveResumo
selecionaMenuRemoveMateriaisAluno op matricula
    | op == 1 = do
        putStrLn "\nID disciplina:"
        idDisciplina <- readLn :: IO Int
        putStrLn "Chave resumo:"
        chaveResumo <- getLine
        result <-  removeMateriaisDisciplinaAluno  "resumo" idDisciplina matricula chaveResumo
        putStrLn result
        menuMateriaisAluno  matricula
    | op == 2 = do
        putStrLn "\nID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Chave link: "
        chaveLink <- getLine
        result <- removeMateriaisDisciplinaAluno  "link" idDisciplina matricula chaveLink
        putStrLn result
        menuMateriaisAluno  matricula
     | op == 3 = do
        putStrLn "\nID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Chave data: "
        chaveData <- getLine
        result <- removeMateriaisDisciplinaAluno  "data" idDisciplina matricula chaveData
        putStrLn result
        menuMateriaisAluno  matricula
    | otherwise = do
        putStrLn "\nDigite novamente" 
        selecionaMenuRemoveMateriaisAluno op matricula

-- Menu para escolha do material a ser editado.
menuEditaMateriais:: String -> IO()
menuEditaMateriais matricula = do
    putStrLn "\nQual codigo do grupo: "
    idGrupo <- readLn :: IO Int
    putStrLn "\nQual codigo da disciplina: \n"
    idDisciplina <- readLn :: IO Int
    putStrLn "\nCodigo do resumo: "
    chave <- getLine
    putStrLn "\nNovo corpo do resumo: "
    corpo <- getLine
    saida <- editaCorpoResumo  idDisciplina idGrupo chave corpo
    putStrLn saida
    menuMateriaisGrupo matricula

-- Menu para o usuário ver o material de um aluno
menuConsultaAluno::String -> IO()
menuConsultaAluno matricula = do
     putStrLn "\nId disciplina: "
     idDisciplina <- readLn::IO Int
     putStrLn "Qual o tipo de material?"
     putStrLn "1. Resumo"
     putStrLn "2. Links"
     putStrLn "3. Datas"
     putStrLn "4. Voltar"
     putStrLn "5. Sair"
     op <- readLn :: IO Int
     selecionaMenuConsultaAluno matricula idDisciplina op

-- Recebe a escolha do usuário e redireciona.
selecionaMenuConsultaAluno::String -> Int -> Int -> IO()
selecionaMenuConsultaAluno matricula idDisciplina op
    | op == 1 = do
        putStrLn "\nID do Resumo:"
        idResumo <- getLine
        result <- showResumo matricula idDisciplina idResumo
        putStrLn result
        menuMateriaisAluno matricula
    | op == 2 = do
        putStrLn "\nID LinkUtil:"
        idLinkUtil <- getLine
        result <- showLinkUtil matricula idDisciplina idLinkUtil
        putStrLn result
        menuMateriaisAluno matricula
     | op == 3 = do
         putStrLn "\nID Data:"
         idData <- getLine
         result <- showData matricula idDisciplina idData
         putStrLn result
         menuMateriaisAluno matricula
    | op == 4 = do
        putStrLn "\nVoltando..."
        menuMinhasDisciplinas matricula
    | op == 5 = putStrLn "Saindo..."
    | otherwise = do 
        putStrLn "\nOpção Inválida, Redirecionado para a seleção do material a ser cadastrado!"
        menuCadastraMateriaisAluno matricula
