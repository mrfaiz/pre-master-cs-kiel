isPeano(o).
isPeano(s(N)):-isPeano(N).

addPeano(o,Xs,Xs).
addPeano(s(N),M,s(Z)) :- addPeano(N,M,Z).

multPeano(o,_,o).
multPeano(s(N),M,Res):-multPeano(N,M,Temp),addPeano(Temp,M,Res).

subPeano(X,Y,Z) :- addPeano(Y,Z,X).

greater((_),o).
greater(s(N),s(M)):-greater(N,M).

max(o,s(X),s(X)).
max(s(X),o,s(X)).
max(s(M),s(N),s(M)):-max(M,N,M).
max(s(M),s(N),s(N)):-max(M,N,N).


peanoToDec(o,0).
peanoToDec(s(X),R):-peanoToDec(X,Z), R is Z+1.

intToPeano(0,o).
intToPeano(N,s(X)) :- N>0,Z is N-1,intToPeano(Z,X).

intToBin(0,o).
intToBin(1,i).
intToBin(N,R):- N>1,
                K is N div 2,
                intToBin(K,X),
                (0 is N mod 2 -> R = o(X) ; R = i(X)).

