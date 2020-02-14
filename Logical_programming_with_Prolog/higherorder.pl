%findall
%call
%bagof

likes(mary, pizza).
likes(marco, pizza).
likes(karim, noodles).
likes(halim, noodles).
likes(jakir, rice).
likes(faiz, rice).
likes(Human, pizza) :- italian(Human).
italian(marco).

/**
 * ?- findall(Person,likes(Person,rice),Result).
 * Result = [jakir, faiz].
 * ?- findall((Person,Dish),likes(Person,Dish),Result).
 * Result = [(mary, pizza),  (marco, pizza),  (karim, noodles),  (halim, noodles),  (jakir, rice),  (faiz, rice),  (marco, pizza)].
 * 
 * ?-bagof(Person,(likes(Person,rice)),Result).
 * Result = [jakir, faiz].
 * 
 * ?- bagof(Person,(likes(Person,Dish)),Result).
 * Dish = noodles,
 * Result = [karim, halim] ;
 * Dish = pizza,
 * Result = [mary, marco, marco] ;
 * Dish = rice,
 * Result = [jakir, faiz].
 * 
 * 
 * ?- call(likes,Person,pizza).
 * Person = mary ;
 * Person = marco ;
 * Person = marco.
*/

findAllFactsOfLikes(Person,Menu,Output) :- findall((Person,Menu), likes(Person,Menu),Output).
/*
?- findAllFactsOfLikes(Person,Menu,Output).
Output = [(mary, pizza),  (marco, pizza),  (karim, noodles),  (halim, noodles),  (jakir, rice),  (faiz, rice),  (marco, pizza)].
*/

bagAllLikeFacts(Person,Menu,Output):- bagof(Person,likes(Person,Menu),Output).

/**
 * ?- bagAllLikeFacts(Person,Menu,Output).
 * Menu = noodles,
 * Output = [karim, halim] ;
 * Menu = pizza,
 * Output = [mary, marco, marco] ;
 * Menu = rice,
 * Output = [jakir, faiz].
 */

% result :- call(likes,Person,pizza).

/**
 * ?- result.
 * true ;
 * true ;
 * true.
*/

