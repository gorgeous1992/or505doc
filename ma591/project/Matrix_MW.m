% Matrix Multiplicated Weights function
% for sovling specific SDP.

% Input: X:    Initial Distribution Matrix  (m by m)
%        rho:  max_i ||A_i||             (real number)
%        epsilon:  relaxation of large-margin solution   (real number)
%        ita: epsilon/(2*rho), parameter for updating weights (real number)
%        A:    Coefficient 3-d Matrix (m by m by n)

% Output: Good solution, # of rounds, total gain, best gain
function [Solu, T, cost, bestcost, upbd_cost] = Matrix_MW(A, X, rho, epsilon, ita)

%record # of example n and the matrix size m.
[m, ~, n] = size(A);

%check feasibility
IDX = findexample_matrix(A, X);

%Initialize sum. 
%sum_M: sum of gain matrix from beginning to current round.
sum_M = zeros(m);

T=0;
cost = 0;
fac2_upbd_cost = 0;
while IDX>0
    %Obeserve gain matrix
    M = -1/rho * A(:,:,IDX);
    sum_M = sum_M + M;
    
    %cost so far
    cost = cost + trace(M*X);
    %second term in Upper bound of cost:
    fac2_upbd_cost = fac2_upbd_cost + trace(M*M*X);
    %update date distribution matrix
    W = expm(-ita*sum_M);
    X = 1/trace(W)*W;
  
    %Count # of rounds
    T = T + 1;
    
    %check feasibility
    %continue loop if IDX >0, otherwise stop
    IDX = findexample_matrix(A, X);
end

bestcost = min(eig(sum_M));
upbd_cost = min(eig(sum_M)) + ita*fac2_upbd_cost + log(n)/ita;

Solu = X;
end






