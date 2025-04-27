
permutations_of_length(_, 0, []).
permutations_of_length(List, N, [X|Perms]) :-
    N > 0,
    N1 is N - 1,
    select(X, List, Rest),
    permutations_of_length(Rest, N1, Perms).

select_permutations(List, N, Permutations) :-
    length(List, Len),
    Len >= N,
    permutations_of_length(List, N, Permutations).


assign_quiz(quiz(_,Day,Slot,Np),[day(X,_)|T], AssignedTAs) :-
Day\=X,
assign_quiz(quiz(_,Day,Slot,Np),T, AssignedTAs).

assign_quiz(quiz(_,Day,Slot,Np),[day(Day,TAs)|_], AssignedTAs) :-
nth1(Slot,TAs, Element),
 select_permutations(Element,Np,AssignedTAs).   

 
 
 assign_quizzes([],_,[]).
 assign_quizzes([quiz(Course,Day, Slot, NP)|T],FreeSchedule,[proctors(quiz(Course,Day,Slot,NP),Result)|TF]):-
 assign_quiz(quiz(Course,Day, Slot, NP),FreeSchedule,Result),
 assign_quizzes(T,FreeSchedule,TF).
 
free_schedule(AllTas, TeachingSchedule, FreeSchedule):-
TmpSchedule=[day(sat, [[], [], [], [], []]),
day(sun, [[], [], [], [], []]),
day(mon, [[], [], [], [], []]),
day(tue, [[], [], [], [], []]),
day(wed, [[], [], [], [], []]),
day(thu, [[], [], [], [], []])],
helper_free(AllTas,TeachingSchedule,TmpSchedule,FreeSchedule).
 
 
helper_free([],_,Acc,Acc).
helper_free([H|T],TeachingSchedule,OldSchedule,FreeSchedule):-
helper_free_second(H,TeachingSchedule,OldSchedule,Result),
helper_free(T,TeachingSchedule,Result,FreeSchedule).

 
helper_free_second(_,[],[],[]).

helper_free_second(ta(Name,Dayoff),[day(Day,[S1,S2,S3,S4,S5])|TT],[day(Day,[S1f,S2f,S3f,S4f,S5f])|TOld],[HHC|TF]):-
Day\=Dayoff,
freeslots(Name,[S1,S2,S3,S4,S5],[S1f,S2f,S3f,S4f,S5f],[S1ff,S2ff,S3ff,S4ff,S5ff]),
HHC=day(Day,[S1ff,S2ff,S3ff,S4ff,S5ff]),
helper_free_second(ta(Name,Dayoff),TT,TOld,TF).

helper_free_second(ta(Name,Dayoff),[day(Day,[S1,S2,S3,S4,S5])|TT],[day(Day,[S1f,S2f,S3f,S4f,S5f])|TOld],[day(Day,[S1f,S2f,S3f,S4f,S5f])|TF]):-
Day=Dayoff,
helper_free_second(ta(Name,Dayoff),TT,TOld,TF).


/*
insert_last(Element,List,Result):-
append(List,[Element],Result).
*/
insert_last(X,L,[X|L]).
insert_last(X,[Y|L],[Y|L1]) :- insert_last(X,L,L1).

freeslots(_,[],[],[]).
freeslots(Name,[H|T],[H2|T2],[HSecond|TailSecond]):-
\+ member(Name,H),
insert_last(Name,H2,HSecond),
freeslots(Name,T,T2,TailSecond).

freeslots(Name,[H|T],[H2|T2],[H2|TailSecond]):-
member(Name,H),
freeslots(Name,T,T2,TailSecond).

assign_proctors(_, [], _,[]).
assign_proctors(AllTAs, Quizzes, TeachingSchedule, ProctoringSchedule):-
free_schedule(AllTAs, TeachingSchedule, FreeSchedule),
assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule).










