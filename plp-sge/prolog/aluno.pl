:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).

cadastraAluno(Matricula, Nome, Senha, Result) :-
    atom_string(MatriculaAtom, Matricula),
    (\+ valida_aluno(MatriculaAtom) ->
        add_aluno(MatriculaAtom, Nome, Senha),
        Result = 'ok'
    ;  
        Result = 'falha'
    ).

verificaLogin(Matricula):-
    atom_string(MatriculaAtom, Matricula),
    valida_aluno(MatriculaAtom).

verificaSenhaAluno(Matricula, Senha) :-
    atom_string(MatriculaAtom, Matricula),
    get_aluno_senha(MatriculaAtom, SenhaAtual),
    atom_string(SenhaAtom, Senha),
    SenhaAtom = SenhaAtual.
   
cadastra_disciplina_aluno(Matricula, IdDisciplina, Nome, Professor, Periodo, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(NomeAtom, Nome),
    atom_string(ProfessorAtom, Professor),
    atom_string(PeriodoAtom, Periodo),
    add_disciplina_aluno(MatriculaAtom, IdDisciplinaAtom, NomeAtom, ProfessorAtom, PeriodoAtom),
    atomic_list_concat(['\nDisciplina cadastrada! Código: ', IdDisciplinaAtom, '\n'], Result).


cadastra_disciplina_aluno(_, _, _, _, _, '\nDisciplina não cadastrada!\n').

rm_disciplina_aluno(Matricula, IdDisciplina, Result):-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    remove_disciplina_aluno(MatriculaAtom, IdDisciplinaAtom),
    Result = '\nDisciplina Removida com Sucesso!\n'.

rm_disciplina_aluno(_, _, '\nDisciplina não encontrada!\n').

exibe_disciplinas(Matricula,Result):-
    atom_string(MatriculaAtom, Matricula),
    has_disciplines(MatriculaAtom),
    listaDisciplinas(MatriculaAtom, Result).

exibe_disciplinas(_,'\nNão Possui Disciplinas Cadastradas!\n').

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


% Regra que gera um ID aleatório
random_id(ID) :-
    random_between(100000000, 999999999, RandomNumber),
    number_codes(RandomNumber, RandomNumberCodes),
    string_codes(ID, RandomNumberCodes).

