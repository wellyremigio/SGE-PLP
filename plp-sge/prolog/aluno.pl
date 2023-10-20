:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).

:- include('constantes.pl').
:- consult('DataBase/gerenciadorGeral.pl').



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