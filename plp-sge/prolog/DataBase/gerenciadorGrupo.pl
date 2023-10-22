:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).

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

%Regra para saber se um grupo está cadastrado
valida_grupo(Codigo):- 
    get_grupo_by_codigo(Codigo, Grupo),
    Grupo \= -1.

%Regra para remover um Grupo pelo código
remove_grupo_by_codigo(Codigo):- 
    grupos_path(Path), 
    remove_object_by_id(Path, Codigo, 'grupo').

%Regra para pegar os Alunos do grupo a partir do Codigo do  grupo
get_grupo_alunos(Codigo, Alunos):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, Alunos, _, _).

%Regra para retornar o adm de um grupo
get_adm_grupo(Codigo, Adm):- 
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, _, _, Adm).

get_adm_grupo(Codigo, Adm):-
    atom_string(CodigoAtom, Codigo),
    get_grupo_by_codigo(CodigoAtom, Grupo),
    extract_info_grupo(Grupo, _, _, _, _, Adm).


%Verifica se o aluno é adm do grupo
verifica_adm_remove(Codigo, Matricula, Result):-
    get_adm_grupo(Codigo,Adm),
    (Adm = Matricula -> Result = 1; Result = -1).

verifica_adm(Codigo, Matricula):-
    atom_string(CodigoAtom, Codigo),
    atom_string(MatriculaAtom, Matricula),
    get_adm_grupo(CodigoAtom,Adm),
    Adm = MatriculaAtom.

verifica_aluno_grupo(CodigoGrupo, Matricula):-
    atom_string(CodigoAtom, CodigoGrupo),
    atom_string(MatriculaAtom, Matricula),
    valida_aluno_grupo(CodigoAtom, MatriculaAtom).

valida_aluno_grupo(CodigoGrupo, Matricula):-
    get_grupo_by_codigo(CodigoGrupo, Grupo),
    extract_info_grupo(Grupo, _, _, Alunos, _, _),
    seach_id(Alunos, Matricula, Aluno, 'aluno'),
    Aluno \= -1.


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


verifica_disciplina(CodGrupo, IdD):-
    get_grupo_by_codigo(CodGrupo, Grupo),
    extract_info_grupo(Grupo, _, _, _, Disciplinas, _),
    seach_id(Disciplinas, IdD, Disciplina, 'disciplina'),
    Disciplina \= -1.

add_disciplina_grupo(Codigo, IdDisciplina, NomeDisciplina, Professor, Periodo):-
    \+ verifica_disciplina(Codigo, IdDisciplina),
    Disciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=[], datas=[], links=[]]),
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    NewDisciplinas = [Disciplina | Disciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NewDisciplinas, Adm).

remove_disciplina_grupo(Codigo, IdDisciplina):-
    verifica_disciplina(Codigo, IdDisciplina),
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Elemento, 'disciplina'),
    remove_object(Disciplinas, Elemento, NewDisciplinas),
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NewDisciplinas, Adm).
