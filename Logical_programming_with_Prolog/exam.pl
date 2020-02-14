gt(s(_),o).
gt(s(M),s(N)):-gt(M,N).

fromTo(_,o,[]).
fromTo(N,N,[N]).
fromTo(M,N,[M|Xs]) :- gt(N,M),fromTo(s(M),N,Xs).
fromTo(M,N,[])     :- gt(M,N).

dropLess(_,[],[]).
dropLess(N,[N|Xs],[N|Xs]).
dropLess(N,[X|_],[X|_])    :- gt(X,N).
dropLess(N,[X|Xs],Zs)      :- gt(N,X),dropLess(N,Xs,Zs).

deleteFirstOne(_,[],[]).
deleteFirstOne(X,[X|Xs],Xs).
deleteFirstOne(X,[Y|Xs],[Y|Ys]):-deleteFirstOne(X,Xs,Ys).

revCut([],[]).
revCut([X|Xs],Zs) :- append(List,[X],Zs), revCut(Xs,List),!.

rev([],[]).
rev([X|Xs],Zs) :- rev(Xs,List), append(List,[X],Zs).

max(P1,P2,Max) :- P1 >=  P2 ,!,Max is P1.
max(_,P2,Max) :- Max is P2.

max2(o,s(X),s(X)).
max2(s(X),o,s(X)).
max2(s(M),s(N),s(M)) :- max2(M,N,M).
max2(s(M),s(N),s(N)) :- max2(M,N,N).

maxPeano(s(M),s(N),Max) :- gt(M,N), ! , Max = s(M),
maxPeano(_,s(N),s(N)).

yes :- ab(X),!,X=b.
yes.
yes(k).

ab(a).
ab(b).

p :- \+ p.



take(o,_,[]).
take(s(N),[X|Xs],[X|Ys]) :- take(N,Xs,Ys).