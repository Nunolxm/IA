%Declarações iniciais

:- op(900, xfy, '::').
:- op(200, xfy, 'e').
:- op(200, xfy, 'ou').
:- dynamic utente/6.
:- dynamic registo/8.
:- dynamic imc/3.
:- discontiguous (-)/1.

%Predicado Utente(Nome, NUtente, Genero, Idade, Altura, Peso).

utente(toni, 1, m, 20, 187, 77).
utente(toze, 2, m, 20, 187, pesodesconhecido).

%Predicado Registo(NRegisto, Dia, Mês, Ano, NUtente, Idade, Altura, Peso).

registo(1, 1, 1, 2023, 1, 20, 187, 77).

%Invariantes




%Calcular IMC e atribuir classificacao
%Predicado imc(Nutente, IMC).

imc(NUtente, IMC):-
    utente(_, NUtente, _, _, A, P),
    integer(A), integer(P),
    IMC is P/(A/100)^2.

imc(NUtente, imc_desconhecido):-
    utente(_, NUtente, _, _, _, _).

-imc(_NUtente, _IMC).
    
%Predicado classificacao(IMC, Classificação) 

classificacao(IMC, 'Baixo Peso'):-
    IMC >= 0,
    IMC < 18.5.

classificacao(IMC, 'Peso Normal'):-
    IMC >= 18.5,
    IMC < 25.

classificacao(IMC, 'Excesso de Peso'):-
    IMC >= 25,
    IMC < 30.

classificacao(IMC, 'Obesidade Classe I (Moderada)'):-
    IMC >= 30,
    IMC < 35.

classificacao(IMC, 'Obesidade Classe II (Severa)'):-
    IMC >= 35,
    IMC < 40.

classificacao(IMC, 'Obesidade Classe III (Mórbida)'):-
    IMC >= 40.

%Representação de Conhecimento Negativo

%Pressuposto do Mundo Fechado

-utente(N, Num, G, I, A, P):-
    nao(utente(N, Num, G, I, A, P)),
    nao(excecao(utente(N, Num, G, I, A, P))).

-registo(NRegisto, D, M, A, NUtente, I, A, P):-
    nao(registo(NRegisto, D, M, A, NUtente, I, A, P)),
    nao(excecao(registo(NRegisto, D, M, A, NUtente, I, A, P))).

%Evolução do conhecimento

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

atualizar(registo(_NRegisto, _Dia, _Mes, _Ano, NUtente, Idade_novo, Altura_novo, Peso_novo)):-
    retract(utente(Nome, NUtente, Genero, _, _, _)),
    assert(utente(Nome, NUtente, Genero, Idade_novo, Altura_novo, Peso_novo)).

inserir(Termo):-
    assert(Termo).
inserir(Termo):-
    retract(Termo), !, Fail.

validar([]).
validar([L|R]):-
    L,
    validar(R).

%Sistema de inferência

si(Q,verdadeiro):-
    Q.
si(Q,falso):-
    -Q.
si(Q,desconhecido):-
    nao(Q),
    nao(-Q).

nao(Q):-
    Q, !, fail.
nao(_Q).

e(Q1, Q2):-
    Q1, Q2.

-e(Q1, Q2):-
    -Q1; -Q2.    

ou(Q1,Q2):-
    Q1; Q2.

-ou(Q1, Q2):-
    -Q1, -Q2.
