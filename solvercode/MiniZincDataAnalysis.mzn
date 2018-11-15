
% Given input variables

int: t; %number of attributes
int: k; %max number of elementes in the support set
int: n; %number of positive instances
int: m; %number of negative instances
int: c; %number of atMostOne constraints

set of int: nliterals = 1..t;
set of int: slength = 1..k;
set of int: atmconstraints = 1..c;
set of int: oplength = 1..n;
set of int: onlength = 1..m;

array[oplength, nliterals] of int: omegap;
                                          
array[onlength, nliterals] of int: omegan;

% Support set
array[nliterals, slength] of var bool: S;
                                        
array[slength] of var bool: St;
                                          
array[atmconstraints] of set of int: atMostOne;

%At most k elements in the support set
constraint forall(i in nliterals) (sum(j in slength)(S[i,j]) <= 1);
constraint forall(j in slength) (sum(i in nliterals)(S[i,j]) <= 1);


constraint forall(i in nliterals) (St[i]<-> exists(j in slength)(S[i,j]));

%atMostOneConstrain
constraint forall(r in atmconstraints) (sum(j in atMostOne[r], i in nliterals) (S[i,j]) <= 1);

%S must be a support set for omegap and omegan
constraint forall(r in oplength) (sum(i in onlength, j in slength) (St[j] /\ ((omegap[r,j] = 1 \/ omegan[i,j] = 1) /\ (omegap[r,j] = 0 \/ omegan[i,j] = 0))) >= 1);

solve satisfy;

output [(if fix(St[i])=true then show(i)++" " else "" endif)| i in slength];
