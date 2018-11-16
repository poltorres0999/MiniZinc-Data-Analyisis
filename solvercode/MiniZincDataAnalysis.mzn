
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


array[nliterals, slength] of var bool: S;
                                        
array[nliterals] of var bool: St;
                                          
array[atmconstraints] of set of int: atMostOne;

%At most k elements in the support set
constraint forall(i in nliterals) (sum(j in slength)(S[i,j]) <= 1);
constraint forall(j in slength) (sum(i in nliterals)(S[i,j]) <= 1);

constraint forall(i in nliterals) (St[i]<-> exists(j in slength)(S[i,j]));

%S must be a support set for omegap and omegan
constraint forall(i in oplength, j in onlength)(exists(k in nliterals)(not((omegap[i,k] = 1 /\ omegan[j,k]=1) \/ (omegan[j,k] = 0 /\ omegap[i,k]=0)) /\ St[k]));

%atMostOneConstrain
constraint forall(r in atmconstraints) (sum(j in atMostOne[r]) (St[j]) <= 1);

solve satisfy;

output [(if fix(St[i])=true then show(i)++" " else "" endif)| i in nliterals];


