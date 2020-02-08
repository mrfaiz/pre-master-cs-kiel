mem(E,[E|_]).
mem(E,[_|R]) :- mem(E,R).

