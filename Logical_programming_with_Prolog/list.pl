date(date(_,_,_)).

year(date(_,_,Y),Y).
month(date(_,M,_),M).
day(date(D,_,_),D).

tree(leaf(_)).
tree(branch(LT,RT)) :- tree(LT),tree(RT).

list([]).
list([_|Xs]) :- list(Xs).

member3(E,[E|_]).
member3(E,[_|Xs]) :- member3(E,Xs).

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
subset([X|Xs],Zs):-member3(X,Zs),subset(Xs,Zs).

disjoin([],_).
disjoin([X|Xs],Zs):- not(member3(X,Zs)),disjoin(Xs,Zs).

delete(L1,E,Res) :- app(Xs,[E|Ys],L1),app(Xs,Ys,Res). 

deleteTwo(L1,E1,E2,Res):-delete(L1,E1,Temp),delete(Temp,E2,Res).

p(X):-q(X),q(a),!.
p(X):-q(X),!,q(c).  % Y=b is not true.. Only Y=c is ok.
p(b).

q(b) :- q(a).
q(c).

%%findall(X, member(X, [21, 42, 73]), L).
% findall(X,perm([1,2,3],X),L).


deleteFirst(_,[],[]).
deleteFirst(N,[X|Xs],Xs) :- N=X,!.
deleteFirst(N,[X|Xs],[X|Ys]):- \+ N=X,deleteFirst(N,Xs,Ys).


rev([],[]).
rev([X|Xs],Res):- rev(Xs,Temp),app(Temp,[X],Res).

rev2([],[]).
rev2([X|Xs],Res):- app(Temp,[X],Res), rev2(Xs,Temp),!.

append_dl(M-N,N-O,M-O).

rev_dl([],Ys,Ys).
rev_dl([X|Xs],Zs,R) :- rev_dl(Xs,Zs,[X|R]).

revL(List,Result):-rev_dl(List,Result,[]).

findMin([X],X).
findMin([X,Y|Xs],R):- X=<Y,findMin([X|Xs],R).
findMin([X,Y|Xs],R):- X>Y,findMin([Y|Xs],R).