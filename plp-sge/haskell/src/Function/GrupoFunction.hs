module Function.GrupoFunction where
import Model.Aluno
import Model.Grupo
import Model.Disciplina
import DataBase.Gerenciador.GrupoGerenciador as B

cadastraGrupo :: String -> Int -> String -> IO String
cadastraGrupo nomeGrupo  codigo  matAdm = do
    saveGrupo nomeGrupo  codigo  matAdm
    return "Grupo cadastrado com sucesso!"

verificaIdGrupo :: Int -> IO Bool
verificaIdGrupo codigo = do
    listaGrupos <- getGruposJSON "src/DataBase/Data/Grupo.json"
    let grupos = getGruposByCodigo codigo listaGrupos
    return $ Model.Grupo.codigo grupos /= (-1)

--removeGrupo
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
        grupos <- B.getGruposJSON "src/DataBase/Data/Grupo.json"
        let removida = removeGrupoByCodigo idGrupo grupos
        if (length removida == length grupos) then return "Não foi possivel realizar ação" else do
            saveAlteracoesGrupo removida
            return "remoção feita com sucesso"
    else
        return "Não foi possivel realizar ação"

--listar grupo
listaGrupos:: IO String
listaGrupos = do
    grupos <- B.getGruposJSON "src/DataBase/Data/Grupo.json"
    return $ "Esses são seus grupos:\n" ++ organizaListagem grupos
    
organizaListagem :: Show t => [t] -> String
organizaListagem [] = ""
organizaListagem (x:xs) = show x ++ "\n" ++ organizaListagem xs

--menuMeusGrupos