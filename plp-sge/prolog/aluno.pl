:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).

:- include('constantes.pl').
:- consult('DataBase/gerenciadorGeral.pl').
:- consult('DataBase/gerenciadorAluno.pl').



%to do
%verificaLogin(MatriculaInput, AlunoCadastrado) :- 

%to do
%verificaSenhaAluno(MatriculaInput, SenhaInput, SenhaCorreta) :-

%
cadastraAluno(MatriculaAtom, Nome, Senha, Result):-
    %atom_string(MatriculaAtom, Matricula),
    add_aluno(MatriculaAtom, Nome, Senha),
    Result = 'Aluno cadastrado!',
    write(MatriculaAtom).

cadastraAluno(_,_,_,'Cadastro não realizado!').

cadastra_disciplina_aluno(Matricula, IdDisciplina, Nome, Professor, Periodo, Result) :-
    atom_string(MatriculaAtom, Matricula),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(NomeAtom, Nome),
    atom_string(ProfessorAtom, Professor),
    atom_string(PeriodoAtom, Periodo),
    add_disciplina_aluno(MatriculaAtom, IdDisciplinaAtom, NomeAtom, ProfessorAtom, PeriodoAtom),
    atomic_concat('Disciplina cadastrada! Código: ', IdDisciplinaAtom, Result).

cadastra_disciplina_aluno(_, _, _, _, _, 'Disciplina não cadastrada!').











