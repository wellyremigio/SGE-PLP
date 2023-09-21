
-- Módulo responsável pelas funções cabíveis aos Grupos.
module Function.GrupoFunction where
import Model.Aluno
import Model.Grupo
import Model.Disciplina
import Model.Data
import Model.Resumo
import Model.LinkUtil
import Model.Comentario
import Function.AlunoFunction(disciplinaExiste)
import DataBase.Gerenciador.GrupoGerenciador as G
import DataBase.Gerenciador.AlunoGerenciador as A
import Data.List
import Data.List (elem)
import System.Random
import Data.Char (isAlpha, isAlphaNum, toLower)
import Function.AlunoFunction (generateID)
import Function.AlunoFunction (removerResumoNaDisciplina)
import Function.AlunoFunction (removerLinkNaDisciplina)
import Function.AlunoFunction (removerDataNaDisciplina)
import Function.AlunoFunction (getResumo)
import Function.AlunoFunction (getLinkUtil)
import Function.AlunoFunction (getData)
import Function.AlunoFunction (encontrarDisciplinaPorID)


-- Recebe nome, código e matrícula do adm do grupo e o adiciona ao banco de dados.
cadastraGrupo :: String -> Int -> String -> IO String
cadastraGrupo nomeGrupo  codigo  matAdm = do
    saveGrupo nomeGrupo  codigo  matAdm
    adicionarAluno matAdm codigo
    return "Grupo cadastrado com sucesso!\n"

-- Verifica se o não há um grupo cadastrado com o mesmo id.
verificaIdGrupo :: Int -> IO Bool
verificaIdGrupo codigo = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let grupos = getGruposByCodigo codigo listaGrupos
    return $ Model.Grupo.codigo grupos /= (-1)

-- Verifica quem é o adm do grupo.
verificarAdmDeGrupo :: Int -> String -> IO Bool
verificarAdmDeGrupo codigoGrupo admDesejado = do
    codigoValido <- verificaIdGrupo codigoGrupo
    if codigoValido
        then do
            listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
            let grupo = getGruposByCodigo codigoGrupo listaGrupos
            return $ adm grupo == admDesejado
        else
            return False
            
-- Remove um grupo do banco de dados.
removeGrupo:: Int -> IO String
removeGrupo idGrupo = do
    verifica <- verificaIdGrupo idGrupo 
    if (verifica) then do
        grupos <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
        let removida = removeGrupoByCodigo idGrupo grupos
        if (length removida == length grupos) then return "Não foi possivel realizar ação" else do
            saveAlteracoesGrupo removida
            return "Remocao feita com sucesso"
    else
        return "Nao foi possivel realizar acao"

-- Faz a listagem dos grupos que o aluno faz parte
listaGrupos :: String -> IO String
listaGrupos matriculaProcurada = do
    gruposDoAluno <- getGruposDoAluno matriculaProcurada
    return $ organizaListagem gruposDoAluno

-- Função genérica que organiza, com base no Show de cada Model, os modelos.
organizaListagem :: Show t => [t] -> String
organizaListagem [] = ""
organizaListagem (x:xs) = show x ++ "\n" ++ organizaListagem xs

-- Função repetida. Não apaguei pq nao sei qual é a certa.
verificaAdmGrupo :: String -> Int -> IO Bool
verificaAdmGrupo matricula codigoGrupo  = do
    grupos <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
    return $ case find (\grupo -> codigo grupo == codigoGrupo) grupos of
        Just grupo -> adm grupo == matricula
        Nothing -> False


-- Verifica se o grupo tem o aluno.
grupoContainsAluno :: Grupo -> Aluno -> Bool
grupoContainsAluno grupo alunoProcurado = elem alunoProcurado (getAlunos grupo)

-- Adiciona um aluno ao grupo
adicionarAluno :: String -> Int -> IO String
adicionarAluno matricula codGrupo = do
    grupoList <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
    alunoList <- A.getAlunoJSON "src/DataBase/Data/Aluno.json"
    let grupo = G.getGruposByCodigo codGrupo grupoList
    let aluno = A.getAlunoByMatricula matricula alunoList
    if grupoContainsAluno grupo aluno
        then return "Aluno já está cadastrado no grupo"
        else do
            grupoAtualizado <- adicionarAlunoLista aluno codGrupo
            return "Aluno adicionado com sucesso"

listaDeGruposEmComum :: [Disciplina] -> [Grupo] -> [Grupo]
listaDeGruposEmComum disciplinasAluno grupos =
    filter (\grupo -> any (\disciplinaGrupo -> any (\disciplinaAluno -> disciplinaGrupo == disciplinaAluno) disciplinasAluno) (getDisciplinasGrupo grupo)) grupos

gruposDisciplinasEmComum :: String -> IO [Grupo]
gruposDisciplinasEmComum matriculaAluno = do
    alunoDisciplinas <- A.getDisciplinasAluno matriculaAluno
    grupos <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
    return (listaDeGruposEmComum alunoDisciplinas grupos)    
    
listagemDeGruposEmComum :: String -> IO String
listagemDeGruposEmComum idAluno = do
    grupos <- gruposDisciplinasEmComum idAluno
    if null grupos
        then return "Não existem grupos que tenham disciplinas em comum com as que você está cursando."
        else return ("Esses são os grupos em comum com as disciplinas que está cursando:\n" ++ organizaListagem grupos)

listagemAlunoGrupo :: Int -> IO String
listagemAlunoGrupo codGrupo = do 
    alunosGrupo <- G.getAlunoGrupo codGrupo
    if null alunosGrupo then 
        return "Não há alunos cadastrados nesse grupo!"
    else 
        return $ organizaListagem alunosGrupo


removerAlunoGrupo ::  Int -> String -> IO String
removerAlunoGrupo idGrupo matricula  = do
    grupos <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
    alunoList <- A.getAlunoJSON "src/DataBase/Data/Aluno.json"
    let grupo = G.getGruposByCodigo idGrupo grupos
    let aluno = A.getAlunoByMatricula matricula alunoList
    if grupoContainsAluno grupo aluno then do
        let alunosAtualizadas = removeAlunoPorID matricula (alunos grupo)

        let novoGrupo = grupo { Model.Grupo.alunos = alunosAtualizadas }
        let gruposAtualizados = G.removeGrupoByCodigo idGrupo grupos
        let newListGrupo = novoGrupo: gruposAtualizados
        G.saveAlteracoesAluno newListGrupo
        return "foi removida com sucesso"
    else
        return " não foi encontrada ou não foi removida"
        

removeAlunoPorID :: String -> [Aluno] -> [Aluno]
removeAlunoPorID _ [] = [] -- Caso base: a lista de alunos está vazia, não há nada a fazer
removeAlunoPorID idToRemove alunos =
    deleteBy (\aluno1 aluno2 -> Model.Aluno.matricula aluno1 == Model.Aluno.matricula aluno2)
             (Aluno idToRemove "" "" []) alunos


verificaDisciplina :: Int -> [Disciplina] -> Bool
verificaDisciplina idDisciplina disciplinas = any (\disciplina -> Model.Disciplina.id disciplina == idDisciplina) disciplinas

cadastraDisciplina :: Int -> Int-> String -> String -> String -> IO Bool
cadastraDisciplina codGrupo idDisciplina nome professor periodo = do
     listaGrupos <- G.getGruposJSON "src/DataBase/Data/Grupo.json" 
     let grupoExistente = G.getGruposByCodigo codGrupo listaGrupos
     let disciplinaNova = Disciplina idDisciplina nome professor periodo [] [] []
     let disciplinaExiste = verificaDisciplina idDisciplina (Model.Grupo.disciplinas grupoExistente)
     
     if not disciplinaExiste then do
        let disciplinasExistente = Model.Grupo.disciplinas grupoExistente
        let novoGrupo = grupoExistente { Model.Grupo.disciplinas = disciplinasExistente ++ [disciplinaNova] }
        gruposAtualizados <- G.removeGrupoByCodigoIO codGrupo
        let newListGrupo = gruposAtualizados ++ [novoGrupo]
        G.saveAlteracoesGrupo newListGrupo
        return True
     else 
        return False

-- Função para remover uma disciplina por ID
removeDisciplinaPorID :: Int -> [Disciplina] -> [Disciplina]
removeDisciplinaPorID _ [] = [] -- Caso base: a lista está vazia, não há nada a fazer
removeDisciplinaPorID idToRemove disciplinas = deleteBy (\disciplina1 disciplina2 -> Model.Disciplina.id disciplina1 == Model.Disciplina.id disciplina2) (Disciplina idToRemove "" "" "" [] [] []) disciplinas

removerDisciplinaGrupo ::  Int -> Int -> IO String
removerDisciplinaGrupo idGrupo idDisciplina   = do
    grupos <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
    let grupo = G.getGruposByCodigo idGrupo grupos
    let grupoContainsDisciplina = verificaDisciplina idDisciplina (Model.Grupo.disciplinas grupo)
    if grupoContainsDisciplina then do
        let disciplinasAtualizadas = removeDisciplinaPorID idDisciplina (Model.Grupo.disciplinas grupo)
        let novoGrupo = grupo { Model.Grupo.disciplinas = disciplinasAtualizadas }
        let gruposAtualizados = G.removeGrupoByCodigo idGrupo grupos
        let newListGrupo = novoGrupo: gruposAtualizados
        G.saveAlteracoesAluno newListGrupo
        return "foi removida com sucesso"
    else
        return " não foi encontrada ou não foi removida"

listagemDisciplinaGrupo :: Int -> String -> IO String
listagemDisciplinaGrupo codigoGrupo matricula = do
    grupoList <- getGruposJSON "src/DataBase/Data/Grupo.json"
    alunoList <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    
    let grupo = getGruposByCodigo codigoGrupo grupoList
    let aluno = getAlunoByMatricula matricula alunoList
    
    let alunoPertenceAoGrupo = grupoContainsAluno grupo aluno

    case (Model.Grupo.nome grupo, alunoPertenceAoGrupo) of
        ("", _) -> return "Grupo Inválido!"
        (_, False) -> return "Você não está nesse Grupo!"
        (_, _) -> do
            let disciplinasGrupo = getDisciplinasGrupo grupo
            if null disciplinasGrupo
                then return "Nenhuma disciplina cadastrada!"
                else return (organizaListagem disciplinasGrupo)


listaDisciplinaGrupo :: Int -> String -> IO String
listaDisciplinaGrupo codigoGrupo matricula = do
    grupoList <- getGruposJSON "src/DataBase/Data/Grupo.json"
    alunoList <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    
    let grupo = getGruposByCodigo codigoGrupo grupoList
    let aluno = getAlunoByMatricula matricula alunoList
    
    case (Model.Grupo.codigo grupo) of
        (-1) -> return "Grupo Inválido!"
        (_) -> do
            let disciplinasGrupo = getDisciplinasGrupo grupo
            if null disciplinasGrupo
                then return "Nenhuma disciplina cadastrada!"
                else return (organizaListagem disciplinasGrupo)


atualizarGrupo :: Int -> [Grupo] -> Grupo -> [Grupo]
atualizarGrupo _ [] _ = []
atualizarGrupo idGrupo (grupo:outrosGrupos) grupoAtualizado
    | Model.Grupo.codigo grupo == idGrupo =
        grupoAtualizado : outrosGrupos
    | otherwise =
        grupo : atualizarGrupo idGrupo outrosGrupos grupoAtualizado


cadastraLink :: Int -> Int -> String ->  String -> IO String
cadastraLink  idGrupo idDisciplina titulo url = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let grupoExistente = getGruposByCodigo idGrupo listaGrupos
    let possuiDisciplina = verificaDisciplina idDisciplina (Model.Grupo.disciplinas grupoExistente)

    if possuiDisciplina then do
        idLinkUtil <- generateID 'l'
        let linkUtil = LinkUtil idLinkUtil titulo url []
        let disciplinasAtuais = Model.Grupo.disciplinas grupoExistente
        let disciplinaAtualizada = adicionarLinkUtilNaDisciplina idDisciplina disciplinasAtuais linkUtil
        let grupoAtualizado = grupoExistente { Model.Grupo.disciplinas = disciplinaAtualizada }
        let gruposAtualizados = atualizarGrupo idGrupo listaGrupos grupoAtualizado
        saveAlteracoesGrupo gruposAtualizados
        return ("Link Util Adicionado! ID Link Util: " ++ show idLinkUtil)
    else
        return "Disciplina Não existe"

adicionarLinkUtilNaDisciplina :: Int -> [Disciplina] -> LinkUtil -> [Disciplina]
adicionarLinkUtilNaDisciplina _ [] _ = []
adicionarLinkUtilNaDisciplina idDisciplina (disciplina:outrasDisciplinas) linkUtil
    | Model.Disciplina.id disciplina == idDisciplina =
        disciplina { links = linkUtil : links disciplina } : outrasDisciplinas
    | otherwise =
        disciplina : adicionarLinkUtilNaDisciplina idDisciplina outrasDisciplinas linkUtil 


cadastraResumo :: Int -> Int -> String -> String -> IO String
cadastraResumo  idGrupo idDisciplina titulo corpo = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let grupoExistente = getGruposByCodigo idGrupo listaGrupos
    let possuiDisciplina = verificaDisciplina idDisciplina (Model.Grupo.disciplinas grupoExistente)

    if possuiDisciplina then do
        idResumo <- generateID 'r'
        let resumo = Resumo idResumo titulo corpo []
        let disciplinasAtuais = Model.Grupo.disciplinas grupoExistente
        let disciplinaAtualizada = adicionarResumoNaDisciplina idDisciplina disciplinasAtuais resumo
        let grupoAtualizado = grupoExistente { Model.Grupo.disciplinas = disciplinaAtualizada }
        let gruposAtualizados = atualizarGrupo idGrupo listaGrupos grupoAtualizado
        saveAlteracoesGrupo gruposAtualizados
        return ("Resumo Adicionado! ID do Resumo: " ++ show idResumo)
    else
        return "Disciplina Não existe"

-- Função para adicionar um resumo a uma disciplina existente
adicionarResumoNaDisciplina :: Int -> [Disciplina] -> Resumo -> [Disciplina]
adicionarResumoNaDisciplina _ [] _ = []
adicionarResumoNaDisciplina idDisciplina (disciplina:outrasDisciplinas) resumo
    | Model.Disciplina.id disciplina == idDisciplina =
        disciplina { resumos = resumo : resumos disciplina } : outrasDisciplinas
    | otherwise =
        disciplina : adicionarResumoNaDisciplina idDisciplina outrasDisciplinas resumo


cadastraData :: Int -> Int -> String -> String -> String -> IO String
cadastraData  idGrupo idDisciplina tag datainicio dataFim = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let grupoExistente = getGruposByCodigo idGrupo listaGrupos
    let possuiDisciplina = verificaDisciplina idDisciplina (Model.Grupo.disciplinas grupoExistente)

    if possuiDisciplina then do
        idData <-  generateID 'D'
<<<<<<< HEAD
        let dataObj = Data tag idData datainicio dataFim[]
=======
        let dataObj = Data tag idData datainicio dataFim []
>>>>>>> 6a1f7c6aa8f282c85ab7bfc5fa4acead1f13b100
        let disciplinasAtuais = Model.Grupo.disciplinas grupoExistente
        let disciplinaAtualizada = adicionarDataNaDisciplina idDisciplina disciplinasAtuais dataObj
        let grupoAtualizado = grupoExistente { Model.Grupo.disciplinas = disciplinaAtualizada }
        let gruposAtualizados = atualizarGrupo idGrupo listaGrupos grupoAtualizado
        saveAlteracoesGrupo gruposAtualizados
        return ("Resumo Adicionado! ID da Data: " ++ show idData)
    else
        return "Disciplina Não existe"

adicionarDataNaDisciplina :: Int -> [Disciplina] -> Data -> [Disciplina]
adicionarDataNaDisciplina _ [] _ = []
adicionarDataNaDisciplina idDisciplina (disciplina:outrasDisciplinas) dataObj
    | Model.Disciplina.id disciplina == idDisciplina =
        let disciplinaAtualizada = disciplina { datas = dataObj : datas disciplina }
        in disciplinaAtualizada : outrasDisciplinas
    | otherwise =
        disciplina : adicionarDataNaDisciplina idDisciplina outrasDisciplinas dataObj

adicionarComentarioResumoDisciplinaDoGrupo :: Int -> Int -> String -> String -> String -> IO String
adicionarComentarioResumoDisciplinaDoGrupo idGrupo idDisciplina matriculaAluno idResumo comentario = do
    listaGrupos <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
    alunoList <- A.getAlunoJSON "src/DataBase/Data/Aluno.json"
    let grupoEncontrado = getGruposByCodigo idGrupo listaGrupos
    let disciplinasGrupo = Model.Grupo.disciplinas grupoEncontrado
    let aluno = A.getAlunoByMatricula matriculaAluno alunoList
    let disciplinaM = getDisciplinaByCodigo idDisciplina disciplinasGrupo

    case disciplinaM of
        Just disciplina -> do
            if codigo grupoEncontrado == -1 then
                return "Grupo não encontrado."
            else if grupoContainsAluno grupoEncontrado aluno then do
                if resumoExisteNaDisciplina idResumo disciplina then do 
                    idComentario <- generateID 'c'
                    let comentarioObj = Comentario idComentario matriculaAluno comentario
                    let disciplinaListaAtualizada = adicionarComentarioEmDisciplina idDisciplina disciplinasGrupo idResumo comentarioObj
                    let grupoAtualizado = grupoEncontrado { Model.Grupo.disciplinas = disciplinaListaAtualizada }
                    let gruposAtualizados = atualizarGrupo idGrupo listaGrupos grupoAtualizado
                    saveAlteracoesGrupo gruposAtualizados
                    return "Comentário adicionado ao resumo!"
                else
                    return "Resumo não cadastrado!"
            else 
                return "Você não está no grupo."
        Nothing ->
            return "Disciplina Não Encontrada"




-- Função para adicionar um comentário a um resumo
adicionarComentarioAoResumo :: String -> Comentario -> Resumo -> Resumo
adicionarComentarioAoResumo idDoResumo comentarioAtualizado resumo =
    if idDoResumo == idResumo resumo
        then resumo { comentario = comentarioAtualizado : comentario resumo }
        else resumo


-- Função para adicionar um comentário a um resumo em uma disciplina
adicionarComentarioNaDisciplina :: Int -> String -> Comentario -> [Disciplina] -> [Disciplina]
adicionarComentarioNaDisciplina codigoDisciplina codigoResumo comentarioAtualizado disciplinas =
    case find (\disciplina -> Model.Disciplina.id disciplina == codigoDisciplina) disciplinas of
        Just disciplinaEncontrada ->
            let resumosAtualizados = map (\resumo -> adicionarComentarioAoResumo codigoResumo comentarioAtualizado resumo) (resumos disciplinaEncontrada)
                disciplinaAtualizada = disciplinaEncontrada { Model.Disciplina.resumos = resumosAtualizados }
            in disciplinaAtualizada : filter (\disciplina -> Model.Disciplina.id disciplina /= codigoDisciplina) disciplinas
        Nothing -> disciplinas

-- Função principal para adicionar um comentário a um resumo em uma disciplina
adicionarComentarioEmDisciplina :: Int -> [Disciplina] -> String -> Comentario -> [Disciplina]
adicionarComentarioEmDisciplina codigoDisciplina disciplinas codigoResumo comentarioAtualizado =
    adicionarComentarioNaDisciplina codigoDisciplina codigoResumo comentarioAtualizado disciplinas

resumoExisteNaDisciplina :: String -> Disciplina -> Bool
resumoExisteNaDisciplina idResumo disciplina =
    any (\res -> Model.Resumo.idResumo res == idResumo) (resumos disciplina)

getDisciplinaByCodigo :: Int -> [Disciplina] -> Maybe Disciplina
getDisciplinaByCodigo _ [] = Nothing
getDisciplinaByCodigo codigoDisciplina (d:ds)
    | Model.Disciplina.id d == codigoDisciplina = Just d
    | otherwise = getDisciplinaByCodigo codigoDisciplina ds






removeMateriaisDisciplinaGrupo :: String -> Int -> Int -> String  -> IO String
removeMateriaisDisciplinaGrupo op idDisciplina idGrupo chave  = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let gruposExistente =  getGruposByCodigo idGrupo listaGrupos
    let possuiDisciplina = verificaDisciplina idDisciplina (Model.Grupo.disciplinas gruposExistente)
    
    if possuiDisciplina then do
        let disciplinasAtuais = Model.Grupo.disciplinas gruposExistente
        if(op == "resumo") then do

            let disciplinaAtualizada = removerResumoNaDisciplina idDisciplina  disciplinasAtuais chave
            let grupoAtualizado = gruposExistente { Model.Grupo.disciplinas = disciplinaAtualizada }
            let gruposAtualizados = atualizarGrupo idGrupo listaGrupos grupoAtualizado
            saveAlteracoesGrupo gruposAtualizados
            return ("Resumo removido com sucesso!")
        else
            if (op == "link") then do
                let disciplinaAtualizada = removerLinkNaDisciplina idDisciplina  disciplinasAtuais chave
                let grupoAtualizado = gruposExistente { Model.Grupo.disciplinas = disciplinaAtualizada }
                let gruposAtualizados = atualizarGrupo idGrupo listaGrupos grupoAtualizado
                saveAlteracoesGrupo gruposAtualizados
                return ("Link removido com sucesso!")
            else do
                let disciplinaAtualizada = removerDataNaDisciplina idDisciplina  disciplinasAtuais chave
                let grupoAtualizado =gruposExistente {Model.Grupo.disciplinas = disciplinaAtualizada }
                let gruposAtualizados = atualizarGrupo idGrupo listaGrupos grupoAtualizado
                saveAlteracoesGrupo gruposAtualizados
                return ("Data removida com sucesso!")
                
    else
        return "Disciplina Não existe"


showResumoGrupo :: Int -> Int -> String -> IO String
showResumoGrupo idGrupo idDisciplina idResumo = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let gruposExistente =  getGruposByCodigo idGrupo listaGrupos
    let possuiDisciplina = encontrarDisciplinaPorID idDisciplina (Model.Grupo.disciplinas gruposExistente)
    case possuiDisciplina of
        Just disciplinaEncontrada -> do
            case getResumo disciplinaEncontrada idResumo of
                Just resumoEncontrado -> return (show resumoEncontrado)
                Nothing -> return "Resumo não cadastrado"
        Nothing -> return "Disciplina Não Cadastrada"


showLinkUtilGrupo :: Int -> Int -> String -> IO String
showLinkUtilGrupo idGrupo idDisciplina idLinkUtil = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let gruposExistente =  getGruposByCodigo idGrupo listaGrupos
    let possuiDisciplina = encontrarDisciplinaPorID idDisciplina (Model.Grupo.disciplinas gruposExistente)
    case possuiDisciplina of
        Just disciplinaEncontrada -> do
            case getLinkUtil disciplinaEncontrada idLinkUtil of
                Just linkUtilEncontrado -> return (show linkUtilEncontrado)
                Nothing -> return "Link util não cadastrado"
        Nothing -> return "Disciplina Não Cadastrada"

showDataGrupo :: Int-> Int -> String -> IO String
showDataGrupo idGrupo idDisciplina idData = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let gruposExistente =  getGruposByCodigo idGrupo listaGrupos
    let possuiDisciplina = encontrarDisciplinaPorID idDisciplina (Model.Grupo.disciplinas gruposExistente)
    case possuiDisciplina of
        Just disciplinaEncontrada -> do
            case getData disciplinaEncontrada idData of
                Just dataEncontrado -> return (show dataEncontrado)
                Nothing -> return "Data não cadastrada"
        Nothing -> return "Disciplina Não Cadastrada"