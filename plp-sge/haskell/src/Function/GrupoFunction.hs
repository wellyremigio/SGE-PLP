module Function.GrupoFunction where
import Model.Aluno
import Model.Disciplina
import DataBase.Gerenciador.GrupoGerenciador

cadastraGrupo :: String -> Int -> String -> IO String
cadastraGrupo nomeGrupo  codigo  matAdm = do
    saveGrupo nomeGrupo  codigo  matAdm
    return "OK"


--removeGrupo

--listaGrupos


--menuMeusGrupos