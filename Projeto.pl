%Declarações iniciais

:- op(900, xfy, '::').
:- op(200, xfy, 'e').
:- op(200, xfy, 'ou').
:- dynamic utente/6.
:- dynamic registo/8.
:- dynamic imc/3.
:- dynamic excecao/1.
:- discontiguous (-)/1.
:- discontiguous utente/6.
:- discontiguous excecao/1.
:- discontiguous registo/8.


%Conhecimento Perfeito Positivo

%Predicado Utente(Nome, NUtente, Genero, Idade, Altura, Peso).
utente(toni, 1, m, 20, 187, 77).
utente(toze, 2, m, 21, 170, 110).

%Predicado Registo(NRegisto, NUtente, Dia, Mês, Ano, Idade, Altura, Peso).
registo(1, 1, 30, 12, 2023, 20, 187, 77).
registo(2, 2, 30, 12, 2023, 21, 170, 120).


%Conhecimento Imperfeito

%Conhecimento Imperfeito Incerto
utente(quim, 3, m, 30, 180, peso_desconhecido1).
excecao(utente(Nome, NUtente, Genero, Idade, Altura, _Peso)):-
    utente(Nome, NUtente, Genero, Idade, Altura, peso_desconhecido1).

utente(josefina, 4, f, 25, altura_desconhecida1, 70).
excecao(utente(Nome, NUtente, Genero, Idade, _Altura, Peso)):-
    utente(Nome, NUtente, Genero, Idade, altura_desconhecida1, Peso).

%Conhecimento Imperfeito Impreciso

excecao(utente(maria, 5, f, 40, 165, 67)).
excecao(utente(mariana, 5, f, 40, 165, 67)).

utente(marco, 6, m, idade_desconhecida1, 175, 60).
excecao(utente(marco, 6, m, I, 175, 60)):-
    I >= 30,
    I =< 40.

utente(alex, 7, genero_desconhecido1, 23, 172, 78).
excecao(utente(alex, 7, S, 23, 172, 78)):-
    S == f; S == m.

%Conhecimento Imperfeito Interdito

registo(3, 7, dia_desconhecido1, 1, 2023, 23, 172, 78).
excecao(registo(NRegisto, NUtente, _Dia, Mes, Ano, Idade, Altura, Peso)):-
    registo(NRegisto, NUtente, dia_desconhecido1, Mes, Ano, Idade, Altura, Peso).

interdito(dia_desconhecido1).

+registo(_NRegisto, _NUtente, Dia, _Mes, _Ano, _Idade, _Altura, _Peso) :: 
    (findall(Dia, (registo(3, 7, Dia, 1, 2023, 23, 172, 78), 
    nao(interdito(dia_desconhecido1))), S), 
    length(S,L), L == 0).

%Invariantes de Inserção

%Não inserir utentes com nUte repetidos
+utente(_, NUtente, _, _, _, _) :: (findall(NUtente, utente(_, NUtente, _, _, _, _), S), length(S, L), L == 1).

%Garantir que a idade, peso e altura de um utente são números inteiros
+utente(_, _, _, I, A, P) :: (integer(I), integer(A), integer(P)).

%Não inserir registos com nReg repetidos
+registo(NRegisto, _, _, _, _, _, _, _) :: (findall(NRegisto, registo(NRegisto, _, _, _, _, _, _, _), S), length(S, L), L == 1).

%Não inserir registos com nUte que não estejam na base de dados
+registo(_, NUtente, _, _, _, _, _, _) :: utente(_, NUtente, _, _, _, _).

%Garantir que os elementos da data, idade, peso e altura de um registo são números inteiros
+registo(_, _, D, M, Ano, I, A, P) :: (integer(D), integer(M), integer(Ano), integer(I), integer(A), integer(P)).


%Invariantes de Remoção
%Não remover Utentes com registos associados

-utente(_, NUtente, _, _, _, _) :: (findall(NUtente, registo(NUtente, NUtente, _, _, _, _, _, _), S), length(S,L), L == 0).


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
    number(IMC),
    IMC >= 0,
    IMC < 18.5.

classificacao(IMC, 'Peso Normal'):-
    number(IMC),
    IMC >= 18.5,
    IMC < 25.

classificacao(IMC, 'Excesso de Peso'):-
    number(IMC),
    IMC >= 25,
    IMC < 30.

classificacao(IMC, 'Obesidade Classe I (Moderada)'):-
    number(IMC),
    IMC >= 30,
    IMC < 35.

classificacao(IMC, 'Obesidade Classe II (Severa)'):-
    number(IMC),
    IMC >= 35,
    IMC < 40.

classificacao(IMC, 'Obesidade Classe III (Morbida)'):-
    number(IMC),
    IMC >= 40.

%Representação de Conhecimento Negativo

%Pressuposto do Mundo Fechado

-utente(N, Num, G, I, A, P):-
    nao(utente(N, Num, G, I, A, P)),
    nao(excecao(utente(N, Num, G, I, A, P))).

-registo(NRegisto, D, M, Ano, NUtente, I, A, P):-
    nao(registo(NRegisto, NUtente, D, M, Ano, I, A, P)),
    nao(excecao(registo(NRegisto, NUtente, D, M, Ano, I, A, P))).

%Evolução do conhecimento

registar_utente(Termo):-
    findall(Inv, +Termo::Inv, Lista),
    insercao(Termo),
    validar(Lista).

adicionar_registo(Termo):-
    findall(Inv, +Termo::Inv, Lista),
    insercao(Termo),
    validar(Lista),
    atualizar(Termo).

apagar(Termo):-
    findall(Inv, -Termo::Inv, Lista),
    remocao(Termo),
    validar(Lista).

atualizar(registo(_NRegisto, NUtente, _Dia, _Mes, _Ano, Idade_novo, Altura_novo, Peso_novo)):-
    retract(utente(Nome, NUtente, Genero, _, _, _)),
    assert(utente(Nome, NUtente, Genero, Idade_novo, Altura_novo, Peso_novo)).

insercao(Termo):-assert(Termo).
insercao(Termo):-retract(Termo),!,fail.

remocao(Termo):-retract(Termo).
remocao(Termo):-assert(Termo),!,fail.

validar([]).
validar([H|T]):-H, validar(T).

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

%Definição de novos operadores que realizam a conjunção e a disjunção.

e(Q1, Q2):-
    Q1, Q2.

-e(Q1, Q2):-
    -Q1; -Q2.    

ou(Q1,Q2):-
    Q1; Q2.

-ou(Q1, Q2):-
    -Q1, -Q2.
