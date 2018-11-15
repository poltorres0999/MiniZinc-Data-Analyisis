
% Given input variables

int: t = 8; %number of attributes
int: k = 3; %max number of elementes in the support set
int: n=2; %number of positive instances
int: m=2; %number of negative instances
int: c=2; %number of atMostOne constraints

set of int: nliterals = 1..t;
set of int: slength = 1..k;
set of int: atmconstraints = 1..c;
set of int: oplength = 1..n;
set of int: onlength = 1..m;

array[oplength, nliterals] of int: omegap = [| 1, 0, 1, 1, 1, 1, 1, 1|
                                               1, 1, 0, 0, 0, 0, 0, 1|];
                                          
array[onlength, nliterals] of int: omegan = [| 1, 1, 0, 0, 1, 0, 1, 1|
                                               1, 0, 0, 1, 0, 0, 1, 1|];

% Support set
array[nliterals, slength] of var bool: S;
                                        
array[nliterals] of var bool: St;
                                          
array[atmconstraints] of set of int: atMostOne = [{1,2}, {1,3}];

%At most k elements in the support set
constraint forall(i in nliterals) (sum(j in slength)(S[i,j]) <= 1);
constraint forall(j in slength) (sum(i in nliterals)(S[i,j]) <= 1);

constraint forall(i in nliterals) (St[i]<-> exists(j in slength)(S[i,j]));

%S must be a support set for omegap and omegan
constraint forall(r in oplength) (sum(i in onlength, j in nliterals) (St[j] /\ ((omegap[r,j] = 1 \/ omegan[i,j] = 1) /\ (omegap[r,j] = 0 \/ omegan[i,j] = 0))) >= 3);

%atMostOneConstrain
constraint forall(r in atmconstraints) (sum(j in atMostOne[r], i in slength) (S[j,i]) <= 1);

solve satisfy;

output [(if fix(St[i])=true then show(i)++" " else "" endif)| i in slength];
