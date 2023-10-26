:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).

% Regra que gera um ID aleatório
random_id(ID) :-
    random_between(100000000, 999999999, RandomNumber),
    number_codes(RandomNumber, RandomNumberCodes),
    string_codes(ID, RandomNumberCodes).

% Cadastra um aluno com Matricula, Nome e Senha.
cadastraAluno(Matricula, Nome, Senha, Result) :-
    atom_string(MatriculaAtom, Matricula),
    (\+ valida_aluno(MatriculaAtom) ->
        add_aluno(MatriculaAtom, Nome, Senha),
        Result = 'ok'
    ;  
        Result = 'falha'
    ).

% Verifica se o aluno com a Matricula fornecida existe.
verificaLogin(Matricula):-
    atom_string(MatriculaAtom, Matricula),
    valida_aluno(MatriculaAtom).

% Verifica se a senha fornecida corresponde à senha do aluno com a Matricula dada.
verificaSenhaAluno(Matricula, Senha) :-
    atom_string(MatriculaAtom, Matricula),
    get_aluno_senha(MatriculaAtom, SenhaAtual),
    atom_string(SenhaAtom, Senha),
    SenhaAtom = SenhaAtual.

% Cadastra uma disciplina com Matricula do aluno, IdDisciplina, Nome, Professor e Período.   
cadastra_disciplina_aluno(Matricula, IdDisciplina, Nome, Professor, Periodo, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(NomeAtom, Nome),
    atom_string(ProfessorAtom, Professor),
    atom_string(PeriodoAtom, Periodo),
    add_disciplina_aluno(MatriculaAtom, IdDisciplinaAtom, NomeAtom, ProfessorAtom, PeriodoAtom),
    atomic_list_concat(['\nDisciplina cadastrada! Código: ', IdDisciplinaAtom, '\n'], Result).

cadastra_disciplina_aluno(_, _, _, _, _, '\nDisciplina não cadastrada!\n').

% Remove uma disciplina do aluno com Matricula e IdDisciplina.
rm_disciplina_aluno(Matricula, IdDisciplina, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    remove_disciplina_aluno(MatriculaAtom, IdDisciplinaAtom),
    Result = '\nDisciplina Removida com Sucesso!\n'.

rm_disciplina_aluno(_, _, '\nDisciplina não encontrada!\n').

% Exibe as disciplinas do aluno com Matricula.
exibe_disciplinas(Matricula,Result):-
    atom_string(MatriculaAtom, Matricula),
    has_disciplines(MatriculaAtom),
    listaDisciplinas(MatriculaAtom, Result).

exibe_disciplinas(_,'\nNão Possui Disciplinas Cadastradas!\n').

% Adiciona um resumo de disciplina com Matricula, IdDisciplina, Nome e Resumo.
add_resumo_disciplina_aluno(Matricula, IdDisciplina, Nome, Resumo, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(NomeAtom, Nome),
    atom_string(ResumoAtom, Resumo),
    (valida_disciplina(MatriculaAtom, IdDisciplinaAtom)->
        random_id(IdR),
        adiciona_resumo_aluno(MatriculaAtom, IdDisciplinaAtom, IdR, NomeAtom, ResumoAtom),
        atomic_list_concat(['\nResumo cadastrado! ID: ', IdR, '\n'], Result)
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Adiciona um link de disciplina com Matricula, IdDisciplina, Titulo e Link
add_link_disciplina_aluno(Matricula, IdDisciplina, Titulo, Link, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(TituloAtom, Titulo),
    atom_string(LinkAtom, Link),
    (valida_disciplina(MatriculaAtom, IdDisciplinaAtom)->
        random_id(IdL),
        adiciona_link_aluno(MatriculaAtom, IdDisciplinaAtom, IdL, TituloAtom, LinkAtom),
        atomic_list_concat(['\nLink cadastrado! ID: ', IdL, '\n'], Result)
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Adiciona uma data de disciplina com Matricula, IdDisciplina, Titulo, Data de Início e Data de Fim.
add_data_disciplina_aluno(Matricula, IdDisciplina, Titulo, DataInicio, DataFim, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(TituloAtom, Titulo),
    atom_string(DataInicioAtom, DataInicio),
    atom_string(DataFimAtom, DataFim),
    (valida_disciplina(MatriculaAtom, IdDisciplinaAtom)->
        random_id(IdD),
        adiciona_data_aluno(MatriculaAtom, IdDisciplinaAtom, IdD, TituloAtom, DataInicioAtom, DataFimAtom),
        atomic_list_concat(['\nData cadastrada! ID: ', IdD, '\n'], Result)
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Remove um resumo do aluno em uma disciplina
remove_resumo_aluno(Matricula, IdDisciplina, IdResumo, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdResumoAtom, IdResumo),
    (valida_disciplina(MatriculaAtom, IdDisciplinaAtom)->
        (getResumoAluno(IdResumoAtom,MatriculaAtom,IdDisciplinaAtom,R), R \= -1 ->
            rem_resumo_aluno(MatriculaAtom, IdDisciplinaAtom, IdResumoAtom),
            Result = '\nResumo removido com sucesso!\n'
        ;
            Result = '\nResumo não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Remove uma data de um aluno em uma disciplina
remove_data_aluno(Matricula, IdDisciplina, IdData, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdDataAtom, IdData),
    (valida_disciplina(MatriculaAtom, IdDisciplinaAtom)->
        (getDataAluno(IdDataAtom,MatriculaAtom,IdDisciplinaAtom,R), R \= -1 ->
            rem_data_aluno(MatriculaAtom, IdDisciplinaAtom, IdDataAtom),
            Result = '\nData removida com sucesso!\n'
        ;
            Result = '\nData não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Remove um link de um aluno em uma disciplina
remove_link_aluno(Matricula, IdDisciplina, IdLink, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdLinkAtom, IdLink),
    (valida_disciplina(MatriculaAtom, IdDisciplinaAtom)->
        (getLinkAluno(IdLinkAtom,MatriculaAtom,IdDisciplinaAtom,R), R \= -1 ->
            rem_link_aluno(MatriculaAtom, IdDisciplinaAtom, IdLinkAtom),
            Result = '\nLink removido com sucesso!\n'
        ;
            Result = '\nLink não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Visualiza um resumo do aluno em uma disciplina
visualiza_resumo(Matricula, IdDisciplina, IdResumo, Result) :-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdResumoAtom, IdResumo),
    (valida_disciplina(MatriculaAtom, IdDisciplinaAtom) ->
        (getResumoAluno(IdResumoAtom, MatriculaAtom, IdDisciplinaAtom, R), R \= -1 ->
            extract_info_resumo(R, _, Titulo, Corpo, _),
            concatena_strings(['\nID:', IdResumo, '\nTitulo: ', Titulo, '\nConteudo: ', Corpo, '\n'], Result)
        ;
            Result = '\nResumo não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Visualiza uma data de um aluno em uma disciplina
visualiza_data(Matricula, IdDisciplina, IdData, Result) :-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdDataAtom, IdData),
    (valida_disciplina(MatriculaAtom, IdDisciplinaAtom) ->
        (getDataAluno(IdDataAtom, MatriculaAtom, IdDisciplinaAtom, R), R \= -1 ->
            extract_info_data(R, _, Titulo, DataInicio, DataFim, _),
            concatena_strings(['\nID:', IdData, '\nTitulo: ', Titulo, '\nData Início: ', DataInicio, '\nData Início: ', DataFim, '\n'], Result)
        ;
            Result = '\nData não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).

% Visualiza um link de um aluno em uma disciplina
visualiza_link(Matricula, IdDisciplina, IdLink, Result) :-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(IdLinkAtom, IdLink),
    (valida_disciplina(MatriculaAtom, IdDisciplinaAtom) ->
        (getLinkAluno(IdLinkAtom, MatriculaAtom, IdDisciplinaAtom, R), R \= -1 ->
            extract_info_link_util(R, _, Titulo, URL, _),
            concatena_strings(['\nID:', IdLink, '\nTitulo: ', Titulo, '\nURL: ', URL,'\n'], Result)
        ;
            Result = '\nLink não existe!\n'
        )
    ;
        Result = '\nDisciplina não existe!\n'
    ).
