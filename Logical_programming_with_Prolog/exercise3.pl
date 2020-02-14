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

/**
 4.More SLD-Resolution


Consider the following predicate for deleting an element from a list.
delete(_, [],     []).
delete(X, [Y|Xs], Xs)     :- X = Y.
delete(X, [Y|Xs], [Y|Ys]) :- delete(X, Xs, Ys).
Prove the query
?- delete(1, [1, 0+1], Xs).
by means of Prolog's evaluation strategy and specify all intermediate results and solutions.
You can either display your solution as an SLD tree and specify the search order used by Prolog or note the search sequentially (as in the lecture).


Modify the above program so that

only the first occurrence of the first parameter is removed from the list.
all occurrences of the first parameter are removed from the list.
*/

deleteFirst(_,[],[]).
deleteFirst(N,[N|Xs],Xs):- !.
deleteFirst(N,[X|Xs],[X|Ys]) :-  deleteFirst(N,Xs,Ys).

deleteAll(_,[],[]).
deleteAll(N,[N|Xs],Zs):- deleteAll(N,Xs,Zs).
deleteAll(N,[X|Xs],[X|Ys]):- \+ N=X,deleteAll(N,Xs,Ys).



