:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).

cadastraAluno(Matricula, Nome, Senha, Result) :-
    atom_string(MatriculaAtom, Matricula),
    (\+ valida_aluno(MatriculaAtom) ->
        add_aluno(MatriculaAtom, Nome, Senha),
        Result = 'ok'
    ;  
        Result = 'erro'
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
    atomic_concat('Disciplina cadastrada! Código: ', IdDisciplinaAtom, Result).

cadastra_disciplina_aluno(_, _, _, _, _, 'Disciplina não cadastrada!').
