/**
 * 1. Horses and Riders
 * 
 * A family walks past a riding stable on their Sunday walk. While the children watch the horses, the father counts diligently and proudly announces: "I  * * counted 8 heads and 20 legs. How many horses and riders are on the farm?"
 * 
 * Solve the puzzle with a Prolog program using the Peano numbers from the lecture. Define a predicate rider that relates the number of heads and legs to  * the number of horses and riders.
*/


riders(Humans,Horses,Heads,Legs):- addPeano(Humans,Horses,Heads),
                                   multPeano(Humans,s(s(o)),HumLegs),
                                   multPeano(Horses,s(s(s(s(o)))),HorLegs),
                                   addPeano(HumLegs,HorLegs,Legs).


edges([(1, 2), (1, 4), (1, 5), (2, 3), (2, 4), (2, 5), (3, 4), (4, 5)]).

flip([], []).
flip([(X, Y)|Xs], [(Y, X)|Ys]) :- flip(Xs, Ys).

nicholas([]).
nicholas([_]).
nicholas([(_, X), (X, Y)|Xs]) :- nicholas([(X, Y)|Xs]).

houseOfNicholas(N) :- edges(Es),
                      permutation(Es, EsP),
                      flip(EsP, N),
                      nicholas(N).