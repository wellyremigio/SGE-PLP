grupos_path('DataBase/Grupo.json').
get_grupos(Data):- grupos_path(Path), load_json_file(Path, Data).

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
    atom_string(CodigoAtom, Codigo),
    get_grupo_by_codigo(CodigoAtom, Grupo),
    extract_info_grupo(Grupo, _, _, _, _, Adm).

verifica_adm(Codigo, Matricula):-
    atom_string(CodigoAtom, Codigo),
    atom_string(MatriculaAtom, Matricula),
    get_adm_grupo(CodigoAtom,Adm),
    Adm = MatriculaAtom.


valida_aluno_grupo(CodigoGrupo, Matricula):-
    get_grupo_by_codigo(CodigoGrupo, Grupo),
    extract_info_grupo(Grupo, _, _, Alunos, _, _),
    seach_id(Alunos, Matricula, Aluno, 'aluno'),
    Aluno \= -1.
    
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

%Regra para adicionar um aluno na lista de alunos
adiciona_aluno_grupo(CodigoG, Matricula):-
    get_grupo_by_codigo(CodigoG, Grupo),
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    NewAlunos = [Aluno | Alunos],
    remove_grupo_by_codigo(CodigoG),
    add_grupo(CodigoG, Nome, NewAlunos, Disciplinas, Adm).

%Regra para remover um aluno da lista de alunos
remove_aluno_grupo(CodigoG, Matricula):-
    get_grupo_by_codigo(CodigoG, Grupo),
    extract_info_grupo(Grupo, _, Nome, Alunos, Disciplinas, Adm),
    seach_id(Alunos, Matricula, Aluno, 'aluno'),
    remove_object(Alunos, Aluno, NewAlunos),
    remove_grupo_by_codigo(CodigoG),
    add_grupo(CodigoG, Nome, NewAlunos, Disciplinas, Adm).


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


getResumoGrupo(IdResumo,Codigo,IdDisciplina,Result):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, _, Disciplinas, _),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, _, _, _, Resumos, _, _),
    seach_id(Resumos, IdResumo, Resumo,'resumo'),
    Result = Resumo.


getDataGrupo(IdData,Codigo,IdDisciplina,Result):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, _, Disciplinas, _),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, _, _, _, _, Datas, _),
    seach_id(Datas, IdData, Data,'data'),
    Result = Data.


getLinkGrupo(IdLink,Codigo,IdDisciplina,Result):-
    get_grupo_by_codigo(Codigo, Grupo),
    extract_info_grupo(Grupo, _, _, _, Disciplinas, _),
    seach_id(Disciplinas, IdDisciplina, Disciplina, 'disciplina'),
    extract_info_disciplina(Disciplina, _, _, _, _, _, _, Links),
    seach_id(Links, IdLink, Link,'link'),
    Result = Link.


%Regra para adicionar um resumo ao grupo
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


%Verifica se um aluno está em um grupo
verifica_aluno_grupo(CodigoGrupo, Matricula):-
    atom_string(CodigoAtom, CodigoGrupo),
    atom_string(MatriculaAtom, Matricula),
    valida_aluno_grupo(CodigoAtom, MatriculaAtom).



get_grupo(Matricula, Grupos, GruposConcatenados) :-
    get_grupos_concatenados(Matricula, Grupos, [], GruposConcatenados).


get_grupos_concatenados(_, [], Result, Result).
get_grupos_concatenados(Matricula, [GrupoAtual | Rest], PartialResult, GruposConcatenados) :-
    (get_group_ids(Matricula, GrupoAtual) ->
        append(PartialResult, [GrupoAtual], NewPartialResult)
    ;
        NewPartialResult = PartialResult
    ),
    get_grupos_concatenados(Matricula, Rest, NewPartialResult, GruposConcatenados).


%Retorna o id do grupo que o aluno tá
get_group_ids(Matricula, Grupo) :-
    extract_info_grupo(Grupo, Id, _, Alunos, _, _),
    verifica_aluno_grupo(Id, Matricula).
