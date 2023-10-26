# SGE-PLP
 Sistema que permite o gerenciamento dos estudos, facilitando o acesso a resumos, a links com informações úteis e a datas importantes.
 Clique [aqui](https://docs.google.com/document/d/1PnUk1Dmr-Bj9FJqM9086Hsqwr5Xn6W4ARMu6aCHID0s/edit) para ver as especificações.

## Pré-requisitos
Para esse projeto foi usado o Cabal, por isso será necessária sua instalação na máquina. Recomenda-se instalar o [GHCup](https://www.haskell.org/ghcup/).

## Executando o programa
1. Certifique-se de ter clonado a `branch main`.
2. Faça o `clean` do projeto para garantir a corretude do sistema:
   
sh
   cabal clean
    
2. `build` o projeto para que todas as dependências sejam instaladas:
    
sh
    cabal build
    
3. Execute o sistema com `run`:

    
sh
    cabal run

## Implementação Lógica (Prolog)
Para utilizar esse projeto é necessário instalar no seu computador o SWI-Prolog.[SWI](https://www.swi-prolog.org)


### Instruções para execução


1. Clone a `branch main`.
2. Vá até o diretório Prolog:


   ```sh
   cd .\Prolog\
    ```
2. Use o comando `swipl` para executar o código:


    ```sh
    swipl -s main.pl
    ```
3. Os comando não necessitam do ponto final.
