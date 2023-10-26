% Inicialização do programa ao rodar 'main.pl'
:- initialization (main).

% Comando para rodar o Prolog no modo console:
% swipl -s main.pl

% Inclusão da base de dados.
:- consult('DataBase/gerenciadorGeral.pl').
:- consult('DataBase/gerenciadorAluno.pl').
:- consult('DataBase/gerenciadorGrupo.pl').

% Inclusão de constantes e módulos auxiliares.
:- consult('constantes.pl').
:- include('aluno.pl').
:- include('grupo.pl').

% Inclusão de utilitários, configuração de codificação de caracteres e módulos externos.
:- consult('utils.pl').
:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).
:- use_module(library(http/json)).
:- use_module(library(date)).
:- use_module(library(random)).

% Regra para receber entrada do usuário.
prompt(Message, String):-
    write(Message),
    flush_output,
    read_line_to_codes(user_input, Codes),
    string_codes(String, Codes).

% Regra principal do programa.
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

% Regra para executar a ação selecionada com base na entrada do usuário.
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

% Menu responsável por fazer o login do usuário.
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

% Menu para escolher opções de login, cadastro ou saída.
menuEscolhaLogin:-
    write('\nEscolha uma opção para seguir\n'),
    write('1. Fazer login \n'),
    write('2. Fazer cadastro\n'),
    write('3. Sair\n'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    write('\n'),
    verificaEscolha(Opcao).

% Regra para verificar a escolha do menuEscolhaLogin
verificaEscolha(1):-
    menuLogin.

verificaEscolha(2):-
    menuCadastro.

verificaEscolha(3):-
    write('Saindo...\n'),
    halt.

verificaEscolha(_):-
    write('Opção inválida.'),
    menuEscolhaLogin.

%Menu resonsável por fazer o cadastro 
menuCadastro :-
    prompt('Matrícula: ', Matricula),
    prompt('Nome: ', Nome),
    prompt('Senha: ', Senha),
    cadastraAluno(Matricula, Nome, Senha, ResultParcial),
    (ResultParcial = 'ok' -> 
        write('Aluno Cadastrado!'),
        menuInicial(Matricula)
        ;
        write('Não foi possível fazer o cadastro!'),
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

% Criar grupo
selecaoMenuInicial(1, Matricula):-
    writeln('\n==Cadastrando Grupo==\n'),
    prompt('Código do grupo: ', CodGrupo),
    prompt('Nome do grupo: ', NomeGrupo),
    cadastraGrupo(CodGrupo, NomeGrupo, Matricula, Result),
    adicionaAlunoGrupo(CodGrupo, Matricula),
    (Result = 'ok' ->
        write('Grupo Cadastrado!'),
        menuMeusGrupos(Matricula)
    ;
        write('Já existe um grupo com esse ID. Cadastre um grupo novo!\n'),
        menuInicial(Matricula)
    ). 

% Remover grupo
selecaoMenuInicial(2, Matricula):-
    writeln('\n==Removendo Grupo==\n'),
    prompt('Código do grupo: ', CodGrupo),
    verificaAdm(CodGrupo, Matricula, Result1),
    (Result1 = 1 ->
        (removeGrupo(CodGrupo, Matricula) ->
            write('Grupo removido!'),
            menuInicial(Matricula)
        ;
            write('Grupo não encontrado!'),
            menuInicial(Matricula)
        )
    ;
        write('Não é administrador do grupo e não pode remover!'),
        menuInicial(Matricula)
    ).


% Acessando grupos.
selecaoMenuInicial(3, Matricula):-
    menuMeusGrupos(Matricula).

% Acessando as disciplinas.
selecaoMenuInicial(4, Matricula):-
    menuMinhasDisciplinas(Matricula).


% Listagem dos grupos.
selecaoMenuInicial(5, Matricula):-
    listagemGrupos(Result),
    (Result = 'Não existem grupos cadastrados' ->
        write(Result)
    ;
        write(Result),
        menuInicial(Matricula)
    ).

% Voltando para o menu
selecaoMenuInicial(6, _):-
    write('Saindo...\n'),
    halt.

% Tratamento de opção inválida no menu inicial.
selecaoMenuInicial(_, Matricula):-
    write('Opção inválida'),
    menuInicial(Matricula).


% Menu específico para as funções dos grupos.
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

% Adicionar aluno a um grupo.
selecaoMenuMeusGrupos(1, Matricula):-
        prompt('Matrícula do aluno a ser adicionado: ', MatriculaAluno),
        prompt('Código do grupo: ', CodGrupo),
        (verificaGrupo(CodGrupo) ->
            (verifica_adm(CodGrupo, Matricula) -> 
                (valida_aluno(MatriculaAluno) -> 
                    ( \+ verifica_aluno_grupo(CodGrupo, MatriculaAluno) ->
                        adicionaAlunoGrupo(CodGrupo, MatriculaAluno),
                        write('Cadastrado com sucesso!')
                    ;write('Aluno já esta no grupo!') )
                ; write('Aluno não cadastrado!'))
            ; write('Aluno não é adm do grupo!'))
        ; write('Grupo não cadastrado!')),
        menuMeusGrupos(Matricula).

% Remover aluno de um grupo
selecaoMenuMeusGrupos(2, Matricula):-
    prompt('Matrícula do aluno a ser removido: ', MatriculaAluno),
        prompt('Código do grupo: ', CodGrupo),
        (verificaGrupo(CodGrupo) ->
            (verifica_adm(CodGrupo, Matricula) -> 
                (valida_aluno(MatriculaAluno) -> 
                    ( verifica_aluno_grupo(CodGrupo, MatriculaAluno) ->
                        removeAlunoGrupo(CodGrupo, MatriculaAluno),
                        write('Aluno removido com sucesso!')
                    ;write('Aluno já esta no grupo!') )
                ; write('Aluno não cadastrado!'))
            ; write('Aluno não é adm do grupo!'))
        ; write('Grupo não cadastrado!')),
        menuMeusGrupos(Matricula).
        
% Visualizar alunos do grupo
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

% Adicionar disciplina ao grupo
selecaoMenuMeusGrupos(4, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina que você quer adicionar: ', IdDisciplina),
    prompt('Nome da disciplina: ', NomeDisciplina),
    prompt('Nome do professor: ', NomeProfessor),
    prompt('Período: ', Periodo),
    cadastraDisciplinaGrupo(CodGrupo, IdDisciplina, NomeDisciplina, NomeProfessor, Periodo, Result),
    write(Result),
    menuMeusGrupos(Matricula).

% Visualizar disciplinas do grupo
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

% Remover disciplina do grupo. Verifica se o grupo foi cadastrado
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

% Acessar materiais do grupo
selecaoMenuMeusGrupos(7, Matricula):-
    menuMateriaisGrupo(Matricula).
   
% Ver grupos do usuário
selecaoMenuMeusGrupos(8, Matricula) :-
    write('\nEsses são os seus grupos: \n'),
    listagemMeusGrupos(Matricula, Result),
    write(Result),
    menuMeusGrupos(Matricula).

% Voltar para o menu inicial
selecaoMenuMeusGrupos(9, Matricula):-
    menuInicial(Matricula).

% Tratamento de entrada inválida
selecaoMenuMeusGrupos(_, Matricula):-
    write('Opção inválida'),
    menuMeusGrupos(Matricula).

% Menu específico para o cadastro e consulta de materiais em um grupo
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

% Lida com a opção "Ver materiais" no menu de materiais do grupo
opselecionadaMateriaisGrupo(1, Matricula):-
    menuConsultaGrupo(Matricula).

% Lida com a opção "Adicionar materiais" no menu de materiais do grupo
opselecionadaMateriaisGrupo(2, Matricula):-
    menuCadastraMateriaisGrupo(Matricula).

% Lida com a opção "Remover materiais" no menu de materiais do grupo
opselecionadaMateriaisGrupo(3, Matricula):-
    menuRemoverMateriaisGrupo(Matricula).

% Lida com a opção "Editar materiais" no menu de materiais do grupo
opselecionadaMateriaisGrupo(4, Matricula):-
    menuEditaMateriais(Matricula).

% Lida com a opção "Comentar no material" no menu de materiais do grupo   
opselecionadaMateriaisGrupo(5, Matricula):-
    menuComentarMaterial(Matricula).

% Lida com a opção "Ver Comentários do material" no menu de materiais do grupo
opselecionadaMateriaisGrupo(6, Matricula):-
    menuVerComentarioMaterial(Matricula).

% Lida com a opção "Voltar" no menu de materiais do grupo
opselecionadaMateriaisGrupo(7, Matricula):-
    menuMeusGrupos(Matricula).

% Lida com a opção "Sair" no menu de materiais do grupo
opselecionadaMateriaisGrupo(8, _):-
    write('Saindo...'), 
    halt.

% Lida com entrada inválida no menu de materiais do grupo
opselecionadaMateriaisGrupo(_, Matricula):- 
    write('\nOpcão inválida!\n'),   
    menuMeusGrupos(Matricula).

% Menu para consultar materiais
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

% Lida com a opção 1 de consulta de materiais selecionada pelo usuário
selecionaMenuConsultaGrupo(1, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('ID do Resumo: ', Id),
        visualiza_resumo_grupo(CodGrupo, IdDisciplina, Id, Result),
        write(Result),
        menuConsultaGrupo(Matricula)
    ;
        write('Grupo não cadastrado!'),
        menuConsultaGrupo(Matricula)
    ).

% Lida com a opção 2 de consulta de materiais selecionada pelo usuário
selecionaMenuConsultaGrupo(2, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('ID do Link: ', Id),
        visualiza_link_grupo(CodGrupo, IdDisciplina, Id, Result),
        write(Result),
        menuConsultaGrupo(Matricula)
    ;
        write('Grupo não cadastrado!'),
        menuConsultaGrupo(Matricula)
    ).

% Lida com a opção 3 de consulta de materiais selecionada pelo usuário
selecionaMenuConsultaGrupo(3, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    (verificaGrupo(CodGrupo) ->
        prompt('Código da disciplina: ', IdDisciplina),
        prompt('ID da Data: ', Id),
        visualiza_data_grupo(CodGrupo, IdDisciplina, Id, Result),
        write(Result),
        menuConsultaGrupo(Matricula)
    ;
        write('Grupo não cadastrado!'),
        menuConsultaGrupo(Matricula)
    ).

% Lida com a opção 4 de consulta de materiais selecionada pelo usuário
selecionaMenuConsultaGrupo(4, Matricula):-
    menuMateriaisGrupo(Matricula).

% Lida com a opção 5 de consulta de materiais selecionada pelo usuário
selecionaMenuConsultaGrupo(5, _):-
    write('Saindo...'), 
    halt.

% Lida com uma escolha inválida no menuConsultaGrupo
selecionaMenuConsultaGrupo(_, Matricula):-
    write('\nOpcão inválida!\n'), 
    menuConsultaGrupo(Matricula).


% Menu para cadastrar materiais
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

% Lida com a escolha 1 da opção no menu para cadastrar materiais
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

% Lida com a escolha 2 da opção no menu para cadastrar materiais
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

% Lida com a escolha 3 da opção no menu para cadastrar materiais
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

% Lida com a escolha 4 da opção no menu para cadastrar materiais
opselecionadaCadastraMateriaisGrupo(4, Matricula) :-
    menuMateriaisGrupo(Matricula).

% Lida com uma escolha inválida no menu para cadastrar materiais
opselecionadaCadastraMateriaisGrupo(_, Matricula):- 
    write('\nOpcão inválida!\n'),
    menuCadastraMateriaisGrupo(Matricula).

% Menu para remover materiais
menuRemoverMateriaisGrupo(Matricula) :-
    writeln('\nSelecione o tipo de material que você gostaria de remover:'),
    write('1. Resumo\n'),
    write('2. Links\n'),
    write('3. Datas\n'),
    write('4. Voltar\n'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    selecionaMenuRemoveMateriaisGrupo(Opcao, Matricula).

% Lida com a escolha 1 da opção no menu para remover materiais
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

% Lida com a escolha 2 da opção no menu para remover materiais
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

% Lida com a escolha 3 da opção no menu para remover materiais
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
    
% Lida com a escolha 4 da opção no menu para remover materiais
selecionaMenuRemoveMateriaisGrupo(4, Matricula):-
    menuMateriaisGrupo(Matricula).

% Lida com uma escolha inválida no menu para remover materiais
selecionaMenuRemoveMateriaisGrupo(_, Matricula):-
    write('\nOpcão inválida!\n'), 
    menuRemoverMateriaisGrupo(Matricula).

% Menu para exibir as opções relacionadas às disciplinas do aluno
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

% Lida com a escolha da opção 1 no menu de disciplinas do aluno 
opselecionadaDisciplinaAluno(1, Matricula) :-
    exibe_disciplinas(Matricula,Result),
    write(Result),
    menuMinhasDisciplinas(Matricula).

% Lida com a escolha da opção 2 no menu de disciplinas do aluno    
opselecionadaDisciplinaAluno(2, Matricula) :-
    prompt('O código da disciplina que você quer cadastrar: ', Codigo),
    prompt('Nome da disciplina: ', Nome),
    prompt('Professor que ministra: ',Professor),
    prompt('Período: ', Periodo),
    cadastra_disciplina_aluno(Matricula, Codigo, Nome, Professor, Periodo, Result),
    write(Result),
    menuMinhasDisciplinas(Matricula).

% Lida com a escolha da opção 3 no menu de disciplinas do aluno   
opselecionadaDisciplinaAluno(3, Matricula) :-
    prompt('Código da disciplina que você quer remover: ', Codigo),
    rm_disciplina_aluno(Matricula, Codigo, Result),
    write(Result),
    menuMinhasDisciplinas(Matricula).

% Lida com a escolha da opção 4 no menu de disciplinas do aluno    
opselecionadaDisciplinaAluno(4, Matricula) :-
    menuMateriaisAluno(Matricula).

% Lida com a escolha da opção 5 no menu de disciplinas do aluno 
opselecionadaDisciplinaAluno(5, Matricula) :-
    menuInicial(Matricula).

% Lida com a escolha da opção 6 no menu de disciplinas do aluno 
opselecionadaDisciplinaAluno(6, _) :-
    write('Saindo...'), 
    halt.

% Lida com uma escolha inválida no menu de disciplinas do aluno
opselecionadaDisciplinaAluno(_,Matricula) :- write('Opcão inválida!'), menuMinhasDisciplinas(Matricula).

% Menu para cadastrar materiais pelo aluno
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

% Lida com a escolha da opção 1 no menu de cadastro de materiais pelo aluno
opselecionadaCadastraMateriaisAluno(1, Matricula) :-
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('Nome do resumo: ', Nome),
    prompt('Conteúdo do resumo: ', Resumo),
    add_resumo_disciplina_aluno(Matricula, IdDisciplina, Nome, Resumo, Result),
    write(Result),
    menuCadastraMateriaisAluno(Matricula).

% Lida com a escolha da opção 2 no menu de cadastro de materiais pelo aluno
opselecionadaCadastraMateriaisAluno(2, Matricula) :-
    prompt('Código da disciplina: ', Codigo),
    prompt('Titulo: ', Titulo),
    prompt('Link: ', Link),
    add_link_disciplina_aluno(Matricula, Codigo, Titulo, Link, Result),
    write(Result),
    menuCadastraMateriaisAluno(Matricula).

% Lida com a escolha da opção 3 no menu de cadastro de materiais pelo aluno
opselecionadaCadastraMateriaisAluno(3, Matricula) :-
    prompt('Código da disciplina: ', Codigo),
    prompt('Titulo: ', Titulo),
    prompt('Data início: ', DataI),
    prompt('Data fim: ', DataF),
    add_data_disciplina_aluno(Matricula, Codigo, Titulo, DataI, DataF, Result),
    write(Result),
    menuCadastraMateriaisAluno(Matricula).

% Lida com a escolha da opção 4 no menu de cadastro de materiais pelo aluno
opselecionadaCadastraMateriaisAluno(4, Matricula) :-
    menuMinhasDisciplinas(Matricula).

% Lida com uma escolha inválida no menu de cadastro de materiais pelo aluno
opselecionadaCadastraMateriaisAluno(_, Matricula):- 
    write('\nOpcão inválida!\n'),
    menuCadastraMateriaisAluno(Matricula).

% Menu de materiais do aluno
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

% Lida com a escolha da opção 1 no menu de materiais do aluno
opselecionadaMateriaisAluno(1, Matricula):-
    menuConsultaAluno(Matricula).

% Lida com a escolha da opção 2 no menu de materiais do aluno
opselecionadaMateriaisAluno(2, Matricula):-
    menuCadastraMateriaisAluno(Matricula).

% Lida com a escolha da opção 3 no menu de materiais do aluno
opselecionadaMateriaisAluno(3, Matricula):-
    menuRemoverMateriais(Matricula).

% Lida com a escolha da opção 4 no menu de materiais do aluno
opselecionadaMateriaisAluno(4, Matricula):-
    menuMinhasDisciplinas(Matricula).

% Lida com a escolha da opção 5 no menu de materiais do aluno
opselecionadaMateriaisAluno(5, _):-
    write('Saindo...'), 
    halt.

% Lida com uma escolha inválida no menu de materiais do aluno
opselecionadaMateriaisAluno(_, Matricula):- 
    write('\nOpcão inválida!\n'),   
    menuMateriaisAluno(Matricula).

% Menu para remover materiais pelo aluno
menuRemoverMateriais(Matricula) :-
    writeln('\nSelecione o tipo de material que você gostaria de remover:'),
    write('1. Resumo\n'),
    write('2. Links\n'),
    write('3. Datas\n'),
    write('4. Voltar\n'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    selecionaMenuRemoveMateriaisAluno(Opcao, Matricula).

% Lida com a escolha da opção 1 no menu para remover materiais pelo aluno
selecionaMenuRemoveMateriaisAluno(1, Matricula):-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID do Resumo: ', Id),
    remove_resumo_aluno(Matricula, Codigo, Id, Result),
    write(Result),
    menuRemoverMateriais(Matricula).

% Lida com a escolha da opção 2 no menu para remover materiais pelo aluno
selecionaMenuRemoveMateriaisAluno(2, Matricula):-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID do Link: ', Id),
    remove_link_aluno(Matricula, Codigo, Id, Result),
    write(Result),
    menuRemoverMateriais(Matricula).

% Lida com a escolha da opção 3 no menu para remover materiais pelo aluno
selecionaMenuRemoveMateriaisAluno(3, Matricula):-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID da Data: ', Id),
    remove_data_aluno(Matricula, Codigo, Id, Result),
    write(Result),
    menuRemoverMateriais(Matricula).
    
% Lida com a escolha da opção 4 no menu para remover materiais pelo aluno
selecionaMenuRemoveMateriaisAluno(4, Matricula):-
    menuMateriaisAluno(Matricula).

% Lida com uma escolha inválida no menu para remover materiais pelo aluno
selecionaMenuRemoveMateriaisAluno(_, Matricula):-
    write('\nOpcão inválida!\n'), 
    menuRemoverMateriais(Matricula).

% Menu para consultar materiais pelo aluno
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

% Lida com a escolha da opção 1 no menu para consultar materiais pelo aluno
selecionaMenuConsultaAluno(1, Matricula) :-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID do Resumo: ', Id),
    visualiza_resumo(Matricula, Codigo, Id, Result),
    writeln(Result),
    menuConsultaAluno(Matricula).

% Lida com a escolha da opção 2 no menu para consultar materiais pelo aluno
selecionaMenuConsultaAluno(2, Matricula):-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID do Link: ', Id),
    visualiza_link(Matricula, Codigo, Id, Result),
    writeln(Result),
    menuConsultaAluno(Matricula).

% Lida com a escolha da opção 3 no menu para consultar materiais pelo aluno
selecionaMenuConsultaAluno(3, Matricula):-
    prompt('Código da disciplina: ', Codigo),
    prompt('ID da Data: ', Id),
    visualiza_data(Matricula, Codigo, Id, Result),
    writeln(Result),
    menuConsultaAluno(Matricula).

% Lida com a escolha da opção 4 no menu para consultar materiais pelo aluno
selecionaMenuConsultaAluno(4, Matricula):-
    menuMateriaisAluno(Matricula).

% Lida com a escolha da opção 5 no menu para consultar materiais pelo aluno
selecionaMenuConsultaAluno(5, _):-
    write('Saindo...'), 
    halt.

% Lida com uma escolha inválida no menu para consultar materiais pelo aluno
selecionaMenuConsultaAluno(_, Matricula):-
    write('\nOpcão inválida!\n'), 
    menuConsultaAluno(Matricula).

% Menu para adicionar comentários a materiais
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

% Lida com a escolha da opção 1 no menu para adicionar comentários a materiais
selecionaMaterialComentario(1, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID do resumo: ', Id),
    prompt('Comentario a ser enviado: ', Comentario),
    add_comentario_resumo(Matricula, CodGrupo, IdDisciplina, Id,Comentario, Result),
    write(Result),
    menuComentarMaterial(Matricula).

% Lida com a escolha da opção 2 no menu para adicionar comentários a materiais
selecionaMaterialComentario(2, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID do link: ', Id),
    prompt('Comentario a ser enviado: ', Comentario),
    add_comentario_link(Matricula, CodGrupo, IdDisciplina, Id, Comentario, Result),
    write(Result),
    menuComentarMaterial(Matricula).

% Lida com a escolha da opção 3 no menu para adicionar comentários a materiais
selecionaMaterialComentario(3, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID da data: ', Id),
    prompt('Comentario a ser enviado: ', Comentario),
    add_comentario_data(Matricula, CodGrupo, IdDisciplina, Id, Comentario, Result),
    write(Result),
    menuComentarMaterial(Matricula).

% Lida com a escolha da opção 4 no menu para adicionar comentários a materiais
selecionaMaterialComentario(4, Matricula):-
    menuMateriaisGrupo(Matricula).

% Lida com a escolha da opção 5 no menu para adicionar comentários a materiais
selecionaMaterialComentario(5, _):-
    write('Saindo...'), 
    halt.

% Lida com uma escolha inválida no menu para adicionar comentários a materiais
selecionaMaterialComentario(_, Matricula):-
    write('\nOpcão inválida!\n'),
    menuComentarMaterial(Matricula).

% Menu para visualizar comentários em materiais
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

% Lida com a escolha da opção 1 no menu para visualizar comentários em materiais
selecionaVerComentarioMaterial(1, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID do resumo: ', Id),
    comentarios_resumo(Matricula, CodGrupo,IdDisciplina, Id, Result),
    write(Result),
    menuVerComentarioMaterial(Matricula).

% Lida com a escolha da opção 2 no menu para visualizar comentários em materiais
selecionaVerComentarioMaterial(2, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID do link: ', Id),
    comentarios_link(Matricula, CodGrupo,IdDisciplina, Id, Result),
    write(Result),
    menuVerComentarioMaterial(Matricula).

% Lida com a escolha da opção 3 no menu para visualizar comentários em materiais
selecionaVerComentarioMaterial(3, Matricula) :-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', IdDisciplina),
    prompt('ID da data: ', Id),
    comentarios_data(Matricula, CodGrupo,IdDisciplina, Id, Result),
    write(Result),
    menuVerComentarioMaterial(Matricula).

% Lida com a escolha da opção 4 no menu para visualizar comentários em materiais
selecionaVerComentarioMaterial(4, Matricula) :-
    menuMateriaisGrupo(Matricula).

% Lida com a escolha da opção 5 no menu para visualizar comentários em materiais
selecionaVerComentarioMaterial(5, _) :-
    write('Saindo...'), 
    halt.

% Lida com uma escolha inválida no menu para visualizar comentários em materiais
selecionaVerComentarioMaterial(_, Matricula) :-
    write('\nOpção inválida.\n'), 
    menuVerComentarioMaterial(Matricula).

% Menu para editar materiais
menuEditaMateriais(Matricula):-
    writeln('\nQual material você deseja alterar:'),
    writeln('1. Resumo'),
    writeln('2. Data'),
    writeln('3. Links'),
    writeln('4. Voltar'),
    prompt('----> ', Input),
    atom_number(Input, Opcao),
    selecionaEditaMateriais(Opcao, Matricula).

% Lida com a escolha da opção 1 no menu para editar materiais
selecionaEditaMateriais(1, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', CodDisciplina),
    prompt('Código do Resumo: ', CodResumo),
    prompt('Novo Corpo: ', NewCorpo),
    editaResumoGrupo(CodGrupo, CodDisciplina, CodResumo, NewCorpo, Result),
    writeln(Result),
    menuEditaMateriais(Matricula).

% Lida com a escolha da opção 2 no menu para editar materiais
selecionaEditaMateriais(2, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', CodDisciplina),
    prompt('Código da Data: ', CodData),
    prompt('Nova data incio: ', NewDataInit),
    prompt('Nova data fim: ', NewDataFim),
    editaDataGrupo(CodGrupo, CodDisciplina, CodData, NewDataInit, NewDataFim, Result),
    writeln(Result),
    menuEditaMateriais(Matricula).

% Lida com a escolha da opção 3 no menu para editar materiais
selecionaEditaMateriais(3, Matricula):-
    prompt('Código do grupo: ', CodGrupo),
    prompt('Código da disciplina: ', CodDisciplina),
    prompt('Código do Link: ', CodLink),
    prompt('Nova url: ', NewUrl),
    editaLinkGrupo(CodGrupo, CodDisciplina, CodLink, NewUrl, Result),
    writeln(Result),
    menuEditaMateriais(Matricula).

% Lida com a escolha da opção 4 no menu para editar materiais
selecionaEditaMateriais(4, Matricula):-
    menuMateriaisGrupo(Matricula).

% Lida com a escolha de uma opção inválida no menu para editar materiais
selecionaEditaMateriais(_, Matricula):-
    writeln('\nOpcão inválida!\n'), 
    menuEditaMateriais(Matricula).
