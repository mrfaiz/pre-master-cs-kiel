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

siblings(Sof,S) :- mother(Sof,M),mother(S,M), Sof\=S.

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


findAllChilds(P,L) :- findall((P,M), mother(P,M),L).

siblings2(Sof,Person) :- Sof\=Person,mother(Sof,M),mother(Person,M).
/**
 * siblings(S,P) :- \+ S = P, mother(S,M), mother(P,M).
A proof could then look as follows.
?- siblings(angela,P).
`
?- \+ angela=P, mother(angela,M), mother(P,M).
` delay evaluation of first literal
and prove second literal
?- \+ angela=P, mother(P,christine).
`
?- \+ angela=john.
`
?-.
 */

p(X,Z):-q(X,Y),p(Y,Z).
p(X,X).
q(a,b).

yes:-ab(X),!,X=a.
yes.
ab(a).
ab(b).
