:- initialization (main).

%Comando pra rodar 
% swipl -s main.pl

% Inclusão da base de dados
:- consult('DataBase/gerenciadorGeral.pl').
:- consult('DataBase/gerenciadorAluno.pl').
:- consult('DataBase/gerenciadorGrupo.pl').

:- consult('constantes.pl').

:- include('aluno.pl').
:- include('grupo.pl').

% Inclusão dos utilitários
:- consult('utils.pl').
:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).
:- use_module(library(http/json)).
:- use_module(library(date)).
:- use_module(library(random)).

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
    prompt('----> ', Input),
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
    write('Ops! Entrada Invalida...\n'),
    main.

%Menu responsável por fazer o login
menuLogin:-
    prompt('Matrícula: ', Matricula),
    (verificaLogin(Matricula) ->
        prompt('Senha: ', Senha),
        (verificaSenhaAluno(Matricula, Senha) ->
            menuInicial(Matricula)
        ;
            write('Senha incorreta, tente novamente. \n'),
            menuLogin)
    ;
        write('Aluno não encontrado!'), 
        menuEscolhaLogin
    ).


menuEscolhaLogin:-
    write('\nEscolha uma opção para seguir\n'),
    write('1. Fazer login \n'),
    write('2. Fazer cadastro\n'),
    write('3. Sair\n'),
    prompt('----> ', Input),
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
menuCadastro :-
    prompt('Matrícula: ', Matricula),
    prompt('Nome: ', Nome),
    prompt('Senha: ', Senha),
    cadastraAluno(Matricula, Nome, Senha, ResultParcial),
    (ResultParcial = 'ok' -> 
        write('Aluno Cadastrado'),
        menuInicial(Matricula)
        ;
        write('Não foi possível fazer o cadastro'),
        menuEscolhaLogin).


% Menu para mostra as opções do SGE para o usuário.
menuInicial(Matricula):-
    writeln('\nEscolha uma opção:\n'),
    write('1. Criar grupo\n'),
    write('2. Remover grupo\n'),
    write('3. Meus grupos\n'),
    write('4. Minhas disciplinas\n'),
    write('5. Procurar Grupo\n'),
    write('6. Sair\n'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    write('\n'),
    selecaoMenuInicial(Opcao, Matricula).

%Criar grupo
selecaoMenuInicial(1, Matricula):-
    writeln('\n==Cadastrando Grupo==\n'),
    prompt('Código do grupo: ', CodGrupo),
    prompt('Nome do grupo: ', NomeGrupo),
    cadastraGrupo(CodGrupo, NomeGrupo, Matricula, Result),
    adicionaAlunoGrupo(CodGrupo, Matricula),
    (Result = 'ok' ->
        write('Grupo Cadastrado'),
        menuMeusGrupos(Matricula)
    ;
        write('Já existe um grupo com esse ID. Cadastre um grupo novo!\n'),
        menuInicial(Matricula)
    ). 

%Remover grupo
selecaoMenuInicial(2, Matricula):-
    writeln('\n==Removendo Grupo==\n'),
    prompt('Código do grupo: ', CodGrupo),
    verificaAdm(CodGrupo, Matricula, Result1),
    (Result1 = 1 ->
        (removeGrupo(CodGrupo, Matricula) ->
            write('Grupo removido'),
            menuInicial(Matricula)
        ;
            write('Grupo não encontrado'),
            menuInicial(Matricula)
        )
    ;
        write('Não é administrador do grupo e não pode remover'),
        menuInicial(Matricula)
    ).


%Acessando grupos
selecaoMenuInicial(3, Matricula):-
    menuMeusGrupos(Matricula).

%Acessando as disciplinas
selecaoMenuInicial(4, Matricula):-
    menuMinhasDisciplinas(Matricula).


%Listagem dos grupos 
selecaoMenuInicial(5, Matricula):-
    listagemGrupos(Result),
    (Result = 'Não existem grupos cadastrados' ->
        write(Result)
    ;
        write(Result),
        menuInicial(Matricula)
    ).

%Voltando para o menu
selecaoMenuInicial(6, _):-
    write('Saindo...\n'),
    halt.

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
    write('8. Ver meus grupos\n'),
    write('9. Voltar\n'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    write('\n'),
    selecaoMenuMeusGrupos(Opcao, Matricula).

    %Adicionar aluno
selecaoMenuMeusGrupos(1, Matricula):-
        prompt('Matrícula do aluno a ser adicionado: ', MatriculaAluno),
        prompt('Código do grupo: ', CodGrupo),
        (verificaGrupo(CodGrupo) ->
            (verifica_adm(CodGrupo, Matricula) -> 
                (valida_aluno(MatriculaAluno) -> 
                    ( \+ verifica_aluno_grupo(CodGrupo, MatriculaAluno) ->
                        adicionaAlunoGrupo(CodGrupo, MatriculaAluno),
                        write('Cadastrado com sucesso')
                    ;write('Aluno já esta no grupo') )
                ; write('Aluno não cadastrado'))
            ; write('Aluno não é adm do grupo'))
        ; write('Grupo não cadastrado')),
        menuMeusGrupos(Matricula).

     %Remover aluno
selecaoMenuMeusGrupos(2, Matricula):-
    prompt('Matrícula do aluno a ser removido: ', MatriculaAluno),
        prompt('Código do grupo: ', CodGrupo),
        (verificaGrupo(CodGrupo) ->
            (verifica_adm(CodGrupo, Matricula) -> 
                (valida_aluno(MatriculaAluno) -> 
                    ( verifica_aluno_grupo(CodGrupo, MatriculaAluno) ->
                        removeAlunoGrupo(CodGrupo, MatriculaAluno),
                        write('Aluno removido com sucesso')
                    ;write('Aluno já esta no grupo') )
                ; write('Aluno não cadastrado'))
            ; write('Aluno não é adm do grupo'))
        ; write('Grupo não cadastrado')),
        menuMeusGrupos(Matricula).
        
%Visualizar Alunos
selecaoMenuMeusGrupos(3, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        listagemAlunosGrupo(CodGrupo, Result),
        write(Result),
        menuMeusGrupos(Matricula)
    ;
        write('Grupo não encontrado'),
        menuMeusGrupos(Matricula)
    ).

%Adicionar Disciplina
selecaoMenuMeusGrupos(4, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina que você quer adicionar: ', IdDisciplina),
    prompt('Nome da disciplina: ', NomeDisciplina),
    prompt('Nome do professor: ', NomeProfessor),
    prompt('Período: ', Periodo),
    cadastraDisciplinaGrupo(CodGrupo, IdDisciplina, NomeDisciplina, NomeProfessor, Periodo, Result),
    write(Result),
    menuMeusGrupos(Matricula).

%Visualizar Disciplina
selecaoMenuMeusGrupos(5, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        listagemDisciplinaGrupo(CodGrupo, Result),
        (
            Result = '' ->
                write('Nenhuma disciplina cadastrada');
            true ->
                write(Result)
        ),
        menuMeusGrupos(Matricula)
    ;
        write('Grupo não encontrado'),
        menuMeusGrupos(Matricula)
    ).


%Remover Disciplina
%verifica se o grupo existe
selecaoMenuMeusGrupos(6, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        
        prompt('Código da disciplina que você quer remover: ', IdDiscilina),
        removeDisciplinaGrupo(CodGrupo, IdDiscilina, Result),
        write(Result),
        menuMeusGrupos(Matricula)
    ;
        write('Grupo não cadastrado'),
        menuMeusGrupos(Matricula)
    ).

%Acessar Materiais
selecaoMenuMeusGrupos(7, Matricula):-
    menuMateriaisGrupo(Matricula).
   
%Ver grupos
selecaoMenuMeusGrupos(8, Matricula) :-
    write('\nEsses são os seus grupos: \n'),
    listagemMeusGrupos(Matricula, Result),
    write(Result),
    menuMeusGrupos(Matricula).

%Voltar para o menu inicial
selecaoMenuMeusGrupos(9, Matricula):-
    menuInicial(Matricula).

%Entrada inválida
selecaoMenuMeusGrupos(_, Matricula):-
    write('Opção inválida'),
    menuMeusGrupos(Matricula).


%Menu específico para o cadastro de materiais no grupo
menuMateriaisGrupo(Matricula) :-
    writeln('\n1. Ver materiais'),
    writeln('2. Adicionar materiais'),
    writeln('3. Remover materiais'),
    writeln('4. Editar materiais'),
    writeln('5. Comentar no material'),
    writeln('6. Ver Comentarios do material'),
    writeln('7. Voltar'),
    writeln('8. Sair'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    write('\n'),
    opselecionadaMateriaisGrupo(Opcao, Matricula).

opselecionadaMateriaisGrupo(1, Matricula):-
    menuConsultaGrupo(Matricula).

opselecionadaMateriaisGrupo(2, Matricula):-
    menuCadastraMateriaisGrupo(Matricula).

opselecionadaMateriaisGrupo(3, Matricula):-
    menuRemoverMateriaisGrupo(Matricula).

opselecionadaMateriaisGrupo(4, Matricula):-
    menuEditaMateriais(Matricula).
    
opselecionadaMateriaisGrupo(5, Matricula):-
    selecionaMaterialComentario(3, Matricula).

opselecionadaMateriaisGrupo(6, Matricula):-
    menuVerComentarioMaterial(Matricula).

opselecionadaMateriaisGrupo(7, Matricula):-
    menuMeusGrupos(Matricula).

opselecionadaMateriaisGrupo(8, Matricula):-
    write('Saindo...'), 
    halt.

opselecionadaMateriaisGrupo(_, Matricula):- 
    write('\nOpcão inválida!\n'),   
    menuMeusGrupos(Matricula).

%Menu para consultar materiais
menuConsultaGrupo(Matricula) :-
    writeln('\nQual o tipo de material que deseja consultar?'),
    writeln('1. Resumo'),
    writeln('2. Link'),
    writeln('3. Data'),
    writeln('4. Voltar'),
    writeln('5. Sair'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    selecionaMenuConsultaGrupo(Opcao, Matricula).

selecionaMenuConsultaGrupo(1, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('ID do Resumo: ', Id),
        visualiza_resumo_grupo(CodGrupo, IdDisciplina, Id, Result),
        write(Result),
        menuConsultaGrupo(Matricula)
    ;
        write('Grupo não cadastrado'),
        menuConsultaGrupo(Matricula)
    ).

selecionaMenuConsultaGrupo(2, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('ID do Link: ', Id),
        visualiza_link_grupo(CodGrupo, IdDisciplina, Id, Result),
        write(Result),
        menuConsultaGrupo(Matricula)
    ;
        write('Grupo não cadastrado'),
        menuConsultaGrupo(Matricula)
    ).


selecionaMenuConsultaGrupo(3, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('ID da Data: ', Id),
        visualiza_data_grupo(CodGrupo, IdDisciplina, Id, Result),
        write(Result),
        menuConsultaGrupo(Matricula)
    ;
        write('Grupo não cadastrado'),
        menuConsultaGrupo(Matricula)
    ).

selecionaMenuConsultaGrupo(4, Matricula):-
    menuMateriaisGrupo(Matricula).

selecionaMenuConsultaGrupo(5, Matricula):-
    write('Saindo...'), 
    halt.

selecionaMenuConsultaGrupo(_, Matricula):-
    write('\nOpcão inválida!\n'), 
    menuConsultaGrupo(Matricula).


%Menu para cadastrar materiais
menuCadastraMateriaisGrupo(Matricula) :-
    writeln('\nSelecione o tipo de material que você gostaria de cadastrar:\n'),
    write('1. Resumo\n'),
    write('2. Links\n'),
    write('3. Datas\n'),
    write('4. Voltar\n'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    write('\n'),
    opselecionadaCadastraMateriaisGrupo(Opcao, Matricula).

opselecionadaCadastraMateriaisGrupo(1, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('Nome do resumo: ', Nome),
        prompt('Conteúdo do resumo: ', Resumo),
        add_resumo_disciplina_grupo(CodGrupo, IdDisciplina, Nome, Resumo, Result),
        write(Result),
        menuCadastraMateriaisGrupo(Matricula)
    ;
        write('Grupo não cadastrado'),
        menuCadastraMateriaisGrupo(Matricula)
    ).

opselecionadaCadastraMateriaisGrupo(2, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('Titulo: ', Titulo),
        prompt('Link: ', Link),
        add_link_disciplina_grupo(CodGrupo, IdDisciplina, Titulo, Link, Result),
        write(Result),
        menuCadastraMateriaisGrupo(Matricula)
    ;
        write('Grupo não cadastrado'),
        menuCadastraMateriaisGrupo(Matricula)
    ).

opselecionadaCadastraMateriaisGrupo(3, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('Titulo: ', Titulo),
        prompt('Data início: ', DataI),
        prompt('Data fim: ', DataF),
        add_data_disciplina_grupo(CodGrupo, IdDisciplina, Titulo, DataI, DataF, Result),
        write(Result),
        menuCadastraMateriaisGrupo(Matricula)
    ;
        write('Grupo não cadastrado'),
        menuCadastraMateriaisGrupo(Matricula)
    ).

opselecionadaCadastraMateriaisGrupo(4, Matricula) :-
    menuMateriaisGrupo(Matricula).

opselecionadaCadastraMateriaisGrupo(_, Matricula):- 
    write('\nOpcão inválida!\n'),
    menuCadastraMateriaisGrupo(Matricula).


%Menu para remover materiais
menuRemoverMateriaisGrupo(Matricula) :-
    writeln('\nSelecione o tipo de material que você gostaria de remover:'),
    write('1. Resumo\n'),
    write('2. Links\n'),
    write('3. Datas\n'),
    write('4. Voltar\n'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    selecionaMenuRemoveMateriaisGrupo(Opcao, Matricula).

selecionaMenuRemoveMateriaisGrupo(1, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('ID do Resumo: ', Id),
        remove_resumo_grupo(CodGrupo, IdDisciplina, Id, Result),
        write(Result),
        menuRemoverMateriaisGrupo(Matricula)
    ;
        write('Grupo não cadastrado'),
        menuRemoverMateriaisGrupo(Matricula)
    ).

selecionaMenuRemoveMateriaisGrupo(2, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('ID do Link: ', Id),
        remove_link_grupo(CodGrupo, IdDisciplina, Id, Result),
        write(Result),
        menuRemoverMateriaisGrupo(Matricula)
    ;
        write('Grupo não cadastrado'),
        menuRemoverMateriaisGrupo(Matricula)
    ).

selecionaMenuRemoveMateriaisGrupo(3, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('ID da Data: ', Id),
        remove_data_grupo(CodGrupo, IdDisciplina, Id, Result),
        write(Result),
        menuRemoverMateriaisGrupo(Matricula)
    ;
        write('Grupo não cadastrado'),
        menuRemoverMateriaisGrupo(Matricula)
    ).
    

selecionaMenuRemoveMateriaisGrupo(4, Matricula):-
    menuMateriaisGrupo(Matricula).

selecionaMenuRemoveMateriaisGrupo(_, Matricula):-
    write('\nOpcão inválida!\n'), 
    menuRemoverMateriaisGrupo(Matricula).


menuMinhasDisciplinas(Matricula) :-
    write('\n1. Visualizar disciplinas\n'),
    write('2. Cadastrar disciplina\n'),
    write('3. Remover disciplina\n'),
    write('4. Materiais\n'),
    write('5. Voltar\n'),
    write('6. Sair\n'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    write('\n'),
    opselecionadaDisciplinaAluno(Opcao, Matricula).

    
opselecionadaDisciplinaAluno(1, Matricula) :-
    exibe_disciplinas(Matricula,Result),
    write(Result),
    menuMinhasDisciplinas(Matricula).
    
opselecionadaDisciplinaAluno(2, Matricula) :-
    prompt('O código da disciplina que você quer cadastrar: ', Codigo),
    prompt('Nome da disciplina: ', Nome),
    prompt('Professor que ministra: ',Professor),
    prompt('Período: ', Periodo),
    cadastra_disciplina_aluno(Matricula, Codigo, Nome, Professor, Periodo, Result),
    write(Result),
    menuMinhasDisciplinas(Matricula).
    
opselecionadaDisciplinaAluno(3, Matricula) :-
    prompt('Código da disciplina que você quer remover: ', Codigo),
    rm_disciplina_aluno(Matricula, Codigo, Result),
    write(Result),
    menuMinhasDisciplinas(Matricula).
    
opselecionadaDisciplinaAluno(4, Matricula) :-
    menuMateriaisAluno(Matricula).

opselecionadaDisciplinaAluno(5, Matricula) :-
    menuInicial(Matricula).
       
opselecionadaDisciplinaAluno(6, Matricula) :-
    write('Saindo...'), 
    halt.

opselecionadaDisciplinaAluno(_,Matricula) :- write('Opcão inválida!'), menuMinhasDisciplinas(Matricula).


menuCadastraMateriaisAluno(Matricula) :-
    writeln('\nSelecione o tipo de material que você gostaria de cadastrar:\n'),
    write('1. Resumo\n'),
    write('2. Links\n'),
    write('3. Datas\n'),
    write('4. Voltar\n'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    write('\n'),
    opselecionadaCadastraMateriaisAluno(Opcao, Matricula).


opselecionadaCadastraMateriaisAluno(1, Matricula) :-
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('Nome do resumo: ', Nome),
    prompt('Conteúdo do resumo: ', Resumo),
    add_resumo_disciplina_aluno(Matricula, IdDisciplina, Nome, Resumo, Result),
    write(Result),
    menuCadastraMateriaisAluno(Matricula).

opselecionadaCadastraMateriaisAluno(2, Matricula) :-
    prompt('Código da disciplina: ', Codigo),
    prompt('Titulo: ', Titulo),
    prompt('Link: ', Link),
    add_link_disciplina_aluno(Matricula, Codigo, Titulo, Link, Result),
    write(Result),
    menuCadastraMateriaisAluno(Matricula).

opselecionadaCadastraMateriaisAluno(3, Matricula) :-
    prompt('Código da disciplina: ', Codigo),
    prompt('Titulo: ', Titulo),
    prompt('Data início: ', DataI),
    prompt('Data fim: ', DataF),
    add_data_disciplina_aluno(Matricula, Codigo, Titulo, DataI, DataF, Result),
    write(Result),
    menuCadastraMateriaisAluno(Matricula).

opselecionadaCadastraMateriaisAluno(4, Matricula) :-
    menuMinhasDisciplinas(Matricula).

opselecionadaCadastraMateriaisAluno(_, Matricula):- 
    write('\nOpcão inválida!\n'),
    menuCadastraMateriaisAluno(Matricula).

menuMateriaisAluno(Matricula) :-
    writeln('\n1. Ver materiais'),
    writeln('2. Adicionar materiais'),
    writeln('3. Remover materiais'),
    writeln('4. Voltar'),
    writeln('5. Sair'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    write('\n'),
    opselecionadaMateriaisAluno(Opcao, Matricula).

opselecionadaMateriaisAluno(1, Matricula):-
    menuConsultaAluno(Matricula).

opselecionadaMateriaisAluno(2, Matricula):-
    menuCadastraMateriaisAluno(Matricula).

opselecionadaMateriaisAluno(3, Matricula):-
    menuRemoverMateriais(Matricula).

opselecionadaMateriaisAluno(4, Matricula):-
    menuMinhasDisciplinas(Matricula).

opselecionadaMateriaisAluno(5, Matricula):-
    write('Saindo...'), 
    halt.

opselecionadaMateriaisAluno(_, Matricula):- 
    write('\nOpcão inválida!\n'),   
    menuMateriaisAluno(Matricula).

menuRemoverMateriais(Matricula) :-
    writeln('\nSelecione o tipo de material que você gostaria de remover:'),
    write('1. Resumo\n'),
    write('2. Links\n'),
    write('3. Datas\n'),
    write('4. Voltar\n'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    selecionaMenuRemoveMateriaisAluno(Opcao, Matricula).

selecionaMenuRemoveMateriaisAluno(1, Matricula):-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID do Resumo: ', Id),
    remove_resumo_aluno(Matricula, Codigo, Id, Result),
    write(Result),
    menuRemoverMateriais(Matricula).

selecionaMenuRemoveMateriaisAluno(2, Matricula):-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID do Link: ', Id),
    remove_link_aluno(Matricula, Codigo, Id, Result),
    write(Result),
    menuRemoverMateriais(Matricula).

selecionaMenuRemoveMateriaisAluno(3, Matricula):-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID da Data: ', Id),
    remove_data_aluno(Matricula, Codigo, Id, Result),
    write(Result),
    menuRemoverMateriais(Matricula).
    

selecionaMenuRemoveMateriaisAluno(4, Matricula):-
    menuMateriaisAluno(Matricula).

selecionaMenuRemoveMateriaisAluno(_, Matricula):-
    write('\nOpcão inválida!\n'), 
    menuRemoverMateriais(Matricula).

menuConsultaAluno(Matricula) :-
    writeln('\nQual o tipo de material que deseja consultar?'),
    writeln('1. Resumo'),
    writeln('2. Link'),
    writeln('3. Data'),
    writeln('4. Voltar'),
    writeln('5. Sair'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    selecionaMenuConsultaAluno(Opcao, Matricula).

selecionaMenuConsultaAluno(1, Matricula) :-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID do Resumo: ', Id),
    visualiza_resumo(Matricula, Codigo, Id, Result),
    writeln(Result),
    menuConsultaAluno(Matricula).

selecionaMenuConsultaAluno(2, Matricula):-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID do Link: ', Id),
    visualiza_link(Matricula, Codigo, Id, Result),
    writeln(Result),
    menuConsultaAluno(Matricula).

selecionaMenuConsultaAluno(3, Matricula):-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID da Data: ', Id),
    visualiza_data(Matricula, Codigo, Id, Result),
    writeln(Result),
    menuConsultaAluno(Matricula).

selecionaMenuConsultaAluno(4, Matricula):-
    menuMateriaisAluno(Matricula).

selecionaMenuConsultaAluno(5, Matricula):-
    write('Saindo...'), 
    halt.

selecionaMenuConsultaAluno(_, Matricula):-
    write('\nOpcão inválida!\n'), 
    menuConsultaAluno(Matricula).


menuComentarMaterial(Matricula) :-
    writeln('\nVocê deseja comentar qual material?'),
    writeln('1. Resumo'),
    writeln('2. Link'),
    writeln('3. Data'),
    writeln('4. Voltar'),
    writeln('5. Sair'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    selecionaMaterialComentario(Opcao, Matricula).

selecionaMaterialComentario(1, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID do resumo: ', Id),
    prompt('Comentario a ser enviado: ', Comentario),
    add_comentario_resumo(Matricula, CodGrupo, IdDisciplina, Id,Comentario, Result),
    write(Result),
    menuComentarMaterial(Matricula).

selecionaMaterialComentario(2, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID do link: ', Id),
    prompt('Comentario a ser enviado: ', Comentario),
    add_comentario_link(Matricula, CodGrupo, IdDisciplina, Id, Comentario, Result),
    write(Result),
    menuComentarMaterial(Matricula).


selecionaMaterialComentario(3, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID da data: ', Id),
    prompt('Comentario a ser enviado: ', Comentario),
    add_comentario_data(Matricula, CodGrupo, IdDisciplina, Id, Comentario, Result),
    write(Result),
    menuComentarMaterial(Matricula).

selecionaMaterialComentario(4, Matricula):-
    menuMateriaisGrupo(Matricula).

selecionaMaterialComentario(5, Matricula):-
    write('Saindo...'), 
    halt.

selecionaMaterialComentario(_, Matricula):-
    write('\nOpcão inválida!\n'),
    menuComentarMaterial(Matricula).


menuVerComentarioMaterial(Matricula) :-
    writeln('\nVocê deseja ver os comentários de qual material?'),
    writeln('1. Resumo'),
    writeln('2. Link'),
    writeln('3. Data'),
    writeln('4. Voltar'),
    writeln('5. Sair'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    selecionaVerComentarioMaterial(Opcao,Matricula).


selecionaVerComentarioMaterial(1, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID do resumo: ', Id),
    comentarios_resumo(Matricula, CodGrupo,IdDisciplina, Id, Result),
    write(Result),
    menuVerComentarioMaterial(Matricula).

selecionaVerComentarioMaterial(2, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID do link: ', Id),
    comentarios_link(Matricula, CodGrupo,IdDisciplina, Id, Result),
    write(Result),
    menuVerComentarioMaterial(Matricula).

selecionaVerComentarioMaterial(3, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID da data: ', Id),
    comentarios_data(Matricula, CodGrupo,IdDisciplina, Id, Result),
    write(Result),
    menuVerComentarioMaterial(Matricula).

selecionaVerComentarioMaterial(4, Matricula) :-
    menuMateriaisGrupo(Matricula).


selecionaVerComentarioMaterial(5, Matricula) :-
    write('Saindo...'), 
    halt.

selecionaVerComentarioMaterial(_, Matricula) :-
    write('\nOpção inválida.\n'), 
    menuVerComentarioMaterial(Matricula).

menuEditaMateriais(Matricula):-
    writeln('\nQual material você deseja alterar:'),
    writeln('1. Resumo'),
    writeln('2. Data'),
    writeln('3. Links'),
    writeln('4. Voltar'),
    prompt('----> ', Input),
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', CodDisciplina),
    atom_number(Input, Opcao),
    selecionaEditaMateriais(Opcao, Matricula, CodGrupo, CodDisciplina).


selecionaEditaMateriais(1, Matricula, CodGrupo, CodDisciplina):-
    prompt('Código do Resumo: ', CodResumo),
    prompt('Novo Corpo: ', NewCorpo),
    editaResumoGrupo(CodGrupo, CodDisciplina, CodResumo, NewCorpo, Result),
    writeln(Result),
    menuEditaMateriais(Matricula).

selecionaEditaMateriais(2, Matricula, CodGrupo, CodDisciplina):-
    prompt('Código da Data: ', CodData),
    prompt('Nova data incio: ', NewDataInit),
    prompt('Nova data fim: ', NewDataFim),
    editaDataGrupo(CodGrupo, CodDisciplina, CodData, NewDataInit, NewDataFim, Result),
    writeln(Result),
    menuEditaMateriais(Matricula).

selecionaEditaMateriais(3, Matricula, CodGrupo, CodDisciplina):-
    prompt('Código do Link: ', CodLink),
    prompt('Nova url: ', NewUrl),
    editaLinkGrupo(CodGrupo, CodDisciplina, CodLink, NewUrl, Result),
    writeln(Result),
    menuEditaMateriais(Matricula).

selecionaEditaMateriais(4, Matricula, _, _):-
    menuMateriaisGrupo(Matricula).

selecionaEditaMateriais(_, Matricula, CodGrupo, CodDisciplina):-
    writeln('\nOpcão inválida!\n'), 
    menuEditaMateriais(Matricula).
