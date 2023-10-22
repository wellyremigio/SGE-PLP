
grupos_path('DataBase/Grupo.json').


get_grupos(Data):- grupos_path(Path), load_json_file(Path, Data).


save_object(File, Element) :- 
    load_json_file(File, Data),
    New_Data = [Element | Data],
    save_json_file(File, New_Data).

load_json_file(File, Data) :-
    open(File, read, Stream),
    json_read(Stream, Data),
    close(Stream).

% Regra geral salvar no banco de dados uma estrutura JSON recebida como parâmetro
save_json_file(File, Data) :-
    open(File, write, Stream),
    json_write(Stream, Data),
    close(Stream).

%Regra que adiciona um grupo ao banco de dados
%Os alunos e as disciplinas iniciam vazio por padrao
add_grupo(Codigo, Nome, Adm):- 
    add_grupo(Codigo, Nome, [],[], Adm).

add_grupo(Codigo, Nome, Alunos, Disciplinas, Adm):-
    Grupo = json([id=Codigo, nome=Nome, alunos=Alunos, disciplinas=Disciplinas, adm=Adm]),
    grupos_path(Path),
    save_object(Path, Grupo).

%Regra para pegar um Grupo pelo código
get_grupo_by_codigo(Codigo, Grupo):- 
    grupos_path(Path), 
    get_object_by_id(Path, Codigo, Grupo, 'grupo').

valida_grupo(Codigo):- 
    get_grupo_by_codigo(Codigo, Grupo),
    Grupo \= -1.

%Regra para remover um Grupo pelo código
remove_grupo_by_codigo(Codigo):- grupos_path(Path), remove_object_by_id(Path, Codigo, 'grupo').

%Regra para pegar os Alunos do grupo a partir do Codigo do  grupo
get_grupo_alunos(Codigo, Alunos):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, Alunos, _, _).

%Regra para retornar o adm de um grupo
get_adm_grupo(Codigo, Adm):- 
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, _, _, Adm).

%Verifica se o aluno é adm do grupo
verifica_adm(Codigo, Matricula, Result):-
    get_adm_grupo(Codigo,Adm),
    write('Matricula: '),
    write(Matricula),
    write('\n Adm: '),
    write(Adm),
    write('\n'),
    (Adm = Matricula -> Result = 1; Result = -1).

%Regra para validar se o Codigo já esta em um grupo
valida_grupo(Codigo):- 
    get_grupo_by_codigo(Codigo, Grupo),
    Grupo \= -1.

%Regra para adicionar um aluno na lista de alunos
adiciona_aluno_grupo(Codigo, Matricula):-
    get_grupo_by_codigo(Codigo, Grupo),
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    NewAlunos = [Aluno | Alunos],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, NewAlunos, Disciplinas, Adm).

%Regra para remover um aluno da lista de alunos

remove_aluno_grupo(Codigo, Matricula):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Alunos, Matricula, Aluno, 'alunos'),
    remove_object(Alunos, Aluno, NewAlunos),
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, NewAlunos, Disciplinas, Adm).

listagem_alunos_grupo(Codigo, Result):-
    get_grupo_by_codigo(Codigo, Grupo),

