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

verificaGrupo(CodGrupo):-
    atom_string(CodGrupoAtom, CodGrupo),
    valida_grupo(CodGrupoAtom).