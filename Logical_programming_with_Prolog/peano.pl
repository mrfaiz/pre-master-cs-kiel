isPeano(o).
isPeano(s(N)):-isPeano(N).

add(o,Xs,Xs).
add(s(N),M,s(Z)) :- add(N,M,Z).

mult(o,_,o).
mult(s(N),M,Res):-mult(N,M,Temp),add(Temp,M,Res).

sub(X,Y,Z) :- add(Y,Z,X).

greater((_),o).
greater(s(N),s(M)):-greater(N,M).

max(o,s(X),s(X)).
max(s(X),o,s(X)).
max(s(M),s(N),s(M)):-max(M,N,M).
max(s(M),s(N),s(N)):-max(M,N,N).


peanoToDec(o,0).
peanoToDec(s(X),R):-peanoToDec(X,Z), R is Z+1.

decToPeano(0,o).
decToPeano(N,s(X)) :- N>0,Z is N-1,decToPeano(Z,X).

intToBin(0,o).
intToBin(1,i).
intToBin(N,R):- N>1,
                K is N div 2,
                intToBin(K,X),
                (0 is N mod 2 -> R = o(X) ; R = i(X)).