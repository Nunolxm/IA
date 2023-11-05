%declarações iniciais

:- op(900, xfy, '::').
:- op(100, xfy, 'e').
:- op(100, xfy, 'ou').
:- dynamic utente/6.
:- dynamic registo/8.
:- dynamic imc/3.
:- dynamic '-'/1.
:- dynamic atualizar/1.

%utente(utente(Nome, NUtente, Genero, Idade, Altura, Peso).

utente(toze, 2, m, 20, 187, 890).
utente(tonho, 4, m, idadedesconhecida, 222, 22).
excecao(utente(Nome, NUtente, Genero, Idade, Altura, Peso)):- utente(Nome, NUtente, Genero, idadedesconhecida, Altura, Peso).
excecao(utente(quim, 5, m, 30, 222, 22)).

%registo(NRegisto, Dia, Mes, Ano, NUtente, Idade, Altura, Peso).

registo(1, 1, 1, 2023, 1, 20, 187, 77).

%calc_imc(#imc, classe, linf, lsup).

imc(NUtente, IMC):-
    utente(N, NUtente, G, I, A, P),
    IMC is P/(A/100)^2.

classe(IMC, 'baixo peso'):-
    IMC >= 0,
    IMC < 18.5.

classe(IMC, 'peso normal'):-
    IMC >= 18.5,
    IMC < 25.

classe(IMC, 'sobrepeso'):-
    IMC >= 25,
    IMC < 30.

classe(IMC, 'obesidade1'):-
    IMC >= 30,
    IMC < 35.

classe(IMC, 'obesidade2'):-
    IMC >= 35,
    IMC < 40.

classe(IMC, 'obesidade3'):-
    IMC >= 40.

si(Q, verdadeiro) :-
    Q.
si(Q, falso) :-
    -Q.
si(Q, desconhecido) :-
    nao(Q),
    nao(-Q).

e(Q1, Q2):-
    Q1, Q2.

-e(Q1, Q2):-
    -Q1; -Q2.    

ou(Q1,Q2):-
    Q1; Q2.

-ou(Q1, Q2):-
    -Q1, -Q2.

-utente(Nome, NUtente, Genero, Idade, Altura, Peso):-
    nao(utente(Nome, NUtente, Genero, Idade, Altura, Peso)),
    nao(excecao(utente(Nome, NUtente, Genero, Idade, Altura, Peso))).

-registo(NRegisto, Dia, Mes, Ano, NUtente, Idade, Altura, Peso):-
    nao(registo(NRegisto, Dia, Mes, Ano, NUtente, Idade, Altura, Peso)),
    nao(excecao(registo(NRegisto, Dia, Mes, Ano, NUtente, Idade, Altura, Peso))).

-teste(N):-
    nao(teste(N)),
    nao(excecao(teste(N))).

nao(Q):-
    Q, !, fail.
nao(Q).

+utente(Nome, NUtente, Genero, Idade, Altura, Peso)::(findall( (Nome, NUtente, Genero, Idade, Altura, Peso),
    (utente(Nome, NUtente, Genero, Idade, Altura, Peso)),S ),
    length( S,N ), N == 1).

%Nao pode adicionar mais que um registo com o mesmo numero de registo
+registo(NRegisto, Dia, Mes, Ano, NUtente, Idade, Altura, Peso)::(findall((NRegisto,NUtente),
    registo(NRegisto, Dia, Mes, Ano, NUtente, Idade, Altura, Peso),S ),
    write(S),
    length( S,N ), N == 1).

%Nao pode adicionar um registo para um utente que nao exista
+registo(NRegisto, Dia, Mes, Ano, NUtente, Idade, Altura, Peso)::(findall((Nome),
    (registo(NRegisto, Dia, Mes, Ano, NUtente, Idade, Altura, Peso),
    utente(Nome, NUtente, Genero, Idade, Altura, Peso)),S ),
    write(S),
    length( S,N ), N == 1).


atualizar(registo(NRegisto, Dia, Mes, Ano, NUtente, Idade_novo, Altura_novo, Peso_novo)):-
    retract(utente(Nome, NUtente, Genero, Idade, Altura, Peso)),
    assert(utente(Nome, NUtente, Genero, Idade_novo, Altura_novo, Peso_novo)).

registar_utente(Termo):-
    findall(Inv, +Termo::Inv, Lista),
    inserir(Termo),
    validar(Lista).

adicionar_registo(Termo):-
    findall(Inv, +Termo::Inv, Lista),
    inserir(Termo),
    validar(Lista),
    atualizar(Termo).

remover_utente(Termo):-
    findall(Inv, -Termo::Inv, Lista),
    retirar(Termo),
    validar(Lista).

apagar_registo(Termo):-
    findall(Inv, -Termo::Inv, Lista),
    retirar(Termo),
    validar(Lista).

inserir(Termo):-
    assert(Termo).
inserir(Termo):-
    retract(Termo), !, fail.

retirar(Termo):-
    retract(Termo).
retirar(Termo):-
    assert(Termo), !, fail.

validar([]).
validar([L|R]):-
    L,
    validar(R).

