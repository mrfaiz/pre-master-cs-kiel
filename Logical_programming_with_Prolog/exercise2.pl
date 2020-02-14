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

/**
 * Boolean Operations
The generate-and-test technique can be used to find solutions for a search problem. Use this technique to find a solution for the house of Nicholas (in German, but can perhaps be translated by Google translater).

The house of Nicholas is a drawing game and puzzle for children. The goal is to draw a "house" in a line of exactly eight routes without having to go through a course twice. Accompanying the drawing is the simultaneous spoken rhyme of eight syllables: "This is the house of Ni-cho-las."

Represent the five corners of the house by the numbers 1 to 5. An edge can then be represented as a tuple of two numbers (corners). Now define a predicate edges/1 that checks whether the given list contains all the eight possible edges of the house.
Next, define a predicate flip/2 that flips the tuples in a given list of edges non-deterministically.
Finally, define a predicate nicholas/1 that checks whether the given sequence of edges represents a valid solution with no interruptions.
After that, you can use the following predicate to find solutions for the house of Nicholas.
houseOfNicholas(N) :- edges(Es),
                      permutation(Es, EsP),
                      flip(EsP, N),
                      nicholas(N).
 */

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