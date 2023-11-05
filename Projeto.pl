%Declarações iniciais

:- op(900, xfy, '::').
:- op(100, xfy, 'e').
:- op(100, xfy, 'ou').
:- dynamic utente/6.
:- dynamic registo/8.
:- dynamic imc/3.
:- dynamic '-'/1.
:- dynamic registar/1.

%Predicado Utente(Nome, NUtente, Genero, Idade, Altura, Peso).

utente(toni, 1, m, 20, 187, 77).
utente(toze, 2, m, 20, 187, 890).

%Predicado Registo(NRegisto, Dia, Mês, Ano, NUtente, Idade, Altura, Peso).

registo(1, 1, 1, 2023, 1, 20, 187, 77).

%Invariantes

%Nao pode adicionar mais que um utente com o mesmo numero de utente
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


%Calcular IMC e atribuir classificacao
%Predicado imc(Nutente, IMC).

imc(Nutente, IMC):-
    utente(N, Nutente, G, I, A, P),
    IMC is P/(A/100)^2.
    
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

%Pressuposto do Mundo Fechado

-utente(N, Num, G, I, A, P):-
    nao(utente(N, Num, G, i, A, P)),
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

atualizar(registo(NRegisto, Dia, Mes, Ano, NUtente, Idade_novo, Altura_novo, Peso_novo)):-
    retract(utente(Nome, NUtente, Genero, Idade, Altura, Peso)),
    assert(utente(Nome, NUtente, Genero, Idade_novo, Altura_novo, Peso_novo)).

inserir(Termo):-
    assert(Termo).
inserir(Termo):-
    retract(Termo), !, Fail

validar([]).
validar([L|R]):-
    L,
    validar(R).

nao(Q):-
    	Q, !, fail.
nao(Q).

%Sistema de inferência

si(Q,verdadeiro):-
    Q.
si(Q,falso):-
    -Q.
si(Q,desconhecido):-
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