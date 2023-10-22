alunos_path('DataBase/Aluno.json').


get_aluno(Data):- alunos_path(Path), load_json_file(Path, Data).


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

%Regra que adiciona um aluno ao banco de dados
add_aluno(Matricula, Nome , Senha):-
    add_aluno(Matricula, Nome, Senha, []).

add_aluno(Matricula, Nome , Senha, Disciplinas):-
    Aluno = json([id=Matricula, nome=Nome, senha=Senha, disciplinas=Disciplinas]),
    alunos_path(Path),
    save_object(Path, Aluno).

%Regra ppara pegar um aluno pela matricula

get_aluno_by_matricula(Matricula, Aluno):-
    alunos_path(Path),
    get_object_by_id(Path, Matricula, Aluno, 'aluno').

%Regra para remover um aluno pela matricula

remove_aluno_by_matricula(Matricula):-
    alunos_path(Path),
    remove_object_by_id(Path, Matricula, 'aluno').

%Regra para pegar as disciplinas de um aluno
get_aluno_disciplina(Matricula, Disciplinas):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas).

%Regra para pegar a senha de um aluno

get_aluno_senha(Matricula, Senha):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, Senha, _).

valida_aluno(Matricula):- 
    get_aluno_by_matricula(Matricula, Aluno),
    Aluno \= -1.

valida_disciplina(Matricula, IdDisciplina):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    Disciplina \= -1.


add_disciplina_aluno(Matricula, IdDisciplina, NomeDisciplina, Professor, Periodo):-
    \+ valida_disciplina(Matricula, IdDisciplina),
    Disciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=[], datas=[], links=[]]),
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, Nome, Senha, Disciplinas),
    NewDisciplinas = [Disciplina | Disciplinas],
    remove_aluno_by_matricula(Matricula),
    add_aluno(Matricula, Nome, Senha, NewDisciplinas).

remove_disciplina_aluno(Matricula, IdDisciplina):-
    valida_disciplina(Matricula, IdDisciplina),
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, Nome, Senha, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Elemento, 'disciplina'),
    remove_object(Disciplinas, Elemento, NewDisciplinas),
    remove_aluno_by_matricula(Matricula),
    add_aluno(Matricula, Nome, Senha, NewDisciplinas).

has_disciplines(Matricula) :-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas),
    length(Disciplinas, N),
    N > 0.


