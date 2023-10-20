%%%REGRAS PARA CLIENTE %%%
% Regra específica para buscar todos os grupos do banco de dados

get_grupos(Data):- grupos_path(Path), load_json_file(Path, Data).

%Regra que adiciona um grupo ao banco de dados
%Os alunos e as disciplinas iniciam vazio por padrao
add_grupo(Codigo, Nome, Adm):- add_grupo(Codigo, Nome, [],[], Adm).

add_aluno(Codigo, Nome, Alunos, Disciplinas, Adm):-
    Grupo = json([codigo=Codigo, nome=Nome, alunos=Alunos, disciplinas=Disciplinas, adm=Adm]),
    grupos_path(Path),
    save_object(Path, Grupo).

%Regra para pegar um Grupo pelo código

get_grupo_by_codigo(Codigo, Grupo):- grupos_path(Path), get_object_by_id(Path, Codigo, Grupo, 'grupos').

%Regra para remover um Grupo pelo código

remove_grupo_by_codigo(Codigo):- grupos_path(Path), remove_object_by_id(Path, Codigo, 'grupos').

%Regra para pegar os Alunos do grupo a partir do Codigo do  grupo

get_grupo_alunos(Codigo, Alunos):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, Alunos, _, _).

%Regra para retornar o adm de um grupo
get_adm_grupo(Codigo, Adm):- 
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, _, _, Adm).

%Regra para adicionar um aluno na lista de alunos
adiciona_aluno_grupo(Codigo, Matricula):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    Aluno = json([])

