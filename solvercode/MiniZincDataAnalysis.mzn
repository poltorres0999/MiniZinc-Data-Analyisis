
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

%Sets of vectors for omege positive and omega negative
array[oplength, nliterals] of int: omegap;                              
array[onlength, nliterals] of int: omegan;

%Support set representation
%X -> number of possible attributes
%Y -> selected attributes
array[nliterals, slength] of var bool: S;

%Support set                         
array[nliterals] of var bool: St;

%Set of AtMostOne constraints          
array[atmconstraints] of set of int: atMostOne;

%The support set must have at most 'k' attributes
constraint forall(i in nliterals) (sum(j in slength)(S[i,j]) <= 1);
constraint forall(j in slength) (sum(i in nliterals)(S[i,j]) <= 1);
constraint forall(i in nliterals) (St[i]<-> exists(j in slength)(S[i,j]));

%S must be a support set for omega postive and omega negative
%For all elements in the support set "St[k} = true", all the projected vectors of omega positive and omega negative must be disjoint 
constraint forall(i in oplength, j in onlength)(exists(k in nliterals)(not((omegap[i,k] = 1 /\ omegan[j,k]=1) \/ (omegan[j,k] = 0 /\ omegap[i,k]=0)) /\ St[k]));

%The support set must satisfie the AtMostOne(A) for all Ai
constraint forall(r in atmconstraints) (sum(j in atMostOne[r]) (St[j]) <= 1);

solve satisfy;

output [(if fix(St[i])=true then show(i)++" " else "" endif)| i in nliterals];


