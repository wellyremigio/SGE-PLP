% Caminho do arquivo JSON onde os dados dos grupos são armazenados.
grupos_path('DataBase/Grupo.json').
% Obtém todos os grupos a partir do arquivo JSON.
get_grupos(Data):- grupos_path(Path), load_json_file(Path, Data).

% Adiciona um grupo com um código, nome, lista de alunos, lista de disciplinas e administrador.
add_grupo(Codigo, Nome, Adm):- 
    add_grupo(Codigo, Nome, [],[], Adm).

% Adiciona um grupo com um código, nome, lista de alunos, lista de disciplinas e administrador.
add_grupo(Codigo, Nome, Alunos, Disciplinas, Adm):-
    Grupo = json([id=Codigo, nome=Nome, alunos=Alunos, disciplinas=Disciplinas, adm=Adm]),
    grupos_path(Path),
    save_object(Path, Grupo).
    
% Obtém um grupo pelo seu código
get_grupo_by_codigo(Codigo, Grupo):- 
    grupos_path(Path),
    get_object_by_id(Path, Codigo, Grupo, 'grupo').

% Verifica se um grupo com o código fornecido existe.
valida_grupo(Codigo):- 
    get_grupo_by_codigo(Codigo, Grupo),
    Grupo \= -1.

% Remove um grupo pelo seu código.
remove_grupo_by_codigo(Codigo):- 
    grupos_path(Path), 
    remove_object_by_id(Path, Codigo, 'grupo').

% Obtém a lista de alunos de um grupo a partir do código do grupo.
get_grupo_alunos(Codigo, Alunos):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, Alunos, _, _).

% Obtém o administrador de um grupo a partir do código do grupo.
get_adm_grupo(Codigo, Adm):-
    atom_string(CodigoAtom, Codigo),
    get_grupo_by_codigo(CodigoAtom, Grupo),
    extract_info_grupo(Grupo, _, _, _, _, Adm).

% Verifica se um usuário com a matrícula fornecida é o administrador de um grupo.
verifica_adm(Codigo, Matricula):-
    atom_string(CodigoAtom, Codigo),
    atom_string(MatriculaAtom, Matricula),
    get_adm_grupo(CodigoAtom,Adm),
    Adm = MatriculaAtom.

% Verifica se um aluno faz parte de um grupo com o código fornecido.
valida_aluno_grupo(CodigoGrupo, Matricula):-
    get_grupo_by_codigo(CodigoGrupo, Grupo),
    extract_info_grupo(Grupo, _, _, Alunos, _, _),
    seach_id(Alunos, Matricula, Aluno, 'aluno'),
    Aluno \= -1.
    
% Verifica se o administrador do grupo coincide com a matrícula fornecida e retorna 1 se for verdadeiro, -1 caso contrário.
verifica_adm_remove(Codigo, Matricula, Result):-
    get_adm_grupo(Codigo,Adm),
    (Adm = Matricula -> Result = 1; Result = -1).

% Adiciona um aluno à lista de alunos de um grupo.
adiciona_aluno_grupo(CodigoG, Matricula):-
    get_grupo_by_codigo(CodigoG, Grupo),
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    NewAlunos = [Aluno | Alunos],
    remove_grupo_by_codigo(CodigoG),
    add_grupo(CodigoG, Nome, NewAlunos, Disciplinas, Adm).

% Remove um aluno da lista de alunos de um grupo.
remove_aluno_grupo(CodigoG, Matricula):-
    get_grupo_by_codigo(CodigoG, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Alunos, Matricula, Aluno, 'aluno'),
    remove_object(Alunos, Aluno, NewAlunos),
    remove_grupo_by_codigo(CodigoG),
    add_grupo(CodigoG, Nome, NewAlunos, Disciplinas, Adm).

% Verifica se uma disciplina com o IdD existe em um grupo com o CodigoGrupo
verifica_disciplina(CodGrupo, IdD):-
    get_grupo_by_codigo(CodGrupo, Grupo),
    extract_info_grupo(Grupo, _, _, _, Disciplinas, _),
    seach_id(Disciplinas, IdD, Disciplina, 'disciplina'),
    Disciplina \= -1.

% Adiciona uma disciplina a um grupo.
add_disciplina_grupo(Codigo, IdDisciplina, NomeDisciplina, Professor, Periodo):-
    \+ verifica_disciplina(Codigo, IdDisciplina),
    Disciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=[], datas=[], links=[]]),
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    NewDisciplinas = [Disciplina | Disciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NewDisciplinas, Adm).

% Remove uma disciplina de um grupo pelo código do grupo e o ID da disciplina
remove_disciplina_grupo(Codigo, IdDisciplina):-
    verifica_disciplina(Codigo, IdDisciplina),
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Elemento, 'disciplina'),
    remove_object(Disciplinas, Elemento, NewDisciplinas),
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NewDisciplinas, Adm).

% Obtém o resumo de um grupo a partir do ID do resumo, código do grupo e ID da disciplina.
getResumoGrupo(IdResumo,Codigo,IdDisciplina,Result):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, _, Disciplinas, _),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, _, _, _, Resumos, _, _),
    seach_id(Resumos, IdResumo, Resumo,'resumo'),
    Result = Resumo.

% Obtém os detalhes de uma data de um grupo a partir do ID da data, código do grupo e ID da disciplina.
getDataGrupo(IdData,Codigo,IdDisciplina,Result):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, _, Disciplinas, _),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, _, _, _, _, Datas, _),
    seach_id(Datas, IdData, Data,'data'),
    Result = Data.

% Obtém os detalhes de um link de um grupo a partir do ID do link, código do grupo e ID da disciplina.
getLinkGrupo(IdLink,Codigo,IdDisciplina,Result):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, _, Disciplinas, _),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, _, _, _, _, _, Links),
    seach_id(Links, IdLink, Link,'link'),
    Result = Link.

% Adiciona um resumo ao grupo especificado.
adiciona_resumo_grupo(Codigo, IdDisciplina, IdResumo, TituloR, ConteudoR):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Links, Datas),
    NewResumo = json([id=IdResumo, titulo=TituloR, corpo=ConteudoR, comentarios=[]]),
    NewResumos = [NewResumo | Resumos],
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=NewResumos, datas=Datas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NDisciplinas, Adm).

% Adiciona um link ao grupo especificado.
adiciona_link_grupo(Codigo, IdDisciplina, IdLink, TituloL, Url):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    NewLink = json([id=IdLink, titulo=TituloL, url=Url, comentarios=[]]),
    NewLinks = [NewLink | Links],
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=Datas, links=NewLinks]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NDisciplinas, Adm).

% Adiciona uma data ao grupo especificado.
adiciona_data_grupo(Codigo, IdDisciplina, IdData, TituloD, DataI, DataF):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    NewData = json([id=IdData, titulo=TituloD, dataInicio=DataI, dataFim=DataF, comentarios=[]]),
    NewDatas = [NewData | Datas],
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=NewDatas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NDisciplinas, Adm).

% Remove um resumo de um grupo especificado pelo código do grupo, ID da disciplina e ID do resumo.
rem_resumo_grupo(Codigo, IdDisciplina, IdResumo):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Resumos, IdResumo, Elemento, 'resumo'),
    remove_object(Resumos, Elemento, NewResumos),
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=NewResumos, datas=Datas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NDisciplinas, Adm).

% Remove uma data de um grupo especificado pelo código do grupo, ID da disciplina e ID da data.
rem_data_grupo(Codigo, IdDisciplina, IdData):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Datas, IdData, Elemento, 'data'),
    remove_object(Datas, Elemento, NewDatas),
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=NewDatas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NDisciplinas, Adm).

% Remove um link de um grupo especificado pelo código do grupo, ID da disciplina e ID do link.
rem_link_grupo(Codigo, IdDisciplina, IdLink):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Links, IdLink, Elemento, 'link'),
    remove_object(Links, Elemento, NewLinks),
    NDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=Datas, links=NewLinks]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NDisciplinas, Adm).

% Adiciona um comentário a um resumo em um grupo.
adiciona_comentario_grupo_resumo(Matricula, CodGrupo, IdDisciplina, IdResumo, IdComentario, Conteudo):-
    get_grupo_by_codigo(CodGrupo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Resumos, IdResumo, Elemento, 'resumo'),
    extract_info_resumo(Elemento, _, Titulo, Corpo, Comentarios),
    NewComentario = json([id=IdComentario, idAluno=Matricula, comentario=Conteudo]),
    NewComentarios = [NewComentario | Comentarios],
    remove_object(Resumos, Elemento, NewResumos),
    NewResumo = json([id=IdResumo, titulo=Titulo, corpo=Corpo, comentarios=NewComentarios]),
    NResumos = [NewResumo | NewResumos],
    NewDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=NResumos, datas=Datas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NewDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(CodGrupo),
    add_grupo(CodGrupo, Nome, Alunos, NDisciplinas, Adm).

% Adiciona um comentário a uma data em um grupo.
adiciona_comentario_grupo_data(Matricula, CodGrupo, IdDisciplina, IdData, IdComentario, Conteudo):-
    get_grupo_by_codigo(CodGrupo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Datas, IdData, Elemento, 'data'),
    extract_info_data(Elemento, _, Titulo, DataInicio, DataFim, Comentarios),
    NewComentario = json([id=IdComentario, idAluno=Matricula, comentario=Conteudo]),
    NewComentarios = [NewComentario | Comentarios],
    remove_object(Datas, Elemento, NewDatas),
    NewData = json([id=IdData, titulo=Titulo, dataInicio=DataInicio, dataFim=DataFim, comentarios=NewComentarios]),
    NDatas = [NewData | NewDatas],
    NewDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=NDatas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NewDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(CodGrupo),
    add_grupo(CodGrupo, Nome, Alunos, NDisciplinas, Adm).

% Adiciona um comentário a um link em um grupo.
adiciona_comentario_grupo_link(Matricula, CodGrupo, IdDisciplina, IdLink, IdComentario, Conteudo):-
    get_grupo_by_codigo(CodGrupo, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Links, IdLink, Elemento, 'link'),
    extract_info_link_util(Elemento, _, Titulo, URL, Comentarios),
    NewComentario = json([id=IdComentario, idAluno=Matricula, comentario=Conteudo]),
    NewComentarios = [NewComentario | Comentarios],
    remove_object(Links, Elemento, NewLinks),
    NewLink = json([id=IdLink, titulo=Titulo, url=URL, comentarios=NewComentarios]),
    NLinks = [NewLink| NewLinks],
    NewDisciplina = json([id=IdDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=Datas, links=NLinks]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NewDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(CodGrupo),
    add_grupo(CodGrupo, Nome, Alunos, NDisciplinas, Adm).

% Edita o corpo de um resumo em um grupo.
edita_resumo_grupo(CodGrupo, CodDisciplina, CodResumo, NewCorpo):-
    get_grupo_by_codigo(CodGrupo , Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, CodDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Links, Datas),
    seach_id(Resumos, CodResumo, Resumo, 'resumo'),
    extract_info_resumo(Resumo, _, Titulo, Corpo, Comentarios),
    NResumo = json([id=CodResumo, titulo=Titulo, corpo=NewCorpo, comentarios=Comentarios]),
    remove_object(Resumos, Resumo, Resumo_Novo),
    NResumos = [ NResumo | Resumo_Novo],
    NDisciplina = json([id=CodDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=NResumos, datas=Datas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NDisciplinas, Adm).

% Edita as datas de um grupo.
edita_data_grupo(CodGrupo, CodDisciplina, CodData, NewDataInicio, NewDataFim):-
    get_grupo_by_codigo(CodGrupo , Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, CodDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Datas, CodData, Data, 'data'),
    extract_info_data(Data, _, Titulo, _, _, Comentarios),
    NData = json([id=CodData, titulo=Titulo, dataInicio=NewDataInicio, dataFim=NewDataFim, comentarios=Comentarios]),
    remove_object(Datas, Data, Data_Nova),
    NDatas = [NData | Data_Nova],
    NDisciplina = json([id=CodDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=NDatas, links=Links]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NDisciplinas, Adm).

% Edita a URL de um link em um grupo.
edita_link_grupo(CodGrupo, CodDisciplina, CodLink, NewUrl):-
    get_grupo_by_codigo(CodGrupo , Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Disciplinas, CodDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, NomeDisciplina, Professor, Periodo, Resumos, Datas, Links),
    seach_id(Links, CodLink, Link, 'link'),
    extract_info_link_util(Link, _, Titulo, _, Comentarios),
    NLink = json([id=CodLink, titulo=Titulo, url=NewUrl, comentarios=Comentarios]),
    remove_object(Links, Link, Link_Novo),
    NLinks = [NLink | Link_Novo],
    NDisciplina = json([id=CodDisciplina, nome=NomeDisciplina, professor=Professor, periodo=Periodo, resumos=Resumos, datas=Datas, links=NLinks]),
    remove_object(Disciplinas, Disciplina, NewDisciplinas),
    NDisciplinas = [NDisciplina | NewDisciplinas],
    remove_grupo_by_codigo(Codigo),
    add_grupo(Codigo, Nome, Alunos, NDisciplinas, Adm).

% Verifica se um aluno está em um grupo
verifica_aluno_grupo(CodigoGrupo, Matricula):-
    atom_string(CodigoAtom, CodigoGrupo),
    atom_string(MatriculaAtom, Matricula),
    valida_aluno_grupo(CodigoAtom, MatriculaAtom).

% Obtém uma lista de grupos concatenados para um aluno.
get_grupo(Matricula, Grupos, GruposConcatenados) :-
    get_grupos_concatenados(Matricula, Grupos, [], GruposConcatenados).

% Concatena grupos em uma lista final.
get_grupos_concatenados(_, [], Result, Result).
get_grupos_concatenados(Matricula, [GrupoAtual | Rest], PartialResult, GruposConcatenados) :-
    (get_group_ids(Matricula, GrupoAtual) ->
        append(PartialResult, [GrupoAtual], NewPartialResult)
    ;
        NewPartialResult = PartialResult
    ),
    get_grupos_concatenados(Matricula, Rest, NewPartialResult, GruposConcatenados).

% Retorna o ID do grupo no qual um aluno está.
get_group_ids(Matricula, Grupo) :-
    extract_info_grupo(Grupo, Id, _, Alunos, _, _),
    verifica_aluno_grupo(Id, Matricula).
