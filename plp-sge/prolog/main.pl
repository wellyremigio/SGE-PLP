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
    %menuMeusGrupos(1),
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


menuMeusGrupos(Matricula):-
    writeln('\nEscolha o que você quer fazer: '),
    write('1. Adicionar Aluno\n'),
    write('2. Remover Aluno\n'),
    write('3. Visualizar Alunos\n'),
    write('4. Adicionar Disciplina\n'),
    write('5. Visualizar Disciplina\n'),
    write('6. Remover Disciplina\n'),
    write('7. Acessar Materiais\n'),
    write('8. Ver grupos\n'),
    write('9. Voltar\n'),
    prompt('->', Input),
    atom_number(Input, Opcao),
    write('\n'),
    opSelecionadaMeusGrupos(Opcao, Matricula).


    %Adicionar aluno
    opSelecionadaMeusGrupos(1, Matricula):-
        prompt('Matrícula do aluno a ser adicionado: ', MatriculaAluno),
        prompt('Código do grupo: ', CodGrupo),
        adicionaAlunoGrupo(Matricula, MatriculaAluno, CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula).

     %Remover aluno
    opSelecionadaMeusGrupos(2, Matricula):-
        prompt('Matrícula do aluno a ser removido: ', MatriculaAluno),
        prompt('Código do grupo: ', CodGrupo),
        removeAlunoGrupo(Matricula, MatriculaAluno, CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula).

    %Visualizar Alunos
    opSelecionadaMeusGrupos(3, Matricula):-
        prompt('Código do grupo para listar os alunos: ', CodGrupo),
        listagemAlunosGrupo(CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula).

    %Adicionar Disciplina
    opSelecionadaMeusGrupos(4, Matricula):-
        prompt('Código do grupo: ', CodGrupo),
        prompt('Código da disciplina que você quer adicionar: ', IdDiscilina),
        prompt('Nome da disciplina: ', NomeDiscilina),
        prompt('Nome do professor: ', NomeProfessor),
        prompt('Período: ', Periodo),
        cadastraDisciplinaGrupo(CodGrupo, IdDiscilina, NomeDiscilina, NomeProfessor, Periodo, Result),
        write(Result),
        menuMeusGrupos(Matricula).

    %Visualizar Disciplina
    opSelecionadaMeusGrupos(5, Matricula):-
        prompt('Código do grupo: ', CodGrupo),
        listagemDisciplinaGrupo(CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula).

    %Remover Disciplina
    opSelecionadaMeusGrupos(6, Matricula):-
        prompt('Código da disciplina que você quer remover: ', IdDiscilina),
        prompt('Código do grupo: ', CodGrupo),
        removeDisciplinaGrupo(IdDiscilina, CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula).
   
    %Acessar Materiais
    opSelecionadaMeusGrupos(7, Matricula):-
        menuMateriaisGrupo (Matricula).
        %menuMeusGrupos(Matricula).
    
    %Ver grupos
    opSelecionadaMeusGrupos(8, Matricula):-
        write('\nEsses são os seus grupos: \n'),
        listagemGrupos(Matricula, Result),
        write(Result),
        menuMeusGrupos(Matricula).
   
    %Voltar para o menu inicial
    opSelecionadaMeusGrupos(9, Matricula):-
        menuInicial.
    
    opSelecionadaMeusGrupos(_, Matricula):-
        write('Opção inválida'),
        menuMeusGrupos(Matricula).





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
    menuMinhasDisciplinas(Matricula).
    
opselecionadaDisciplinaAluno(3, Matricula) :-
    menuMinhasDisciplinas(Matricula).
    
opselecionadaDisciplinaAluno(4, Matricula) :-
    menuMinhasDisciplinas(Matricula).
    
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