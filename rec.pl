%
% ! This version of the program uses propositional definitions to
% translate "unknown" symbols into easier to manipulate forms... While
% this implementation is simpler the output is larger (as it shows many
% more branches)
%
comment(above).

:- op(200, fy, neg).
:- op(210, yfx, and).
:- op(220, yfx, or).
:- op(230, xfy, =>).
:- op(230, xfy, <=>).
% Above are operator definitions to support the queries
% neg X is equivalent to not X
% A and B is A ^ B
% A or B is A v B
% A => B is A if B
% A <=> B is A iff B

% Binding functions for queries with 2 variables or 1
% Just outputs the variable's name and its _value
process(Formula, P, Q) :-
    write("P: " + P),nl,
    write("Q: " + Q),nl,
    tableau(Formula), !.

process(Formula, P) :-
    write("P: " + P),nl,
    tableau(Formula), !.

% Binding function for looking at investigating a tautology
% all it does is negate the formula entered and call the process
tautology([Formula|_], P, Q) :-
    process([neg(Formula)], P, Q), !.

tautology([Formula|_], P) :-
    process([neg(Formula)], P), !.


% Query that starts breaking down the tableau (+Formula)
tableau(Formula) :-
    tableau_([], Formula),
    !.

% tableau_ acts on the stack(of formulas) and either breaks it down
% a function with tableau_b or adds a literal to the branch...

% There is nothing left in our stack of functions to add to the branch
% So we just expose the final branch so we can read it
tableau_(Branch, []) :-
    write(Branch), !.

% The front of our stack is a literal so they are added to the branch
tableau_(Branch, [A|Tail]) :-
    var(A),
    tableau_([A|Branch], Tail),
    !.

tableau_(Branch, [neg A|Tail]) :-
    var(A),
    tableau_([neg A|Branch], Tail),
    !.

% Otherwise the front of our stack is operable
% So we do the operation at the top of the stack
tableau_(Branch, [A|Tail]) :-
    tableau_b(Branch, [A|Tail]),
    !.

%
% tableau_b applies the operation on the top of the stack, either by
% splitting the branch or stack or both and then calling tableau_ to
% operate on the new stack & branch
%
% Splitting is done because multiple combinations of literals will
% satisfy the root equation
%

% If the operation has a double negative, make remove both negatives
% and try again
tableau_b(Branch, [neg neg A|Tail]) :-
    tableau_(Branch, [A|Tail]),
    !.

% If the operation is _ and _ we add both to our stack indipendantly
% This is because both values go in the same branch
tableau_b(Branch, [A and B|Tail])  :-
    tableau_(Branch, [A, B|Tail]),
    !.

% If the operation is neg (_ and _) we split the branch where it is
% and add the negated componets to the stack
% This is because either neg A or neg B will satisfy the formula so both
% branches will satisfy
tableau_b(Branch, [neg (A and B)|Tail])  :-
    tableau_(Branch, [neg A|Tail]),
    tableau_(Branch, [neg B|Tail]),
    !.


% TRANSLATED Symbols matched below

tableau_b(Branch, [A or B|Tail])  :-
    tableau_b(Branch, [neg(neg (A) and neg B)|Tail]),
    !.


tableau_b(Branch, [neg (A or B)|Tail])  :-
    tableau_b(Branch, [neg A and neg B|Tail]),
    !.

tableau_b(Branch, [A => B|Tail])  :-
    tableau_b(Branch, [B or neg A|Tail]),
    !.

tableau_b(Branch, [neg (A => B)|Tail])  :-
    tableau_b(Branch, [neg (B or neg A)|Tail]),
    !.

tableau_b(Branch, [A <=> B|Tail])  :-
    tableau_b(Branch, [(A => B) and (B => A)|Tail]),
    !.

tableau_b(Branch, [neg(A <=> B)|Tail])  :-
    tableau_b(Branch, [neg((A => B) and (B => A))|Tail]),
    !.











