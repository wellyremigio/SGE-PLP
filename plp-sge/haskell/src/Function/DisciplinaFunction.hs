module Function.DisciplinaFunction where
    import DataBase.Gerenciador.DisciplinaGerenciador as DisciplinaG
    --cadastraResumo id nome conteudo
    cadastraResumo :: String -> Int -> String -> String -> IO()
    cadastraResumo matricula id nome conteudo = putStr (DisciplinaG.addResumoByID matricula id nome conteudo)