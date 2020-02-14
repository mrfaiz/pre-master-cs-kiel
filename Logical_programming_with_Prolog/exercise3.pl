/**
 * 3. Negation as failure
 *    Define the following predicates for lists by using negation as failure.
 *    
 * a. nodup(Xs) checks whether a list contains duplicates.
 * b. neq(X, Y) holds if X and Y are not unifiable.
 * c. remove(X, Xs, Ys) holds if removing all occurrences of X from the list Xs is equal to the list Ys.
 * d. nub(Xs, Ys) holds if Ys is the list Xs without duplicates.
  * 
 */
nodup([_]).
nodup([X|Xs]):- \+ member(X,Xs), nodup(Xs).

neq(X,Y):- \+ X=Y.
 
remove(_,[],[]).
remove(X,[Y|Xs],Ys):- X=Y, remove(X,Xs,Ys).
remove(X,[Y|Xs],[Y|Ys]):- \+ X=Y, remove(X,Xs,Ys).

nub([],[]).
nub([X|Xs],[X|Ys]) :- \+ member(X,Xs), nub(Xs,Ys).
nub([X|Xs],Ys)     :- member(X,Xs),nub(Xs,Ys). 