module Function.AlunoFunction where
import Model.Aluno
import Model.Disciplina
import Model.Resumo
import Model.Data
import Model.Comentario
import Model.LinkUtil
import Data.List (deleteBy)
import DataBase.Gerenciador.AlunoGerenciador
import Data.Maybe
import Data.List (find)
import Data.Char (isAlpha, isAlphaNum, toLower)
import System.Random
import Model.Comentario

--Função que cadastra um novo usuário do sistema.
cadastraUsuario :: String -> String -> String -> IO String
cadastraUsuario matricula nome senha = do
    saveAluno matricula nome senha
    return "Cadastro realizado com sucesso!\n"

-- Verifica se a maatrícula já nao existe.
verificaLogin :: String -> IO Bool
verificaLogin matricula = do
    listaAlunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let matriculas = map Model.Aluno.matricula listaAlunos
    return $ matricula `elem` matriculas

--Verifica se a senha está correta.
verificaSenhaAluno :: String -> String -> IO Bool
verificaSenhaAluno matricula senha = do
    listaAlunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let aluno = getAlunoByMatricula matricula listaAlunos
    return $ Model.Aluno.senha aluno == senha

-- Função genérica que recebe uma lista e organiza essa lista conforme a instância Show do model.
organizaListagem :: Show t => [t] -> String
organizaListagem [] = ""
organizaListagem (x:xs) = show x ++ "\n" ++ organizaListagem xs

--Lista as disciplinas do aluno.
listagemDisciplinaALuno :: String -> IO String
listagemDisciplinaALuno matriculaAluno = do 
    disciplinasAluno <- getDisciplinasAluno matriculaAluno
    if null disciplinasAluno then 
        return "Nenhuma disciplina cadastrada!\n"
    else 
        return (organizaListagem disciplinasAluno)

-- Confere se a disciplina existe.
disciplinaExiste :: Int -> [Disciplina] -> Bool
disciplinaExiste idDisciplina disciplinas = any (\disciplina -> Model.Disciplina.id disciplina == idDisciplina) disciplinas


-- Encontra uma disciplina pelo seu id.
encontrarDisciplinaPorID :: Int -> [Disciplina] -> Maybe Disciplina
encontrarDisciplinaPorID idDisciplina disciplinas =
    find (\disciplina -> Model.Disciplina.id disciplina == idDisciplina) disciplinas

-- Adiciona uma disicplina.
adicionarDisciplina :: String -> Int -> String -> String -> String -> IO Bool
adicionarDisciplina matriculaAluno idDisciplina nome professor periodo = do
     alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json" 
     let alunoExistente = getAlunoByMatricula matriculaAluno alunos
     let disciplinaNova = Disciplina idDisciplina nome professor periodo [] [] []
     let japossuiDisciplina = disciplinaExiste idDisciplina (disciplinas alunoExistente)
     
     if not japossuiDisciplina then do
        let disciplinasExistente = disciplinas alunoExistente
        let novoAluno = alunoExistente { Model.Aluno.disciplinas = disciplinasExistente ++ [disciplinaNova] }
        alunosAtualizados <- removeAlunoByMatricula matriculaAluno
        let newListAluno = alunosAtualizados ++ [novoAluno]
        saveAlunoAlteracoes newListAluno
        return True
     else 
        return False

-- Remove uma disciplina.
removerDisciplinaAluno :: String -> Int -> IO Bool
removerDisciplinaAluno matriculaAluno idDisciplina = do
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let alunoExistente = getAlunoByMatricula matriculaAluno alunos
    let japossuiDisciplina = disciplinaExiste idDisciplina (disciplinas alunoExistente)
    if japossuiDisciplina then do
        let disciplinasAtualizadas = removeDisciplinaPorID idDisciplina (disciplinas alunoExistente)
        let novoAluno = alunoExistente { Model.Aluno.disciplinas = disciplinasAtualizadas }
        alunosAtualizados <- removeAlunoByMatricula matriculaAluno
        let newListAluno = novoAluno : alunosAtualizados
        saveAlunoAlteracoes newListAluno
        return True
    else
        return False
        
-- Função para remover uma disciplina por ID
removeDisciplinaPorID :: Int -> [Disciplina] -> [Disciplina]
removeDisciplinaPorID _ [] = []
removeDisciplinaPorID idToRemove disciplinas = deleteBy (\disciplina1 disciplina2 -> Model.Disciplina.id disciplina1 == Model.Disciplina.id disciplina2) (Disciplina idToRemove "" "" "" [] [] []) disciplinas


--Cadastra um resumo nas disciplinas do aluno.
cadastraResumoDisciplinaAluno :: Int -> String -> String -> String -> IO String
cadastraResumoDisciplinaAluno idDisciplina matricula titulo corpo = do
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let alunoExistente = getAlunoByMatricula matricula alunos
    let possuiDisciplina = disciplinaExiste idDisciplina (disciplinas alunoExistente)

    if possuiDisciplina then do
        idResumo <- generateID 'r'
        let resumo = Resumo idResumo titulo corpo []
        let disciplinasAtuais = disciplinas alunoExistente
        let disciplinaAtualizada = adicionarResumoNaDisciplina idDisciplina disciplinasAtuais resumo
        let alunoAtualizado = alunoExistente { Model.Aluno.disciplinas = disciplinaAtualizada }
        let alunosAtualizados = atualizarAluno matricula alunos alunoAtualizado
        saveAlunoAlteracoes alunosAtualizados
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

-- Função para atualizar a lista de alunos com um aluno modificado
atualizarAluno :: String -> [Aluno] -> Aluno -> [Aluno]
atualizarAluno _ [] _ = []
atualizarAluno matricula (aluno:outrosAlunos) alunoAtualizado
    | Model.Aluno.matricula aluno == matricula =
        alunoAtualizado : outrosAlunos
    | otherwise =
        aluno : atualizarAluno matricula outrosAlunos alunoAtualizado


-- Cadastra um link na disciplina do aluno.
cadastraLinkUtilDisciplinaAluno :: Int -> String -> String -> String -> IO String
cadastraLinkUtilDisciplinaAluno idDisciplina matricula titulo url = do
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let alunoExistente = getAlunoByMatricula matricula alunos
    let possuiDisciplina = disciplinaExiste idDisciplina (disciplinas alunoExistente)

    if possuiDisciplina then do
        idLinkUtil <- generateID 'l'
        let linkUtil = LinkUtil idLinkUtil titulo url []
        let disciplinasAtuais = disciplinas alunoExistente
        let disciplinaAtualizada = adicionarLinkUtilNaDisciplina idDisciplina disciplinasAtuais linkUtil
        let alunoAtualizado = alunoExistente { Model.Aluno.disciplinas = disciplinaAtualizada }
        let alunosAtualizados = atualizarAluno matricula alunos alunoAtualizado
        saveAlunoAlteracoes alunosAtualizados
        return ("Link Util Adicionado! ID Link Util: " ++ show idLinkUtil)
    else
        return "Disciplina Não existe"

-- Função para adicionar um LinkUtil a uma disciplina existente
adicionarLinkUtilNaDisciplina :: Int -> [Disciplina] -> LinkUtil -> [Disciplina]
adicionarLinkUtilNaDisciplina _ [] _ = []
adicionarLinkUtilNaDisciplina idDisciplina (disciplina:outrasDisciplinas) linkUtil
    | Model.Disciplina.id disciplina == idDisciplina =
        disciplina { links = linkUtil : links disciplina } : outrasDisciplinas
    | otherwise =
        disciplina : adicionarLinkUtilNaDisciplina idDisciplina outrasDisciplinas linkUtil

-- Adiciona data importante na disciplina do aluno.
adicionarDataNaDisciplina :: Int -> [Disciplina] -> Data -> [Disciplina]
adicionarDataNaDisciplina _ [] _ = []
adicionarDataNaDisciplina idDisciplina (disciplina:outrasDisciplinas) dataObj
    | Model.Disciplina.id disciplina == idDisciplina =
        let disciplinaAtualizada = disciplina { datas = dataObj : datas disciplina }
        in disciplinaAtualizada : outrasDisciplinas
    | otherwise =
        disciplina : adicionarDataNaDisciplina idDisciplina outrasDisciplinas dataObj

-- Cadastra uma data na disciplina do aluno.
cadastraDataDisciplinaAluno :: Int -> String -> String -> String -> String -> IO String
cadastraDataDisciplinaAluno idDisciplina matricula titulo datainicio dataFim = do
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let alunoExistente = getAlunoByMatricula matricula alunos
    let possuiDisciplina = disciplinaExiste idDisciplina (disciplinas alunoExistente)

    if possuiDisciplina then do
        idData <- generateID 'D'
        let dataObj = Data titulo idData datainicio dataFim []
        let disciplinasAtuais = disciplinas alunoExistente
        let disciplinaAtualizada = adicionarDataNaDisciplina idDisciplina disciplinasAtuais dataObj
        let alunoAtualizado = alunoExistente { Model.Aluno.disciplinas = disciplinaAtualizada }
        let alunosAtualizados = atualizarAluno matricula alunos alunoAtualizado
        saveAlunoAlteracoes alunosAtualizados
        return ("Data Adicionada! ID Data: " ++ show idData)
    else
        return "Disciplina Não existe"

-- Pega um resumo da disciplina.
getResumo :: Disciplina -> String -> Maybe Resumo
getResumo disciplina idResumoDesejado = 
    case find (\resumo -> idResumoDesejado == idResumo resumo) (resumos disciplina) of
        Just res -> Just res
        Nothing -> Nothing

isAlunoVazio :: Aluno -> Bool
isAlunoVazio aluno = null (matricula aluno)

-- Pega mum link util da disciplina.
getLinkUtil :: Disciplina -> String -> Maybe LinkUtil
getLinkUtil disciplina idLinkDesejado = 
    case find (\link -> idLinkDesejado == idLink link) (links disciplina) of
        Just link -> Just link
        Nothing -> Nothing

-- Pega uma data importante da disciplina.
getData :: Disciplina -> String -> Maybe Data
getData disciplina idDataDesejada = 
    case find (\dataObj -> idDataDesejada == iddata dataObj) (datas disciplina) of
        Just dataEncontrada -> Just dataEncontrada
        Nothing -> Nothing


-- Mostra o resumo de uma disciplina.
showResumo :: String -> Int -> String -> IO String
showResumo matriculaAluno idDisciplina idResumo = do
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let aluno = getAlunoByMatricula matriculaAluno alunos
    let disciplina = encontrarDisciplinaPorID idDisciplina (disciplinas aluno)
    case disciplina of
        Just disciplinaEncontrada -> do
            case getResumo disciplinaEncontrada idResumo of
                Just resumoEncontrado -> return (show resumoEncontrado)
                Nothing -> return "Resumo não cadastrado"
        Nothing -> return "Disciplina Não Cadastrada"


-- Mostra um link util de uma disciplina.
showLinkUtil :: String -> Int -> String -> IO String
showLinkUtil matriculaAluno idDisciplina idLinkUtil = do
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let aluno = getAlunoByMatricula matriculaAluno alunos
    let disciplina = encontrarDisciplinaPorID idDisciplina (disciplinas aluno)
    case disciplina of
        Just disciplinaEncontrada -> do
            case getLinkUtil disciplinaEncontrada idLinkUtil of
                Just linkUtilEncontrado -> return (show linkUtilEncontrado)
                Nothing -> return "Link util não cadastrado"
        Nothing -> return "Disciplina Não Cadastrada"


-- Mostra uma data importante de uma disciplina.
showData :: String -> Int -> String -> IO String
showData matriculaAluno idDisciplina idData = do
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let aluno = getAlunoByMatricula matriculaAluno alunos
    let disciplina = encontrarDisciplinaPorID idDisciplina (disciplinas aluno)
    case disciplina of
        Just disciplinaEncontrada -> do
            case getData disciplinaEncontrada idData of
                Just dataEncontrado -> return (show dataEncontrado)
                Nothing -> return "Data não cadastrada"
        Nothing -> return "Disciplina Não Cadastrada"

--Remove um material de uma disciplina do aluno.
removeMateriaisDisciplinaAluno :: String -> Int -> String -> String  -> IO String
removeMateriaisDisciplinaAluno op idDisciplina matricula chave  = do
    alunos <- getAlunoJSON "src/DataBase/Data/Aluno.json"
    let alunoExistente = getAlunoByMatricula matricula alunos
    let possuiDisciplina = disciplinaExiste idDisciplina (disciplinas alunoExistente)
    
    if possuiDisciplina then do
        let disciplinasAtuais = disciplinas alunoExistente
        if(op == "resumo") then do

            let disciplinaAtualizada = removerResumoNaDisciplina idDisciplina  disciplinasAtuais chave
            let alunoAtualizado = alunoExistente { Model.Aluno.disciplinas = disciplinaAtualizada }
            let alunosAtualizados = atualizarAluno matricula alunos alunoAtualizado
            saveAlunoAlteracoes alunosAtualizados
            return ("Resumo removido com sucesso!")
        else
            if (op == "link") then do
                let disciplinaAtualizada = removerLinkNaDisciplina idDisciplina  disciplinasAtuais chave
                let alunoAtualizado = alunoExistente { Model.Aluno.disciplinas = disciplinaAtualizada }
                let alunosAtualizados = atualizarAluno matricula alunos alunoAtualizado
                saveAlunoAlteracoes alunosAtualizados
                return ("Link removido com sucesso!")
            else do
                let disciplinaAtualizada = removerDataNaDisciplina idDisciplina  disciplinasAtuais chave
                let alunoAtualizado = alunoExistente { Model.Aluno.disciplinas = disciplinaAtualizada }
                let alunosAtualizados = atualizarAluno matricula alunos alunoAtualizado
                saveAlunoAlteracoes alunosAtualizados
                return ("Data removida com sucesso!")
    else
        return "Disciplina Não existe"

--Remove um resumo.
removerResumoNaDisciplina :: Int -> [Disciplina] -> String -> [Disciplina]
removerResumoNaDisciplina _ [] _ = []  -- Lista vazia, não há disciplinas para remover
removerResumoNaDisciplina idDisciplina (disciplina:outrasDisciplinas) chaveResumo
    | Model.Disciplina.id disciplina == idDisciplina =
        let resumosAtuais = resumos disciplina
            resumosAtualizados = filter (\r -> idResumo r /= chaveResumo) resumosAtuais
        in disciplina { resumos = resumosAtualizados } : outrasDisciplinas
    | otherwise =
        disciplina : removerResumoNaDisciplina idDisciplina outrasDisciplinas chaveResumo

--Remove um link.
removerLinkNaDisciplina :: Int -> [Disciplina] -> String -> [Disciplina]
removerLinkNaDisciplina _ [] _ = []  -- Lista vazia, não há disciplinas para remover
removerLinkNaDisciplina idDisciplina (disciplina:outrasDisciplinas) chaveLink
    | Model.Disciplina.id disciplina == idDisciplina =
        let linksAtuais = links disciplina
            linksAtualizados = filter (\link -> idLink link /= chaveLink) linksAtuais
        in disciplina { links = linksAtualizados } : outrasDisciplinas
    | otherwise =
        disciplina : removerLinkNaDisciplina idDisciplina outrasDisciplinas chaveLink

-- Função para remover uma data dentro de uma disciplina existente
removerDataNaDisciplina :: Int -> [Disciplina] -> String -> [Disciplina]
removerDataNaDisciplina _ [] _ = []  -- Lista vazia, não há disciplinas para remover
removerDataNaDisciplina idDisciplina (disciplina:outrasDisciplinas) chaveData
    | Model.Disciplina.id disciplina == idDisciplina =
        let datasAtuais = datas disciplina
            datasAtualizadas = filter (\dataObj -> iddata dataObj /= chaveData) datasAtuais
        in disciplina { datas = datasAtualizadas } : outrasDisciplinas
    | otherwise =
        disciplina : removerDataNaDisciplina idDisciplina outrasDisciplinas chaveData

--Gera um ID para o material cadastrado.
generateID :: Char -> IO String
generateID c = do
    seed <- randomIO  -- Gera uma semente aleatória
    let g = mkStdGen seed
        alphaNums = filter isAlphaNum (randomRs ('a', 'z') g)
        upperNums = filter isAlphaNum (randomRs ('A', 'Z') g)
        nums = filter isAlphaNum (randomRs ('0', '9') g)
        idStr = take 9 (alphaNums ++ upperNums ++ nums)
    return (idStr ++ "-" ++ [toLower c])
