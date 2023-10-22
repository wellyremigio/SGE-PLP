:- enconding(utf8).
:- set_prolog_flag(encoding, utf8).

cadastraGrupo(CodGrupo, NomeGrupo, Adm, Result) :-
    atom_string(CodGrupoAtom, CodGrupo),
    (\+ valida_grupo(CodGrupoAtom) ->
        add_grupo(CodGrupo, NomeGrupo, Adm),
        Result = 'ok'
    ;
        Result = 'falha'
    ).

%não esta sendo usado em nada por enquanto
verificaGrupo(CodGrupo):-
    atom_string(CodGrupoAtom, CodGrupo),
    valida_grupo(CodGrupoAtom).

verificaAdm(Codigo, Matricula, Result):-
    atom_string(CodigoAtom, Codigo),
    atom_string(MatriculaAtom, Matricula),
    verifica_adm(CodigoAtom, MatriculaAtom, Result).

removeGrupo(Codigo, Adm) :-
    atom_string(CodigoAtom, Codigo),
    get_grupo_by_codigo(CodigoAtom, Grupo),
    Grupo \= -1,
    remove_grupo_by_codigo(CodigoAtom).
