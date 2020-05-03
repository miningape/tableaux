# tableaux
A project for a Logic and Discrete Mathematics course
(More to be added)

Both "Process/3 or /2" and "Tautology/3 or /2" are essentially
functions that will begin the program "tableau/1" will also begin it
Formula's are passed in as the first argument and is a list [], and
the variables used are passed in as the rest of the arguments(Only
works for 1 or 2 variables
An example program is: tautology([P or neg P], P).   (process([neg (P or neg P)], P). Has the exact same output)
the output: "P: +_INT"
"[_INT, neg _INT]"

The first line of the output shows what value the compiler has
assigned your variable
The second line shows the final tableau.
In the example it has one branch (shown by [])
And it contains [P, neg P] so it is unsatisfiabl
One more example is: process([(P and Q) or (P => Q)], P, Q).
P: +_INT1
Q: +_INT2
[_INT2,_INT1][_INT2][neg _INT1]
This tableau shows 3 branches [Q, P][Q][not P] == {{Q, P}, {Q}, {-P}}
Since no branch contradicts itself all branches are open and
as such each branch is itself a solution... The symbol by itself means
that regardless of the other's value it satisfies the equation
