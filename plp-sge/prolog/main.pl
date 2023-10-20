%Comando pra rodar 
% swipl -s main.pl

% Inclusão da base de dados
:- consult('DataBase/gerenciadorAluno.pl').
:- consult('constantes.pl').

% Inclusão das funções das entidades
:- include('aluno.pl').

% Inclusão dos utilitários
/*:- consult('utils.pl').
:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).
:- use_module(library(http/json)).
:- use_module(library(date)).
:- use_module(library(random)).
*/

%Recebe os dados do usuário
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

%Menu responsável por fazer o login
menuLogin :-
    prompt('Matrícula: ', Matricula),
    verificaLogin(Matricula, AlunoCadastrado),
    (
        AlunoCadastrado = false ->
        write('Cadastro não encontrado :/'), nl,
        menuEscolhaLogin;
        prompt('Senha: ', SenhaInput),
        verificaSenhaAluno(Matricula, SenhaInput, SenhaCorreta),
        (
            SenhaCorreta = false ->
            write('Senha incorreta! '),
            menuEscolhaLogin;
            menuInicial(Matricula)
        )
    ).

menuEscolhaLogin:-
    write('\nEscolha uma opção para seguir\n'),
    write('1. Tentar Fazer login novamente\n'),
    write('2. Fazer cadastro\n'),
    write('3. Sair\n'),
    prompt('->', Input),
    atom_number(Input, Opcao),
    write('\n'),
    verificaEscolha(Opcao).

verificaEscolha(1):-
    menuLogin.

verificaEscolha(2):-
    menuCadastro.

verificaEscolha(3):-
    write('Saindo...\n'),
    halt.

verificaEscolha(_):-
    write('Opção inválida'),
    menuEscolhaLogin.

%Menu resonsável por fazer o cadastro 
/*menuCadastro :-
    prompt('Matrícula: ', MatriculaCadastrada),
    prompt('Nome: ', Nome),
    prompt('Senha: ', Senha),
    verificaLogin(MatriculaCadastrada, MatriculaJaCadastrada),
    (   MatriculaJaCadastrada = false
    ->  cadastraAluno(MatriculaCadastrada, Nome, Senha, Result),
        write(Result),
        menuInicial(MatriculaCadastrada)
    ;   write('Aluno já cadastrado! '),
        menuEscolhaLogin
    ). */

menuCadastro:-
    prompt('Matrícula: ', MatriculaCadastrada),
    prompt('Nome: ', Nome),
    prompt('Senha: ', Senha),
    cadastraAluno(MatriculaCadastrada, Nome, Senha, Result),
    write(Result),
    menuInicial(MatriculaCadastrada).



% Menu para mostra as opções do SGE para o usuário.
menuInicial(Matricula):-
    writeln('\nEscolha uma opção:\n'),
    write('1. Criar grupo\n'),
    write('2. Remover grupo\n'),
    write('3. Meus grupos\n'),
    write('4. Minhas disciplinas\n'),
    write('5. Procurar Grupo\n'),
    write('6. Voltar\n'),
    prompt('->', Input),
    atom_number(Input, Opcao),
    write('\n'),
    selecaoMenuInicial(Opcao, Matricula).

%Criar grupo
selecaoMenuInicial(1, Matricula):-
    writeln('\n==Cadastrando Grupo==\n'),
    prompt('Nome do grupo: ', NomeGrupo),
    prompt('Código do grupo: ', CodGrupo),
    cadastraGrupo(NomeGrupo, CodGrupo, Result),
    write(Result),
    menuInicial(Matricula).

%Remover grupo
selecaoMenuInicial(2, Matricula):-
    writeln('\n==Removendo Grupo==\n'),
    prompt('Código do grupo: ', CodGrupo),
    removeGrupo(CodGrupo, Result),
    write(Result),
    menuInicial(Matricula).

%Acessando grupos
selecaoMenuInicial(3, Matricula):-
    menuMeusGrupos(Matricula).
    %menuInicial(Matricula).

selecaoMenuInicial(4, Matricula):-
    menuMinhasDisciplinas(Matricula).
    %menuInicial(Matricula).

%Listagem de grupos em comum
selecaoMenuInicial(5, Matricula):-
    listagemGruposEmComum(Matricula, Result),
    write(Result),
    menuInicial(Matricula).

%Voltando para o menu
selecaoMenuInicial(6, _):-
    main.

selecaoMenuInicial(_, Matricula):-
    write('Opção inválida'),
    menuInicial(Matricula).


%Menu específico para as funções dos grupos.
menuMeusGrupos(Matricula):-
    writeln('\nEscolha o que você quer fazer\n'),
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
    selecaoMenuMeusGrupos(Opcao, Matricula).


    %Adicionar aluno
    selecaoMenuMeusGrupos(1, Matricula):-
        prompt('Matrícula do aluno a ser adicionado: ', MatriculaAluno),
        prompt('Código do grupo: ', CodGrupo),
        adicionaAlunoGrupo(Matricula, MatriculaAluno, CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula).

     %Remover aluno
    selecaoMenuMeusGrupos(2, Matricula):-
        prompt('Matrícula do aluno a ser removido: ', MatriculaAluno),
        prompt('Código do grupo: ', CodGrupo),
        removeAlunoGrupo(Matricula, MatriculaAluno, CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula).

    %Visualizar Alunos
    selecaoMenuMeusGrupos(3, Matricula):-
        prompt('Código do grupo para listar os alunos: ', CodGrupo),
        listagemAlunosGrupo(CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula).

    %Adicionar Disciplina
    selecaoMenuMeusGrupos(4, Matricula):-
        prompt('Código do grupo: ', CodGrupo),
        prompt('Código da disciplina que você quer adicionar: ', IdDiscilina),
        prompt('Nome da disciplina: ', NomeDiscilina),
        prompt('Nome do professor: ', NomeProfessor),
        prompt('Período: ', Periodo),
        cadastraDisciplinaGrupo(CodGrupo, IdDiscilina, NomeDiscilina, NomeProfessor, Periodo, Result),
        write(Result),
        menuMeusGrupos(Matricula).

    %Visualizar Disciplina
    selecaoMenuMeusGrupos(5, Matricula):-
        prompt('Código do grupo: ', CodGrupo),
        listagemDisciplinaGrupo(CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula).

    %Remover Disciplina
    selecaoMenuMeusGrupos(6, Matricula):-
        prompt('Código da disciplina que você quer remover: ', IdDiscilina),
        prompt('Código do grupo: ', CodGrupo),
        removeDisciplinaGrupo(IdDiscilina, CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula).
   
    %Acessar Materiais
    selecaoMenuMeusGrupos(7, Matricula):-
        menuMateriaisGrupo (Matricula).
        %menuMeusGrupos(Matricula).
    
    %Ver grupos
    selecaoMenuMeusGrupos(8, Matricula):-
        write('\nEsses são os seus grupos: \n'),
        listagemGrupos(Matricula, Result),
        write(Result),
        menuMeusGrupos(Matricula).
   
    %Voltar para o menu inicial
    selecaoMenuMeusGrupos(9, Matricula):-
        menuInicial(Matricula).
    
    %Entrada inválida
    selecaoMenuMeusGrupos(_, Matricula):-
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
    writeln('\nSelecione o tipo de material que você gostaria de cadastrar:\n'),
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
