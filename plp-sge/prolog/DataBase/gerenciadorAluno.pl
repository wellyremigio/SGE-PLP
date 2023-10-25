% Caminho do arquivo JSON contendo os dados dos alunos.
alunos_path('DataBase/Aluno.json').

% Obtém todos os dados dos alunos a partir do arquivo JSON.
get_aluno(Data):- alunos_path(Path), load_json_file(Path, Data).

% Adiciona um aluno ao banco de dados com disciplinas vazias.
add_aluno(Matricula, Nome , Senha):-
    add_aluno(Matricula, Nome, Senha, []).

% Adiciona um aluno ao banco de dados com disciplinas especificadas.
add_aluno(Matricula, Nome , Senha, Disciplinas):-
    Aluno = json([id=Matricula, nome=Nome, senha=Senha, disciplinas=Disciplinas]),
    alunos_path(Path),
    save_object(Path, Aluno).

% Obtém um aluno pelo número de matrícula.
get_aluno_by_matricula(Matricula, Aluno):-
    alunos_path(Path),
    get_object_by_id(Path, Matricula, Aluno, 'aluno').

% Remove um aluno pelo número de matrícula.
remove_aluno_by_matricula(Matricula):-
    alunos_path(Path),
    remove_object_by_id(Path, Matricula, 'aluno').

% Obtém as disciplinas de um aluno a partir do número de matrícula.
get_aluno_disciplina(Matricula, Disciplinas):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas).

% Obtém a senha de um aluno a partir do número de matrícula.
get_aluno_senha(Matricula, Senha):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, Senha, _).

% Verifica se um aluno com a matrícula especificada existe no banco de dados.
valida_aluno(Matricula):- 
    atom_string(MatriculaAtom, Matricula),
    get_aluno_by_matricula(MatriculaAtom, Aluno),
    Aluno \= -1.

% Verifica se um aluno está matriculado em uma disciplina pelo número de matrícula e ID da disciplina.
valida_disciplina(Matricula, IdDisciplina):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    Disciplina \= -1.

% Adiciona uma disciplina a um aluno especificado pelo número de matrícula.
add_disciplina_aluno(Matricula, IdDisciplina, NomeDisciplina, Professor, Periodo):-
    \+ valida_disciplina(Matricula, IdDisciplina),
    Disciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=[], datas=[], links=[]]),
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, Nome, Senha, Disciplinas),
    NewDisciplinas = [Disciplina | Disciplinas],
    remove_aluno_by_matricula(Matricula),
    add_aluno(Matricula, Nome, Senha, NewDisciplinas).

% Remove uma disciplina de um aluno pelo número de matrícula e ID da disciplina.
remove_disciplina_aluno(Matricula, IdDisciplina):-
    valida_disciplina(Matricula, IdDisciplina),
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, Nome, Senha, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Elemento, 'disciplina'),
    remove_object(Disciplinas, Elemento, NewDisciplinas),
    remove_aluno_by_matricula(Matricula),
    add_aluno(Matricula, Nome, Senha, NewDisciplinas).

% Verifica se um aluno possui disciplinas.
has_disciplines(Matricula) :-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas),
    length(Disciplinas, N),
    N > 0.

% Obtém um resumo de um aluno pelo ID do resumo, matrícula e ID da disciplina.
getResumoAluno(IdResumo,Matricula,IdDisciplina,Result):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, _, _, _, Resumos, _, _),
    seach_id(Resumos, IdResumo, Resumo,'resumo'),
    Result = Resumo.

% Obtém um link de um aluno pelo ID do link, matrícula e ID da disciplina.
getLinkAluno(IdLink,Matricula,IdDisciplina,Result):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, _, _, _, _, _, Links),
    seach_id(Links, IdLink, Link,'link'),
    Result = Link.

% Obtém uma data de um aluno pelo ID da data, matrícula e ID da disciplina.
getDataAluno(IdData,Matricula,IdDisciplina,Result):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, _, _, _, _, Datas, _),
    seach_id(Datas, IdData, Data,'data'),
    Result = Data.

% Adiciona um resumo ao aluno em uma disciplina específica.
adiciona_resumo_aluno(Matricula, IdDisciplina, IdResumo, TituloR, ConteudoR):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, Nome, Senha, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Links, Datas),
    NewResumo = json([id=IdResumo, titulo=TituloR, corpo=ConteudoR, comentarios=[]]),
    NewResumos = [NewResumo | Resumos],
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=NewResumos, datas=Datas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_aluno_by_matricula(Matricula),
    add_aluno(Matricula, Nome, Senha, NDisciplinas).

% Adiciona um link ao aluno em uma disciplina específica.   
adiciona_link_aluno(Matricula, IdDisciplina, IdLink, TituloL, Url):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, Nome, Senha, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    NewLink = json([id=IdLink, titulo=TituloL, url=Url, comentarios=[]]),
    NewLinks = [NewLink | Links],
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=Datas, links=NewLinks]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_aluno_by_matricula(Matricula),
    add_aluno(Matricula, Nome, Senha, NDisciplinas).

% Adiciona uma data ao aluno em uma disciplina específica.
adiciona_data_aluno(Matricula, IdDisciplina, IdData, TituloD, DataI, DataF):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, Nome, Senha, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    NewData = json([id=IdData, titulo=TituloD, dataInicio=DataI, dataFim=DataF, comentarios=[]]),
    NewDatas = [NewData | Datas],
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=NewDatas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_aluno_by_matricula(Matricula),
    add_aluno(Matricula, Nome, Senha, NDisciplinas).

% Remove um resumo de um aluno em uma disciplina específica.
rem_resumo_aluno(Matricula, IdDisciplina, IdResumo):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, Nome, Senha, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Resumos, IdResumo, Elemento, 'resumo'),
    remove_object(Resumos, Elemento, NewResumos),
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=NewResumos, datas=Datas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_aluno_by_matricula(Matricula),
    add_aluno(Matricula, Nome, Senha, NDisciplinas).

% Remove uma data de um aluno em uma disciplina específica.
rem_data_aluno(Matricula, IdDisciplina, IdData):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, Nome, Senha, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Datas, IdData, Elemento, 'data'),
    remove_object(Datas, Elemento, NewDatas),
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=NewDatas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_aluno_by_matricula(Matricula),
    add_aluno(Matricula, Nome, Senha, NDisciplinas).

% Remove um link de um aluno em uma disciplina específica.
rem_link_aluno(Matricula, IdDisciplina, IdLink):-
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, Nome, Senha, Disciplinas),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Links, IdLink, Elemento, 'link'),
    remove_object(Links, Elemento, NewLinks),
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=Datas, links=NewLinks]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_aluno_by_matricula(Matricula),
    add_aluno(Matricula, Nome, Senha, NDisciplinas).