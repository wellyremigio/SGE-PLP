:- use_module(library(dcg/basics)).

% Regra que retorna a lista de disciplinas.
listaDisciplinas(Resposta,Matricula) :- 
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas),
    organizaListagemProdutos(Disciplinas, Resposta).

organizaListagemHistorico([], '').
organizaListagemHistorico([H|T], Resposta) :- 
    organizaListagemHistorico(T, Resposta1),
    ,
    get_info(IdProduto, Tipo, Nome, Descricao),
    concatena_strings(['\nNome: ', Nome, '\nDescrição: ', Descricao,'\n'], ProdutosConcatenados),
    string_concat(ProdutosConcatenados, Resposta1, Resposta).