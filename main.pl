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

% Both "Process/3 or /2" and "Tautology/3 or /2" are essentially
% functions that will begin the program "tableau/1" will also begin it
% Formula's are passed in as the first argument and is a list [], and
% the variables used are passed in as the rest of the arguments(Only
% works for 1 or 2 variables)
%
% An example program is: tautology([P or neg P], P).
% the output: "P: +_INT"
%             "[_INT, neg _INT]"
%
% process([neg (P or neg P)], P). Has the exact same output
% The first line of the output shows what value the compiler has
% assigned your variable
% The second line shows the final tableau.
% In the example it has one branch (shown by [])
% And it contains [P, neg P] so it is unsatisfiable
%
% One more example is: process([(P and Q) or (P => Q)], P, Q).
% P: +_INT1
% Q: +_INT2
% [_INT2,_INT1][_INT2][neg _INT1]
% This tableau shows 3 branches [Q, P][Q][not P] == {{Q, P}, {Q}, {-P}}
% Since no branch contradicts itself all branches are open and
% as such each branch is itself a solution... The symbol by itself means
% that regardless of the other's value it satisfies the equation


% Heres where the real code begins...

% Holder function/query that starts breaking down the tableau (+Formula)
tableau(Formula) :-
    tableau_([], Formula),
    !.

% tableau_ acts on the stack(of formulas) and either breaks down
% an operator with tableau_b or adds a literal to the branch...

% If there is nothing left in our stack of functions to add to the
% branch So we just expose the final branch so we can read it
tableau_(Branch, []) :-
    write(Branch), !.

% If the front of our stack is a literal so they are added to the branch
tableau_(Branch, [A|Tail]) :-
    var(A),
    tableau_([A|Branch], Tail),
    !.

% This also applies here as not(literal) is itself a literal
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

% If the operation has a double negative, remove both negatives
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


% If the operation is _ or _ we split our branch into two copies of itself
% and operate on either component seperately by adding it to the stack
%
% This is so the branch splits so either A or B makes it true, it also
% splits the stack so that A and B will be operated on indipendantly

tableau_b(Branch, [A or B|Tail])  :-
    tableau_(Branch, [A|Tail]),
    tableau_(Branch, [B|Tail]),
    !.

% If the operation is neg (_ or _) we add the negated components to the
% stack... as both neg A and neg B need to be in the branch together
tableau_b(Branch, [neg (A or B)|Tail])  :-
    tableau_(Branch, [neg A, neg B|Tail]),
    !.

% If the operation is _ => _ we split the branch and apply B and neg A
% as both will satisfy the root formula (A => B == B or neg A)
tableau_b(Branch, [A => B|Tail])  :-
    tableau_(Branch, [B|Tail]),
    tableau_(Branch, [neg A|Tail]),
    !.

% If the operation is neg (_ => _) we apply neg B and A to the same
% branch as this is the only combination that will satisfy the formula
tableau_b(Branch, [neg (A => B)|Tail])  :-
    tableau_(Branch, [neg B, A|Tail]),
    !.

% Split the branch and apply A, B to one and neg A, neg B to another
% this is because both combinations will make the root true
tableau_b(Branch, [A <=> B|Tail])  :-
    tableau_(Branch, [A, B|Tail]),
    tableau_(Branch, [neg A, neg B|Tail]),
    !.

% Similar to above
tableau_b(Branch, [neg(A <=> B)|Tail])  :-
    tableau_(Branch, [A, neg B|Tail]),
    tableau_(Branch, [neg A, B|Tail]),
    !.













