%%% Regras para Aluno

%Regra especídfica que busca os alunos no banco de dados

get_aluno(Data):- alunos_path(Path), load_json_file(Path, Data).

%Regra que adiciona um aluno ao banco de dados

add_aluno(Matricula, Nome , Senha):- add_aluno(Matricula, Nome, Senha, []).

add_aluno(Matricula, Nome , Senha, Disciplina):-
    Aluno = json([matricula=Matricula, nome=Nome, senha=Senha, disciplina=Disciplina]),
    alunos_path(Path),
    save_object(Path, Aluno).

%Regra ppara pegar um aluno pela matricula

get_aluno_by_matricula(Matricula, Aluno):-
    alunos_path(Path),
    get_object_by_id(Path, Matricula, Aluno, 'alunos').

%Regra para remover um aluno pela matricula

remove_aluno_by_matricula(Matricula):-
    alunos_path(Path),
    remove_object_by_id(Path, Matricula, 'alunos').

%Regra para pegar as disciplinas de um aluno
get_aluno_disciplina(Matricula, Disciplinas):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas).

%Regra para pegar a senha de um aluno

get_aluno_senha(Matricula, Senha):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, Senha, _).

