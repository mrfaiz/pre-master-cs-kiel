candidate(potter).
candidate(weasley).
candidate(malfoy).
candidate(granger).

board(Chairperson,Treasurer,Secretary):- candidate(Chairperson),
                                         candidate(Treasurer),
                                         candidate(Secretary).

onBoard(P, board(P,_,_)).
onBoard(P, board(_,P,_)).
onBoard(P, board(_,_,P)).

notInBoard(Person,board(Chairperson,Treasurer,Secretary)) :- Person \= Chairperson, Person \= Treasurer , Person \=Secretary.

potterMalfoy(board(C,T,S)) :- onBoard(potter,board(C,T,S)),notInBoard(malfoy,board(C,T,S)).
potterMalfoy(board(C,T,S)) :- notInBoard(potter,board(C,T,S)),onBoard(malfoy,board(C,T,S)).


