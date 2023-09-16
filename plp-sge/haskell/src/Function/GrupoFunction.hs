module Function.GrupoFunction where
import Model.Aluno
import Model.Grupo
import Model.Disciplina
import DataBase.Gerenciador.GrupoGerenciador as G
import DataBase.Gerenciador.AlunoGerenciador as A
import Data.List

cadastraGrupo :: String -> Int -> String -> IO String
cadastraGrupo nomeGrupo  codigo  matAdm = do
    saveGrupo nomeGrupo  codigo  matAdm
    return "Grupo cadastrado com sucesso!"

verificaIdGrupo :: Int -> IO Bool
verificaIdGrupo codigo = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let grupos = getGruposByCodigo codigo listaGrupos
    return $ Model.Grupo.codigo grupos /= (-1)

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

removeGrupo:: Int -> IO String
removeGrupo idGrupo = do
    verifica <- verificaIdGrupo idGrupo 
    if (verifica) then do
        grupos <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
        let removida = removeGrupoByCodigo idGrupo grupos
        if (length removida == length grupos) then return "Não foi possivel realizar ação" else do
            saveAlteracoesGrupo removida
            return "remoção feita com sucesso"
    else
        return "Não foi possivel realizar ação"

--listar grupo
listaGrupos:: IO String
listaGrupos = do
    grupos <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
    return $ "Esses são seus grupos:\n" ++ organizaListagem grupos
    
organizaListagem :: Show t => [t] -> String
organizaListagem [] = ""
organizaListagem (x:xs) = show x ++ "\n" ++ organizaListagem xs


--menuMeusGrupos

verificaAdmGrupo :: String -> Int -> IO Bool
verificaAdmGrupo matricula codigoGrupo  = do
    grupos <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
    return $ case find (\grupo -> codigo grupo == codigoGrupo) grupos of
        Just grupo -> adm grupo == matricula
        Nothing -> False



adicionarAluno :: String -> Int -> IO String
adicionarAluno matricula codGrupo = do
    grupoList <- G.getGruposJSON "src/DataBase/Data/Grupo.json"
    alunoList <- A.getAlunoJSON "src/DataBase/Data/Aluno.json"
    let grupo = G.getGruposByCodigo codGrupo grupoList
    let aluno = A.getAlunoByMatricula matricula alunoList
    grupoAtualizado <- G.adicionarAlunoLista aluno grupo
    G.saveAlteracoesAluno grupoAtualizado
    return "Aluno adicionado com sucesso"
    


