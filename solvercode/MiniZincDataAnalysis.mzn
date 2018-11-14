
% Given input variables

int: t = 5; %number of attributes
int: k = 4; %max number of elementes in the support set
%int: n; %number of positive instances
%int: m; %number of negative instances
int: c = 2; %number of atMostOne constraints

set of int: nliterals = 1..t;
set of int: slength = 1..k;
set of int: atmconstraints = 1..c;

%array[1..t, 1..n] of bool: omegap;
%array[1..t, 1..n] of bool: omegan;

% Support set
array[nliterals, slength] of bool: S = [| true, false, false, false | false, false, false, false, | false, false, true, false, | false, false, false, false, | false, false, false, true |];
array[atmconstraints] of set of int: atMostOne = [{1,2}, {1,3}];

%At most k elements in the support set
constraint forall(i in nliterals) (sum(j in slength)(S[i,j]) <= 1);
constraint forall(j in slength) (sum(i in nliterals)(S[i,j]) <= 1);

%atMostOneConstrain
constraint forall(r in atmconstraints) (sum(j in atMostOne[r], i in nliterals) (S[i,j]) <= 1);



solve satisfy;