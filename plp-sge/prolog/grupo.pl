:- enconding(utf8).
:- set_prolog_flag(encoding, utf8).

%Cadastra um grupo
cadastraGrupo(CodGrupo, NomeGrupo, Adm, Result) :-
    atom_string(CodGrupoAtom, CodGrupo),
    (\+ valida_grupo(CodGrupoAtom) ->
        add_grupo(CodGrupo, NomeGrupo, Adm),
        Result = 'ok'
    ;
        Result = 'falha'
    ).

%Verifica se um grupo está cadastrado
verificaGrupo(CodGrupo):-
    atom_string(CodGrupoAtom, CodGrupo),
    valida_grupo(CodGrupoAtom).

%Verifica se um aluno é administrador do grupo
verificaAdm(Codigo, Matricula, Result):-
    atom_string(CodigoAtom, Codigo),
    atom_string(MatriculaAtom, Matricula),
    verifica_adm_remove(CodigoAtom, MatriculaAtom, Result).

%Remove um grupo
removeGrupo(Codigo, Adm) :-
    atom_string(CodigoAtom, Codigo),
    get_grupo_by_codigo(CodigoAtom, Grupo),
    Grupo \= -1,
    remove_grupo_by_codigo(CodigoAtom).
    
adicionaAlunoGrupo(CodGrupo, MatriculaAluno):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(MatriculaAtom, MatriculaAluno),
    adiciona_aluno_grupo(CodGrupoAtom, MatriculaAtom).


%Cadastra uma disciplina no grupo
cadastraDisciplinaGrupo(CodGrupo, IdDisciplina, Nome, Professor, Periodo, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    atom_string(NomeAtom, Nome),
    atom_string(ProfessorAtom, Professor),
    atom_string(PeriodoAtom, Periodo),
    add_disciplina_grupo(CodGrupoAtom, IdDisciplinaAtom, NomeAtom, ProfessorAtom, PeriodoAtom),
    atomic_list_concat(['\nDisciplina cadastrada! Código: ', IdDisciplinaAtom, '\n'], Result).

cadastraDisciplinaGrupo(_, _, _, _, _, '\nDisciplina não cadastrada!\n').

%não está sendo usado no momento, mas pode ser util
validaDisciplina(CodGrupo, IdDisciplina):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    \+verifica_disciplina(CodGrupoAtom, IdDisciplinaAtom).

%Remove uma disciplina do grupo
removeDisciplinaGrupo(CodGrupo, IdDisciplina, Result):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(IdDisciplinaAtom, IdDisciplina),
    remove_disciplina_grupo(CodGrupoAtom, IdDisciplinaAtom),
    Result = '\nDisciplina Removida com Sucesso!\n'.

removeDisciplinaGrupo(_, _, '\nDisciplina não encontrada!\n').

%Lista as disciplinas de um grupo
listagemDisciplinaGrupo(CodGrupo, Resposta) :-
    atom_string(CodGrupoAtom, CodGrupo),
    listaDisciplinaGrupo(CodGrupoAtom, Resposta).

%Lista os alunos de um grupo
listagemAlunosGrupo(CodGrupo, Resposta) :-
    atom_string(CodGrupoAtom, CodGrupo),
    listaAlunosGrupo(CodGrupoAtom, Resposta).

%Lista os grupos
listagemGrupos(Resposta) :-
    get_grupos(Data),
    (Data = [] -> 
        Resposta = 'Não existem grupos cadastrados'
    ;
        organizaListagemGrupo(Data, Resposta)
    ).

adicionaAlunoGrupo(CodGrupo, MatriculaAluno):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(MatriculaAtom, MatriculaAluno),
    adiciona_aluno_grupo(CodGrupoAtom, MatriculaAtom).

removeAlunoGrupo(CodGrupo, MatriculaAluno):-
    atom_string(CodGrupoAtom, CodGrupo),
    atom_string(MatriculaAtom, MatriculaAluno),
    remove_aluno_grupo(CodGrupoAtom, MatriculaAtom).
