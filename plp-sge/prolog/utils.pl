:- use_module(library(dcg/basics)).

% Regra que retorna a lista de disciplinas.
listaDisciplinas(Matricula, Resposta) :- 
    get_aluno_by_matricula(Matricula, Aluno),
    extract_info_aluno(Aluno, _, _, _, Disciplinas),
    organizaListagemDisciplinaAluno(Disciplinas, Resposta).

organizaListagemDisciplinaAluno([], '').
organizaListagemDisciplinaAluno([H|T], Resposta) :- 
    organizaListagemDisciplinaAluno(T, Resposta1),
    extract_info_disciplina(H, Id, Nome,Professor, Periodo, _, _, _),
    concatena_strings(['\nID:' ,Id, '\nNome: ', Nome, '\nProfessor: ',Professor, '\nPeríodo: ', Periodo,'\n'], DisciplinasConcatenados),
    string_concat(DisciplinasConcatenados, Resposta1, Resposta).


% Regra que recebe uma lista de string retorna a concatenação de todas
concatena_strings(ListaStrings, Resultado) :-
    concatena_strings_loop(ListaStrings, '', Resultado).

% Regra que auxilia a concatenação de uma lista da lista de strings recebidas
concatena_strings_loop([], Acumulador, Acumulador).
concatena_strings_loop([String | Resto], Acumulador, Resultado) :-
    atom_concat(Acumulador, String, NovoAcumulador),
    concatena_strings_loop(Resto, NovoAcumulador, Resultado).