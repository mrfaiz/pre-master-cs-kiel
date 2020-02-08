/**
Who is on board?
A Quidditch club would like to put together a three-person board consisting of a chairperson, a treasurer and a secretary. The candidates are Potter, Weasley, Malfoy and Granger. There are however different preferences of the individual members, which limit the possibilities for the formation of a board.

Potter and Malfoy do not want to join the board together.
Malfoy is only available for the board if Granger becomes chairperson.
Weasley will only join the board if Potter also belongs to it.
Potter does not want to join the board if Granger becomes the secretary.
Granger does not join the board if Weasley becomes chairperson.
Write a Prolog program that calculates all possible board member constellations.

Note: Make sure to avoid duplicate answers!
 */
candidate(potter).
candidate(weasley).
candidate(malfoy).
candidate(granger).

board(Chairperson,Treasurer,Secretary):- 
    candidate(Chairperson),
    candidate(Treasurer),
    candidate(Secretary),    
    potterMalfoy(board(Chairperson,Treasurer,Secretary)),
    malfoyGranger(board(Chairperson,Treasurer,Secretary)),
    weasleyOnBoard(board(Chairperson,Treasurer,Secretary)),
    potterGranger(board(Chairperson,Treasurer,Secretary)),
    grangerWeasley(board(Chairperson,Treasurer,Secretary)),
    Chairperson \= Treasurer,
    Chairperson \= Secretary,
    Treasurer \= Secretary.

onBoard(P, board(P,_,_)).
onBoard(P, board(_,P,_)).
onBoard(P, board(_,_,P)).

notInBoard(Person,board(Chairperson,Treasurer,Secretary)) :- Person \= Chairperson, Person \= Treasurer , Person \=Secretary.

potterMalfoy(board(C,T,S)) :- onBoard(potter,board(C,T,S)),notInBoard(malfoy,board(C,T,S)).
potterMalfoy(board(C,T,S)) :- notInBoard(potter,board(C,T,S)),onBoard(malfoy,board(C,T,S)).

malfoyGranger(board(granger,T,S)) :- onBoard(malfoy,board(granger,T,S)).
malfoyGranger(board(C,T,S)) :- notInBoard(malfoy,board(C,T,S)).

weasleyOnBoard(board(C,T,S)) :- onBoard(potter,board(C,T,S)),onBoard(weasley,board(C,T,S)).
weasleyOnBoard(board(C,T,S)) :- notInBoard(weasley,board(C,T,S)).

potterGranger(board(C,T,granger)) :- notInBoard(potter,board(C,T,granger)).
potterGranger(board(_,_,S)) :- S \= granger.

grangerWeasley(board(weasley,T,S)) :- notInBoard(granger,board(weasley,T,S)).
grangerWeasley(board(C,_,_)) :- C\=weasley.

% Family Exercise

mother(susanne,monika).
mother(morbet,monika).
mother(monika,ulrike).
mother(herbert,christina).
mother(angelika,christina).
mother(andreas,angelika).
mother(huberd,maria).

husband(monika,herbert).
husband(angelika,huberd).
husband(christina,heinz).
husband(maria,fritz).

female(susanne).
female(P) :- mother(_,P).

male(morbet).
male(andreas).
male(P) :- husband(_,P).

father(Child,F):- mother(Child,Mom),husband(Mom,F).

grandmother(C,G) :- mother(C,Cmom),mother(Cmom,G).
grandfather(GChild,GF) :- grandmother(GChild,Gmother),husband(Gmother,GF).

siblings(Sof,S) :- mother(Sof,M),mother(S,M),Sof\=S.

sister(SisOf,Sresult) :- siblings(SisOf,Sresult),female(Sresult).

son(SonOf,P) :- mother(P,SonOf),male(P).

parent(P,Prnt) :- mother(P,Prnt).
parent(P,Prnt) :- father(P,Prnt).

ancestor(A,R) :- parent(A,R).
ancestor(A,R) :- parent(A,R1),ancestor(R1,R).

child(C,P) :- mother(C,P).
child(C,P) :- father(C,P).

cousin(C,P) :- child(C,F),siblings(F,S2),child(P,S2).

spouse(S,P) :- husband(S,P).
spouse(S,P) :- husband(P,S).

brother(B,P) :- siblings(B,P),male(B).

brother_in_law(B,P) :- brother(B,B1),spouse(B1,P).
brother_in_law(B,P) :- siblings(P,B1),male(B),spouse(B1,B).

% list exercise

member2(E,[E|Xs]) :- member(E,Xs).
member2(E,[_|Xs]) :- member2(E,Xs).

app([],Ys,Ys).
app([X|Xs],Ys,[X|Zs]) :- app(Xs,Ys,Zs).

prefix2(Xs,Ys) :- app(Xs,_,Ys).

suffix(L1,L2) :- app(_,L1,L2).

sublist2(S,L) :- suffix(S1,L),prefix2(S,S1).

mem(E,L) :- sublist2([E],L).

reverse([],[]).
reverse([X|Xs],Ys) :- reverse(Xs,L2),app(L2,[X],Ys).


%Binary Number

/**
 * i + i  = oi     //(i + i = oi)
 * i + o(X) = i(X) // i + oi = ii  or i + oioi = iioi
 * i + i(X) = o(Z) // i + io = oi  or i + ii   = ooi
*/

addP(i,i,   o(i)).
addP(i,o(X),i(X)).
addP(i,i(X),o(Z)) :- addP(i,X,Z).
/**
 * i(X) + i  = o(Z)     //(i + i = oi)
 * i(X) + o(X) = i(Z) // i + oi = ii  or i + oioi = iioi
 * i(X) + i(Y) = o(Z) // i + io = oi  or i + ii   = ooi
*/
addP(i(X),i,o(Z)):-addP(X,i,Z).
addP(i(X),o(Y),i(Z)) :- addP(X,Y,Z).
addP(i(X),i(Y),o(Z)) :- addP(X,Y,K),add(i,K,Z).

addP(o(X),i,i(X)).
addP(o(X),o(Y),o(Z)) :- addP(X,Y,Z).
addP(o(X),i(Y),i(Z)) :- addP(X,Y,Z).



add(o,X,   X).
add(X,o,   X).
add(pos(X),pos(Y),pos(Z)):- addP(X,Y,Z).

sub(X,Y,Z) :- add(Z,Y,X).

% add with lessP

lessP(o,i).
lessP(o,o(_)).
lessP(o,i(_)).
lessP(i,i(_)).
lessP(i,o(_)).
lessP(o(X),i(X)).
lessP(o(X),i(Y)):-lessP(X,Y).
lessP(i(X),o(Y)):-lessP(X,Y).
lessP(o,pos(i)).
lessP(pos(X),pos(Y)):-lessP(X,Y).

add2(pos(X),pos(Y),pos(Z)) :- lessP(X,Y),addP(X,Y,Z).


%% Binary Operations 
and(true,X,X).
and(false,_,false).

or(true,_,true).
or(false,X,X).

not(true,false).
not(false,true).

% (X /\ Y) / Z
ex1(X, Y, Z, Res) :- and(X,Y,AndR), or(AndR,Z,Res).

% (X /\ Y) / ((Y /\ Z) /\ Z)
ex2(X, Y, Z, Res) :- and(X,Y,R1),and(Y,Z,R2),and(R2,Z,R3),or(R1,R3,Res).

%(X /\ (not Y) /\ Z) / ((Z /\ Y) / Z)
ex3(X, Y, Z, Res):- not(Y,R1),and(X,R1,R2),and(R2,Z,R3),and(Z,Y,R4),or(R4,Z,R5),or(R3,R5,Res).