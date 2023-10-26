% Incluindo a biblioteca necessária para o uso de DCG (Definite Clause Grammars).
:- use_module(library(dcg/basics)).

% Regra que retorna a lista de disciplinas para um aluno com a matrícula especificada.
listaDisciplinas(Matricula, Resposta) :- 
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas),
    organizaListagemDisciplina(Disciplinas, Resposta).

% Regra para organizar a listagem de disciplinas.
organizaListagemDisciplina([], '').
organizaListagemDisciplina([H|T], Resposta) :- 
    organizaListagemDisciplina(T, Resposta1),
    extract_info_disciplina(H, Id, Nome,Professor, Periodo, _, _, _),
    concatena_strings(['\nID:' ,Id, '\nNome: ', Nome, '\nProfessor: ',Professor, '\nPeríodo: ', Periodo,'\n'], DisciplinasConcatenados),
    string_concat(DisciplinasConcatenados, Resposta1, Resposta).

% Regra que retorna a lista de disciplinas de um grupo com o código especificado.
listaDisciplinaGrupo(CodGrupo, Resposta) :-
    get_grupo_by_codigo(CodGrupo, Grupo),
    extract_info_grupo(Grupo, _, _, _, Disciplinas, _),
    organizaListagemDisciplina(Disciplinas, Resposta).

%Regra para organizar a listagem de alunos de um grupo.
organizaListagemAlunoGrupo([], '').
organizaListagemAlunoGrupo([H|T], Resposta) :- 
    organizaListagemAlunoGrupo(T, Resposta1),
    extract_info_aluno(H, Id, Nome, _, _),
    concatena_strings(['\nID:' ,Id, '\nNome: ', Nome,'\n'], AlunosConcatenados),
    string_concat(AlunosConcatenados, Resposta1, Resposta).

% Regra que retorna a lista de alunos em um grupo com o código especificado.
listaAlunosGrupo(CodGrupo, Resposta) :-
    get_grupo_by_codigo(CodGrupo, Grupo),
    extract_info_grupo(Grupo, _, _, Alunos, _, _),
    organizaListagemAlunoGrupo(Alunos, Resposta).

%Regra para organizar a listagem de grupos.
organizaListagemGrupo([], '').
organizaListagemGrupo([H|T], Resposta) :- 
    organizaListagemGrupo(T, Resposta1),
    extract_info_grupo(H, Id, Nome, Alunos, _, _),
    length(Alunos, NumAlunos),  
    concatena_strings(['\nID: ' ,Id, '\nNome: ', Nome, '\nQtd de Alunos: ', NumAlunos, '\n'], GruposConcatenados),
    string_concat(GruposConcatenados, Resposta1, Resposta).

%Regra que retorna a lista de grupos.
listaGrupos(Resposta) :-
    get_grupos(Data),
    organizaListagemGrupo(Data, Resposta).

% Regra que recebe uma lista de strings e retorna a concatenação de todas elas.
concatena_strings(ListaStrings, Resultado) :-
    concatena_strings_loop(ListaStrings, '', Resultado).

% Regra que auxilia a concatenação de uma lista de strings recebidas.
concatena_strings_loop([], Acumulador, Acumulador).
concatena_strings_loop([String | Resto], Acumulador, Resultado) :-
    atom_concat(Acumulador, String, NovoAcumulador),
    concatena_strings_loop(Resto, NovoAcumulador, Resultado).

% Regra que lista os comentários de um resumo.
lista_comentarios_resumo(Resumo,Result):-
    extract_info_resumo(Resumo, _, _, _, Comentarios),
    (Comentarios = [] ->
        Result = '\nSem comentários!\n'
    ;
        organizaListagemComentario(Comentarios,Result)
    ).

% Regra que lista os comentários de uma data.
lista_comentarios_data(Data,Result):-
    extract_info_data(Data, _, _, _, _, Comentarios),
    (Comentarios = [] ->
        Result = '\nSem comentários!\n'
    ;
        organizaListagemComentario(Comentarios,Result)
    ).

% Regra que lista os comentários de um link.
lista_comentarios_link(Link,Result):-
    extract_info_link_util(Link, _, _,_, Comentarios),
    (Comentarios = [] ->
        Result = '\nSem comentários!\n'
    ;
        organizaListagemComentario(Comentarios,Result)
    ).

% Regra para organizar a listagem de comentários.
organizaListagemComentario([], '').
organizaListagemComentario([H|T], Resposta) :- 
    organizaListagemComentario(T, Resposta1),
    extract_info_comentario(H, Id, IdAluno, Comentario),
    concatena_strings(['\nID comentário:' ,Id, '\nID Aluno: ', IdAluno, '\nComentário: ',Comentario,'\n'], ComentariosConcatenados),
    string_concat(ComentariosConcatenados, Resposta1, Resposta).