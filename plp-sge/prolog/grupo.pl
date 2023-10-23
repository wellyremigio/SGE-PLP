:- enconding(utf8).
:- set_prolog_flag(encoding, utf8).

%Cadastra um grupo
cadastraGrupo(CodGrupo, NomeGrupo, Adm, Result) :-
    atom_string(CodGrupoAtom, CodGrupo),
    (\+ valida_grupo(CodGrupoAtom) ->
        add_grupo(CodGrupo, NomeGrupo, Adm),
        Result = 'ok'
    ;
        Result = 'falha'
    ).

%Verifica se um grupo está cadastrado
verificaGrupo(CodGrupo):-
    atom_string(CodGrupoAtom, CodGrupo),
    valida_grupo(CodGrupoAtom).

%Verifica se um aluno é administrador do grupo
verificaAdm(Codigo, Matricula, Result):-
    atom_string(CodigoAtom, Codigo),
    atom_string(MatriculaAtom, Matricula),
    verifica_adm_remove(CodigoAtom, MatriculaAtom, Result).

%Remove um grupo
removeGrupo(Codigo, Adm) :-
    atom_string(CodigoAtom, Codigo),
    get_grupo_by_codigo(CodigoAtom, Grupo),
    Grupo \= -1,
    remove_grupo_by_codigo(CodigoAtom).
    
adicionaAlunoGrupo(CodGrupo, MatriculaAluno):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(MatriculaAtom, MatriculaAluno),
    adiciona_aluno_grupo(CodGrupoAtom, MatriculaAtom).


%Cadastra uma disciplina no grupo
cadastraDisciplinaGrupo(CodGrupo, IdDisciplina, Nome, Professor, Periodo, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(NomeAtom, Nome),
    atom_string(ProfessorAtom, Professor),
    atom_string(PeriodoAtom, Periodo),
    add_disciplina_grupo(CodGrupoAtom, IdDisciplinaAtom, NomeAtom, ProfessorAtom, PeriodoAtom),
    atomic_list_concat(['\nDisciplina cadastrada! Código: ', IdDisciplinaAtom, '\n'], Result).

cadastraDisciplinaGrupo(_, _, _, _, _, '\nDisciplina não cadastrada!\n').

%não está sendo usado no momento, mas pode ser util
validaDisciplina(CodGrupo, IdDisciplina):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    \+verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom).

%Remove uma disciplina do grupo
removeDisciplinaGrupo(CodGrupo, IdDisciplina, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    remove_disciplina_grupo(CodGrupoAtom, IdDisciplinaAtom),
    Result = '\nDisciplina Removida com Sucesso!\n'.

removeDisciplinaGrupo(_, _, '\nDisciplina não encontrada!\n').

%Lista as disciplinas de um grupo
listagemDisciplinaGrupo(CodGrupo, Resposta) :-
    atom_string(CodGrupoAtom, CodGrupo),
    listaDisciplinaGrupo(CodGrupoAtom, Resposta).

%Lista os alunos de um grupo
listagemAlunosGrupo(CodGrupo, Resposta) :-
    atom_string(CodGrupoAtom, CodGrupo),
    listaAlunosGrupo(CodGrupoAtom, Resposta).

%Lista os grupos
listagemGrupos(Resposta) :-
    get_grupos(Data),
    (Data = [] -> 
        Resposta = 'Não existem grupos cadastrados'
    ;
        organizaListagemGrupo(Data, Resposta)
    ).

adicionaAlunoGrupo(CodGrupo, MatriculaAluno):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(MatriculaAtom, MatriculaAluno),
    adiciona_aluno_grupo(CodGrupoAtom, MatriculaAtom).

removeAlunoGrupo(CodGrupo, MatriculaAluno):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(MatriculaAtom, MatriculaAluno),
    remove_aluno_grupo(CodGrupoAtom, MatriculaAtom).

removeAlunoGrupo(CodGrupo, MatriculaAluno):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(MatriculaAtom, MatriculaAluno),
    remove_aluno_grupo(CodGrupoAtom, MatriculaAtom).


%Regra para adicionar resumo em grupo
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

%Regra para adicionar link em grupo
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


% Regra que gera um ID aleatório
random_id(ID) :-
    random_between(100000000, 999999999, RandomNumber),
    number_codes(RandomNumber, RandomNumberCodes),
    string_codes(ID, RandomNumberCodes).
    