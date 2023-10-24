load_json_file(File, Data) :-
    open(File, read, Stream),
    json_read(Stream, Data),
    close(Stream).

% Regra geral salvar no banco de dados uma estrutura JSON recebida como parâmetro
save_json_file(File, Data) :-
    open(File, write, Stream),
    json_write(Stream, Data),
    close(Stream).

% Regra para adicionar um elemento a um arquivo JSON
save_object(File, Element) :-
    load_json_file(File, Data),
    New_Data = [Element | Data],
    save_json_file(File, New_Data).


% Regras que extraem as informações das entidades já citadas do banco de dados
extract_info_aluno(json([id=Id, nome=Nome, senha=Senha, disciplinas=Disciplinas]), Id, Nome, Senha, Disciplinas).
extract_info_disciplina(json([id=Id, nome=Nome, professor=Professor, periodo=Periodo, resumos=Resumos, datas=Datas, links=Links]), Id, Nome, Professor, Periodo, Resumos, Datas, Links).
extract_info_grupo(json([id=Id, nome=Nome, alunos=Alunos, disciplinas=Disciplinas, adm=Adm]), Id, Nome, Alunos, Disciplinas, Adm).
extract_info_resumo(json([id=Id, titulo=Titulo, corpo=Corpo, comentarios=Comentarios]), Id, Titulo, Corpo, Comentarios).
extract_info_link_util(json([id=Id, titulo=Titulo, url=URL, comentarios=Comentarios]), Id, Titulo, URL, Comentarios).
extract_info_data(json([id=Id, titulo=Titulo, dataInicio=DataInicio, dataFim=DataFim, comentarios=Comentarios]), Id, Titulo, DataInicio, DataFim, Comentarios).
extract_info_comentario(json([id=Id, idAluno=IdAluno, comentario=Comentario]), Id, IdAluno,Comentario).

% Regra que generaliza a extração do ID das entidades do banco de dados já citadas
% (Essa regra é importante para generalizar o uso da regra de busca por ID)
extract_id_object('aluno', Head_Object, Object_Id) :- extract_info_aluno(Head_Object, Object_Id, _, _, _).
extract_id_object('disciplina', Head_Object, Object_Id) :- extract_info_disciplina(Head_Object, Object_Id, _, _, _, _, _, _).
extract_id_object('grupo', Head_Object, Object_Id) :- extract_info_grupo(Head_Object, Object_Id, _, _, _, _).
extract_id_object('resumo', Head_Object, Object_Id) :- extract_info_resumo(Head_Object, Object_Id, _, _, _).
extract_id_object('link', Head_Object, Object_Id) :- extract_info_link_util(Head_Object, Object_Id, _, _, _).
extract_id_object('data', Head_Object, Object_Id) :- extract_info_data(Head_Object, Object_Id, _, _, _, _).
extract_id_object('comentario', Head_Object, Object_Id) :- extract_info_comentario(Head_Object, Object_Id, _, _).


% Regra geral que busca qualquer entidade por ID
% Caso a entidade não seja encontrada, -1 é retornado
seach_id([], _, -1, _) :- !. % Caso não o objeto buscado não exista, -1 é retornado
seach_id([Head_Object|Tail], Id, Object, Type) :- 
    extract_id_object(Type, Head_Object, Object_Id),
    (Object_Id = Id -> Object = Head_Object; seach_id(Tail, Id, Object, Type)).

% Regra que generaliza a busca de entidades por id
get_object_by_id(File, Id, Object, Type):-
    load_json_file(File, Data),
    seach_id(Data, Id, Object, Type).
 
% Regra geral que remove um elemento de uma lista recebida
% e tem como resultado a lista sem o elemento
remove_object([], _, []).
remove_object([Header|Tail], Object, Final_Data):-
    remove_object(Tail, Object, Data),
    (Header = Object -> Final_Data = Data ; Final_Data = [Header | Data]).

% Regra geral que unifica a remoção de objetos por ID
remove_object_by_id(File, Id, Type):-
    load_json_file(File, Data),
    seach_id(Data, Id, Object, Type),
    remove_object(Data, Object, Final_Data),
    save_json_file(File, Final_Data).