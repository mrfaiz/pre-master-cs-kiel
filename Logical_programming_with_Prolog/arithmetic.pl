sameValue(N3,N2,Value):- N3=:= N2,Value=same,!.
sameValue(_,_,notSame).

notEqual(A,B,Value):- A =\= B , Value=notEqul,!.
notEqual(_,_,equal).

fact(0,1).
fact(N,Fact) :- N>0, Nminus is N-1, fact(Nminus,FactPrev),Fact is FactPrev * N.  