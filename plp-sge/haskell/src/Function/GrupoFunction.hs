
-- Módulo responsável pelas funções cabíveis aos Grupos.
module Function.GrupoFunction where
import Model.Aluno
import Model.Grupo
import Model.Disciplina
import Model.Data
import Model.Resumo
import Model.LinkUtil
import Model.Comentario
import DataBase.Gerenciador.GrupoGerenciador as G
import DataBase.Gerenciador.AlunoGerenciador as A
import Data.List
import Data.List (elem)

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





    