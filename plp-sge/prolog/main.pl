%Comando pra rodar 
% swipl -s main.pl


% Inclusão dos utilitários
:- consult('utils.pl').
:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).
:- use_module(library(http/json)).
:- use_module(library(date)).
:- use_module(library(random)).

prompt(Message, String):-
    write(Message),
    flush_output,
    read_line_to_codes(user_input, Codes),
    string_codes(String, Codes).

main:-
    writeln( '\n =========== Olá! Seja bem vindo ao SGE: Sistema de Gerenciamento de Estudos :D ===========\n'),
    write('\n Escolha uma opção para começar a navegar no sistema: \n'),
    write('1. Login\n'),
    write('2. Cadastrar\n'),
    write('3. Sair\n'),
    prompt('->', Input),
    atom_number(Input, Opcao),
    write('\n'),
    opSelecionada(Opcao).

opSelecionada(1):-
    menuLogin,
    main.

opSelecionada(2):-
    menuCadastro,
    main.

opSelecionada(3):-
    write('Saindo...\n'),
    halt.

opSelecionada(_):-
    write('Ops! Entrada Inválida...\n'),
    main.



menuMinhasDisciplinas(Matricula) :-
    write('\n1. Visualizar disciplinas\n'),
    write('2. Cadastrar disciplina\n'),
    write('3. Remover disciplina\n'),
    write('4. Materiais\n'),
    write('5. Voltar\n'),
    write('6. Sair\n'),
    read(Opcao),
    opselecionadaDisciplinaAluno(Opcao, Matricula).

    
opselecionadaDisciplinaAluno(1, Matricula) :-
    menuMinhasDisciplinas(Matricula).
    
opselecionadaDisciplinaAluno(2, Matricula) :-
    prompt('O código da disciplina que você quer cadastrar: ', Codigo),
    prompt('Nome da disciplina: ', Nome),
    prompt('Professor que ministra: ',Professor),
    prompt('Período: ', Periodo),
    menuMinhasDisciplinas(Matricula).
    
opselecionadaDisciplinaAluno(3, Matricula) :-
    prompt('Código da discplina que você quer remover: ', Codigo),
    menuMinhasDisciplinas(Matricula).
    
opselecionadaDisciplinaAluno(4, Matricula) :-
menuCadastraMateriaisAluno(Matricula).
    
opselecionadaDisciplinaAluno(5, Matricula) :-
    menuMinhasDisciplinas(Matricula).
    
opselecionadaDisciplinaAluno(6, Matricula) :-
    write('Saindo...'), 
    halt.


menuCadastraMateriaisAluno(Matricula) :-
    write('\nSelecione o tipo de material que você gostaria de cadastrar:\n'),
    write('1. Resumo\n'),
    write('2. Links\n'),
    write('3. Datas\n'),
    write('4. Voltar\n'),
    read(Opcao),
    selecionaMenuCadastroMateriaisAluno(Opcao, Matricula).


opselecionadaCadastroMateriaisAluno(1, Matricula) :-
    prompt('Código da disciplina: ', Codigo),
    prompt('Nome do resumo: ', Nome),
    prompt('Conteúdo do resumo: ',Resumo),
    menuCadastraMateriaisAluno(Matricula) :-

        putStrLn "\nID disciplina: "
        idDisciplina <- readLn :: IO Int
        putStrLn "Titulo: "
        titulo <- getLine
        putStrLn "Data Inicio: "
        dti <- getLine
        putStrLn "Data Fim: "

opselecionadaCadastroMateriaisAluno(2, Matricula) :-
    prompt('Código da disciplina: ', Codigo),
    prompt('Titulo: ', Titulo),
    prompt('Link: ',Link),
    menuCadastraMateriaisAluno(Matricula) :-

opselecionadaCadastroMateriaisAluno(3, Matricula) :-
    prompt('Código da disciplina: ', Codigo),
    prompt('Titulo: ', Titulo),
    prompt('Data início: ',DataI),
    prompt('Data fim: ',DataF),
    menuCadastraMateriaisAluno(Matricula) :-

opselecionadaCadastroMateriaisAluno(4, Matricula) :-
    menuMinhasDisciplinas(Matricula).