%%% REGRAS GERAIS %%%
% Regra geral para ler um arquivo JSON do banco de dados
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
extract_info_aluno(json([matricula=Matricula, nome=Nome, senha=Senha, disciplinas=Disciplinas]), Matricula, Nome, Senha, Disciplinas).
extract_info_disciplina(json([id=Id, nome=Nome, professor=Professor, periodo=Periodo, resumos=Resumos, datas=Datas, links=Links]), Id, Nome, Professor, Periodo, Resumos, Datas, Links).
extract_info_grupo(json([codigo=Codigo, nome=Nome, alunos=Alunos, disciplinas=Disciplinas, adm=Adm]), Codigo, Nome, Alunos, Disciplinas, Adm).
extract_info_resumo(json([id=Id, titulo=Titulo, corpo=Corpo, comentario=Comentarios]), Id, Titulo, Corpo, Comentarios).
extract_info_link_util(json([id=Id, titulo=Titulo, url=URL, comentariosLink=ComentariosLink]), Id, Titulo, URL, ComentariosLink).
extract_info_data(json([id=Id, titulo=Titulo, dataInicio=DataInicio, dataFim=DataFim, comentariosData=ComentariosData]), Id, Titulo, DataInicio, DataFim, ComentariosData).
extract_info_comentario(json([id=Id, idAluno=IdAluno, texto=Texto]), Id, IdAluno, Texto).

% Regra que generalizam a extração do Id das entidades do banco de dados já citadas
% (Esse regra é importante para generalizar o uso do regra de busca por ID)
extract_id_object('alunos', Head_Object, Matricula) :- extract_info_aluno(Head_Object, Matricula, _, _, _).
extract_id_object('disciplinas', Head_Object, Object_Id) :- extract_info_disciplina(Head_Object, Object_Id, _, _, _, _, _, _).
extract_id_object('grupos', Head_Object, Object_Id) :- extract_info_grupo(Head_Object, Object_Id, _, _, _, _).
extract_id_object('resumos', Head_Object, Object_Id) :- extract_info_resumo(Head_Object, Object_Id, _, _, _).
extract_id_object('links', Head_Object, Object_Id) :- extract_info_link_util(Head_Object, Object_Id, _, _, _).
extract_id_object('datas', Head_Object, Object_Id) :- extract_info_data(Head_Object, Object_Id, _, _, _, _).
extract_id_object('comentarios', Head_Object, Object_Id) :- extract_info_comentario(Head_Object, Object_Id, _, _).

% Regra geral que busca qualquer entidade por ID
% Caso a entidade não seja encontrada, -1 é retornado
seach_id([], _, -1, _) :- !. % Caso não o objeto buscado não exista, -1 é retornado
seach_id([Head_Object|Tail], Id, Object, Type) :- 
    extract_id_object(Type, Head_Object, Object_Id),
    (Object_Id = Id -> Object = Head_Object; seach_id(Tail, Id, Object, Type)).

% Regra que generaliza a busca de entidades por id
get_object_by_id(File, Id, Object, Type) :- 
    load_json_file(File, Data),
    seach_id(Data, Id, Object, Type).

% Regra geral que remove um elemento de uma lista recebida
% e tem como resultado a lista sem o elemento
remove_object([], _, []).
remove_object([Header|Tail], Object, Final_Data) :-
    remove_object(Tail, Object, Data),
    (Header = Object -> Final_Data = Data ; Final_Data = [Header | Data]).

% Regra geral que unifica a remoção de objetos por ID
remove_object_by_id(File, Id, Type) :-
    load_json_file(File, Data),
    seach_id(Data, Id, Object, Type),
    remove_object(Data, Object, Final_Data),
    save_json_file(File, Final_Data).