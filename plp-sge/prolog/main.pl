%Comando pra rodar 
% swipl -s main.pl


prompt(Message, String):-
    write(Message),
    flush_output,
    read_line_to_codes(user_input, Codes),
    string_codes(String, Codes).

main:-
    writeln( '\n =========== Olá! Seja bem vindo ao SGE: Sistema de Gerenciamento de Estudos :D ===========\n'),
    write('\n Escolha uma opção para começar a navegar no sistema: \n'),
    write('1. Login\n'),
    write('2. Cadastrar\n'),
    write('3. Sair\n'),
    prompt('->', Input),
    atom_number(Input, Opcao),
    write('\n'),
    opSelecionada(Opcao).

opSelecionada(1):-
    menuLogin,
    main.

opSelecionada(2):-
    menuCadastro,
    main.

opSelecionada(3):-
    write('Saindo...\n'),
    halt.

opSelecionada(_):-
    write('Ops! Entrada Inválida...\n'),
    main.