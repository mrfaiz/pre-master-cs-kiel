date(date(_,_,_)).

year(date(_,_,Y),Y).
month(date(_,M,_),M).
day(date(D,_,_),D).

tree(leaf(_)).
tree(branch(LT,RT)) :- tree(LT),tree(RT).

list([]).
list([_|Xs]) :- list(Xs).

member2(E,[E|_]).
member2(E,[_|Xs]) :- member2(E,Xs).

app([],Ys,Ys).
app([X|Xs],Ys,[X|Zs]) :- app(Xs,Ys,Zs).

prefix2(Xs,Ys) :- app(Xs,_,Ys).

suffix(L1,L2) :- app(_,L1,L2).

sublist2(S,L) :- suffix(S1,L),prefix2(S,S1).

mem(E,L) :- sublist2([E],L).

isPeano(o).
isPeano(s(N)) :- isPeano(N).

add(o,M,M).
add(s(X),Y,s(R)) :- add(X,Y,R).

sub(X,Y,R) :- add(Y,R,X).

leq(o,_).
leq(s(N),s(M)) :- leq(N,M).

len([],    o).
len([_|Xs],s(R)):-len(Xs,R).

perm([],    []).
perm([X|Xs],Ys) :- perm(Xs,Zs),insert(X,Zs,Ys).

insert(X,Ys,    [X|Ys]).
insert(X,[Y|Ys],[Y|Zs]) :-insert(X,Ys,Zs).

sorted([]).
sorted([_]).
sorted([X1,X2|Xs]):- X1=<X2,sorted([X2|Xs]).

sort2(X,Y) :- perm(X,Y),sorted(Y).

lookup1(K,Xs,V):-mem(K,Xs),mem(V,Xs).

mem2(X, [X|Zs]) :- mem(X, Zs).
mem2(X, [_|Zs]) :- mem2(X, Zs).


% mem22(X, Zs) :- app(_, [X], Xs), app(_, [X|_], Ys), app(Xs, Ys, Zs).
reverse([],[]).
reverse([X|Xs],Ys) :- reverse(Xs,L2),app(L2,[X],Ys).

gt(s(_),o).
gt(s(M),s(N)) :- gt(M,N).

mapFromTo(N,N,[N]).
mapFromTo(N,M,[N|Zs]) :- gt(M,N),mapFromTo(s(N),M,Zs).

dropLess(_,[],    []).
dropLess(N,[N|Xs],[N|Zs]) :- dropLess(N,Xs,Zs).
dropLess(N,[M|Xs],[M|Zs]) :- gt(M,N),dropLess(N,Xs,Zs).
dropLess(N,[M|Xs],Zs)     :- gt(N,M),dropLess(N,Xs,Zs).

% dropLess(s(s(o)),[s(o),o,s(s(s(s(o))))],L).
% dropLess(s(o),[s(s(o)),s(o),o,s(s(s(s(o))))],L).

lastElem(X,[X|[]]).
lastElem(X,[_|Zs]):-lastElem(X,Zs).

subset([],_).
subset([X|Xs],Zs):-member2(X,Zs),subset(Xs,Zs).

disjoin([],_).
disjoin([X|Xs],Zs):- not(member2(X,Zs)),disjoin(Xs,Zs).