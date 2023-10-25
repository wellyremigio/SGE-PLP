% Cadastra um grupo
cadastraGrupo(CodGrupo, NomeGrupo, Adm, Result) :-
    atom_string(CodGrupoAtom, CodGrupo),
    (\+ valida_grupo(CodGrupoAtom) ->
        add_grupo(CodGrupo, NomeGrupo, Adm),
        Result = 'ok'
    ;
        Result = 'falha'
    ).

% Verifica se um grupo está cadastrado
verificaGrupo(CodGrupo):-
    atom_string(CodGrupoAtom, CodGrupo),
    valida_grupo(CodGrupoAtom).

% Verifica se um aluno é administrador do grupo
verificaAdm(Codigo, Matricula, Result):-
    atom_string(CodigoAtom, Codigo),
    atom_string(MatriculaAtom, Matricula),
    verifica_adm_remove(CodigoAtom, MatriculaAtom, Result).

% Remove um grupo
removeGrupo(Codigo, Adm) :-
    atom_string(CodigoAtom, Codigo),
    get_grupo_by_codigo(CodigoAtom, Grupo),
    Grupo \= -1,
    remove_grupo_by_codigo(CodigoAtom).

% Adiciona um aluno a um grupo   
adicionaAlunoGrupo(CodGrupo, MatriculaAluno):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(MatriculaAtom, MatriculaAluno),
    adiciona_aluno_grupo(CodGrupoAtom, MatriculaAtom).

% Cadastra uma disciplina no grupo
cadastraDisciplinaGrupo(CodGrupo, IdDisciplina, Nome, Professor, Periodo, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(NomeAtom, Nome),
    atom_string(ProfessorAtom, Professor),
    atom_string(PeriodoAtom, Periodo),
    add_disciplina_grupo(CodGrupoAtom, IdDisciplinaAtom, NomeAtom, ProfessorAtom, PeriodoAtom),
    atomic_list_concat(['\nDisciplina cadastrada! Código: ', IdDisciplinaAtom, '\n'], Result).

cadastraDisciplinaGrupo(_, _, _, _, _, '\nDisciplina não cadastrada!\n').

% Valida se uma disciplina existe em um grupo
validaDisciplina(CodGrupo, IdDisciplina):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    \+verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom).

% Remove uma disciplina do grupo
removeDisciplinaGrupo(CodGrupo, IdDisciplina, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    remove_disciplina_grupo(CodGrupoAtom, IdDisciplinaAtom),
    Result = '\nDisciplina Removida com Sucesso!\n'.

removeDisciplinaGrupo(_, _, '\nDisciplina não encontrada!\n').

% Lista as disciplinas de um grupo
listagemDisciplinaGrupo(CodGrupo, Resposta) :-
    atom_string(CodGrupoAtom, CodGrupo),
    listaDisciplinaGrupo(CodGrupoAtom, Resposta).

% Lista os alunos de um grupo
listagemAlunosGrupo(CodGrupo, Resposta) :-
    atom_string(CodGrupoAtom, CodGrupo),
    listaAlunosGrupo(CodGrupoAtom, Resposta).

% Lista os grupos
listagemGrupos(Resposta) :-
    get_grupos(Data),
    (Data = [] -> 
        Resposta = 'Não existem grupos cadastrados'
    ;
        organizaListagemGrupo(Data, Resposta)
    ).

% Remove um aluno de um grupo
removeAlunoGrupo(CodGrupo, MatriculaAluno):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(MatriculaAtom, MatriculaAluno),
    remove_aluno_grupo(CodGrupoAtom, MatriculaAtom).

% Adiciona um resumo em um grupo
add_resumo_disciplina_grupo(CodGrupo, IdDisciplina, Nome, Resumo, Result) :-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(NomeAtom, Nome),
    atom_string(ResumoAtom, Resumo),
    (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom) ->
        random_id(IdR),
        adiciona_resumo_grupo(CodGrupoAtom, IdDisciplinaAtom, IdR, NomeAtom, ResumoAtom),
        atomic_list_concat(['\nResumo cadastrado! ID: ', IdR, '\n'], Result)
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Adiciona um link em um grupo
add_link_disciplina_grupo(CodGrupo, IdDisciplina, Titulo, Link, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(TituloAtom, Titulo),
    atom_string(LinkAtom, Link),
    (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom)->
        random_id(IdL),
        adiciona_link_grupo(CodGrupoAtom, IdDisciplinaAtom, IdL, TituloAtom, LinkAtom),
        atomic_list_concat(['\nLink cadastrado! ID: ', IdL, '\n'], Result)
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Adiciona uma data em um grupo
add_data_disciplina_grupo(CodGrupo, IdDisciplina, Titulo, DataInicio, DataFim, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(TituloAtom, Titulo),
    atom_string(DataInicioAtom, DataInicio),
    atom_string(DataFimAtom, DataFim),
    (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom)->
        random_id(IdD),
        adiciona_data_grupo(CodGrupoAtom, IdDisciplinaAtom, IdD, TituloAtom, DataInicioAtom, DataFimAtom),
        atomic_list_concat(['\nData cadastrada! ID: ', IdD, '\n'], Result)
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Remove um resumo de um grupo
remove_resumo_grupo(CodGrupo, IdDisciplina, IdResumo, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdResumoAtom, IdResumo),
    (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom)->
        (getResumoGrupo(IdResumoAtom,CodGrupoAtom,IdDisciplinaAtom,R), R \= -1 ->
            rem_resumo_grupo(CodGrupoAtom, IdDisciplinaAtom, IdResumoAtom),
            Result = '\nResumo removido com sucesso!\n'
        ;
            Result = '\nResumo não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Remove uma data de um grupo
remove_data_grupo(CodGrupo, IdDisciplina, IdData, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdDataAtom, IdData),
    (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom)->
        (getDataGrupo(IdDataAtom,CodGrupoAtom,IdDisciplinaAtom,R), R \= -1 ->
            rem_data_grupo(CodGrupoAtom, IdDisciplinaAtom, IdDataAtom),
            Result = '\nData removida com sucesso!\n'
        ;
            Result = '\nData não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Remove um link de um grupo
remove_link_grupo(CodGrupo, IdDisciplina, IdLink, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdLinkAtom, IdLink),
    (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom)->
        (getLinkGrupo(IdLinkAtom,CodGrupoAtom,IdDisciplinaAtom,R), R \= -1 ->
            rem_link_grupo(CodGrupoAtom, IdDisciplinaAtom, IdLinkAtom),
            Result = '\nLink removido com sucesso!\n'
        ;
            Result = '\nLink não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Visualiza um resumo em um grupo
visualiza_resumo_grupo(CodGrupo, IdDisciplina, IdResumo, Result) :-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdResumoAtom, IdResumo),
    (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom) ->
        (getResumoGrupo(IdResumoAtom, CodGrupoAtom, IdDisciplinaAtom, R), R \= -1 ->
            extract_info_resumo(R, _, Titulo, Corpo, _),
            concatena_strings(['\nID:', IdResumo, '\nTitulo: ', Titulo, '\nConteudo: ', Corpo, '\n'], Result)
        ;
            Result = '\nResumo não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Visualiza um link em um grupo
visualiza_link_grupo(CodGrupo, IdDisciplina, IdLink, Result) :-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdLinkAtom, IdLink),
    (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom) ->
        (getLinkGrupo(IdLinkAtom, CodGrupoAtom, IdDisciplinaAtom, R), R \= -1 ->
            extract_info_link_util(R, _, Titulo, URL, _),
            concatena_strings(['\nID:', IdLink, '\nTitulo: ', Titulo, '\nURL: ', URL,'\n'], Result)
        ;
            Result = '\nLink não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Visualiza uma data em um grupo
visualiza_data_grupo(CodGrupo, IdDisciplina, IdData, Result) :-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdDataAtom, IdData),
    (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom) ->
        (getDataGrupo(IdDataAtom, CodGrupoAtom, IdDisciplinaAtom, R), R \= -1 ->
            extract_info_data(R, _, Titulo, DataInicio, DataFim, _),
            concatena_strings(['\nID:', IdData, '\nTitulo: ', Titulo, '\nData Início: ', DataInicio, '\nData Início: ', DataFim, '\n'], Result)
        ;
            Result = '\nData não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Adiciona um comentário a um resumo em um grupo
add_comentario_resumo(Matricula, CodGrupo, IdDisciplina, IdResumo, Conteudo, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdResumoAtom, IdResumo),
    atom_string(ConteudoAtom, Conteudo),
    (valida_grupo(CodGrupoAtom) ->
        (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom) ->
            (getResumoGrupo(IdResumoAtom, CodGrupoAtom, IdDisciplinaAtom, R), R \= -1 ->
                (valida_aluno_grupo(CodGrupoAtom, MatriculaAtom) ->
                    random_id(IDC),
                    adiciona_comentario_grupo_resumo(MatriculaAtom, CodGrupoAtom, IdDisciplinaAtom, IdResumoAtom, IDC, ConteudoAtom),
                    atomic_list_concat(['\nComentário cadastrado! ID: ', IDC, '\n'], Result)
                ;
                    Result = '\nVocê não está nesse grupo!\n'
                )
            ;
                Result = '\nResumo não cadastrado!\n'
            )
        ;
            Result = '\nDisciplina não cadastrada!\n'
        )
    ;
        Result = '\nGrupo não Encontrado!\n'
    ).

% Adiciona um comentário a uma data em um grupo
add_comentario_data(Matricula, CodGrupo, IdDisciplina, IdData, Conteudo, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdDataAtom, IdData),
    atom_string(ConteudoAtom, Conteudo),
    (valida_grupo(CodGrupoAtom) ->
        (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom) ->
            (getDataGrupo(IdDataAtom, CodGrupoAtom, IdDisciplinaAtom, R), R \= -1 ->
                (valida_aluno_grupo(CodGrupoAtom, MatriculaAtom) ->
                    random_id(IDC),
                    adiciona_comentario_grupo_data(MatriculaAtom, CodGrupoAtom, IdDisciplinaAtom, IdDataAtom, IDC, ConteudoAtom),
                    atomic_list_concat(['\nComentário cadastrado! ID: ', IDC, '\n'], Result)
                ;
                    Result = '\nVocê não está nesse grupo!\n'
                )
            ;
                Result = '\nData não cadastrada!\n'
            )
        ;
            Result = '\nDisciplina não cadastrada!\n'
        )
    ;
        Result = '\nGrupo não Encontrado!\n'
    ).

% Adiciona um comentário a um link em um grupo   
add_comentario_link(Matricula, CodGrupo, IdDisciplina, IdLink, Conteudo, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdLinkAtom, IdLink),
    atom_string(ConteudoAtom, Conteudo),
    (valida_grupo(CodGrupoAtom) ->
        (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom) ->
            (getLinkGrupo(IdLinkAtom, CodGrupoAtom, IdDisciplinaAtom, R), R \= -1 ->
                (valida_aluno_grupo(CodGrupoAtom, MatriculaAtom) -> 
                    random_id(IDC),
                    adiciona_comentario_grupo_link(MatriculaAtom, CodGrupoAtom, IdDisciplinaAtom, IdLinkAtom, IDC, ConteudoAtom),
                    atomic_list_concat(['\nComentário cadastrado! ID: ', IDC, '\n'], Result)
                ;
                    Result = '\nVocê não está nesse grupo!\n'
                )
            ;
                Result = '\nLink não cadastrado!\n'
            )
        ;
            Result = '\nDisciplina não cadastrada!\n'
        )
    ;
        Result = '\nGrupo não Encontrado!\n'
    ).

% Lista os comentários de uma data em um grupo
comentarios_data(Matricula, CodGrupo,IdDisciplina, IdData, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdDataAtom, IdData),
    (valida_grupo(CodGrupoAtom) ->
        (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom) ->
            (getDataGrupo(IdDataAtom, CodGrupoAtom, IdDisciplinaAtom, R), R \= -1 ->
                (valida_aluno_grupo(CodGrupoAtom, MatriculaAtom) ->
                    lista_comentarios_data(R,Result)
                ;
                    Result = '\nVocê não está nesse grupo!\n'
                )
            ;
                Result = '\nData não cadastrada!\n'
            )
        ;
            Result = '\nDisciplina não cadastrada!\n'
        )
    ;
        Result = '\nGrupo não Encontrado!\n'
    ).

% Lista os comentários de um resumo em um grupo
comentarios_resumo(Matricula, CodGrupo,IdDisciplina, IdResumo, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdResumoAtom, IdResumo),
    (valida_grupo(CodGrupoAtom) ->
        (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom) ->
            (getResumoGrupo(IdResumoAtom, CodGrupoAtom, IdDisciplinaAtom, R), R \= -1 ->
                (valida_aluno_grupo(CodGrupoAtom, MatriculaAtom) ->
                    lista_comentarios_resumo(R,Result)
                ;
                    Result = '\nVocê não está nesse grupo!\n'
                )
            ;
                Result = '\nResumo não cadastrado!\n'
            )
        ;
            Result = '\nDisciplina não cadastrada!\n'
        )
    ;
        Result = '\nGrupo não Encontrado!\n'
    ).

% Lista os comentários de um link em um grupo
comentarios_link(Matricula, CodGrupo,IdDisciplina, IdLink, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdLinkAtom, IdLink),
    (valida_grupo(CodGrupoAtom) ->
        (verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom) ->
            (getLinkGrupo(IdLinkAtom, CodGrupoAtom, IdDisciplinaAtom, R), R \= -1 ->
                (valida_aluno_grupo(CodGrupoAtom, MatriculaAtom) ->
                    lista_comentarios_link(R,Result)
                ;
                    Result = '\nVocê não está nesse grupo!\n'
                )
            ;
                Result = '\nLink não cadastrado\n'
            )
        ;
            Result = '\nDisciplina não cadastrada!\n'
        )
    ;
        Result = '\nGrupo não Encontrado!\n'
    ).

% Regra que gera um ID aleatório
random_id(ID) :-
    random_between(100000000, 999999999, RandomNumber),
    number_codes(RandomNumber, RandomNumberCodes),
    string_codes(ID, RandomNumberCodes).

% Edita o corpo de um resumo em um grupo
editaResumoGrupo(CodGrupo, CodDisciplina, CodResumo, NewCorpo, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(CodDisciplinaAtom, CodDisciplina),
    atom_string(CodResumoAtom, CodResumo),
    atom_string(NewCorpoAtom, NewCorpo),
    (verificaGrupo(CodGrupoAtom) ->
        (verifica_disciplina(CodGrupoAtom, CodDisciplinaAtom)->
            (getResumoGrupo(CodResumoAtom, CodGrupoAtom, CodDisciplinaAtom, R), R \= -1 ->
                edita_resumo_grupo(CodGrupoAtom, CodDisciplinaAtom, CodResumoAtom, NewCorpoAtom),
                Result = 'Resumo editado com sucesso'
            ; Result = 'Resumo não cadastrado')    
        ; Result = 'Disciplina não cadastrada')
    ; Result = 'Grupo não existe').

% Edita as datas de uma data em um grupo
editaDataGrupo(CodGrupo, CodDisciplina, CodData, NewDataInit, NewDataFim, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(CodDisciplinaAtom, CodDisciplina),
    atom_string(CodDataAtom, CodData),
    atom_string(NewDataInitAtom, NewDataInit),
    atom_string(NewDataFimAtom, NewDataFim),
    (verificaGrupo(CodGrupoAtom) ->
        (verifica_disciplina(CodGrupoAtom, CodDisciplinaAtom)->
            (getDataGrupo(CodDataAtom, CodGrupoAtom, CodDisciplinaAtom,R), R \= -1 ->
                edita_data_grupo(CodGrupoAtom, CodDisciplinaAtom, CodDataAtom, NewDataInitAtom, NewDataFimAtom),
                Result = 'Data editada com sucesso'
            ; Result = 'Data não cadastrada')    
        ; Result = 'Disciplina não cadastrada')
    ; Result = 'Grupo não existe').

% Edita o URL de um link em um grupo
editaLinkGrupo(CodGrupo, CodDisciplina, CodLink, NewUrl, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(CodDisciplinaAtom, CodDisciplina),
    atom_string(CodLinkAtom, CodLink),
    atom_string(NewUrlAtom, NewUrl),
    (verificaGrupo(CodGrupoAtom) ->
        (verifica_disciplina(CodGrupoAtom, CodDisciplinaAtom)->
            (getLinkGrupo(CodLinkAtom, CodGrupoAtom, CodDisciplinaAtom, R), R \= -1 ->
                edita_link_grupo(CodGrupoAtom, CodDisciplinaAtom, CodLinkAtom, NewUrlAtom),
                Result = 'Link editado com sucesso'
            ; Result = 'Link não cadastrado')    
        ; Result = 'Disciplina não cadastrada')
    ; Result = 'Grupo não existe').

% Lista os grupos de um aluno por matrícula
listagemMeusGrupos(Matricula, Result) :-
    get_grupos(Data),
    get_grupo(Matricula, Data, Grupos),
    (Grupos = [] ->
        Result = 'Aluno não está cadastrado em nenhum grupo'
    ;
        organizaListagemGrupo(Grupos, Result)
    ).
