% Matrix Multiplicated Weights function (Gain version)
% This function is to continue computing based on the result of 
%      big epsilon. To force MW to converge faster, we use a big epsilon
%      and delta, and then run this function to make it converge.

% Input: X:    Result Distribution Matrix  (m by m)
%        rho:  ||A_i||             (m by 1 vector)
%        epsi:  relaxation of large-margin solution (smaller)   (real number)
%        ita: -ln(1-epsilon), (real number)
%        A:    Coefficient 3-d Matrix (m by m by n)
%        L: Laplacian matrix L
%        sum_M: to continue, we need sum_M as part of this algorithm.
%        T1: T = T1 + # of rounds 

% Output: Good solution, # of rounds, total gain, best gain
%         sum_M: record it to use in Matrix_MW_force function.
function [Solu, T, sum_M] = Matrix_MW_force(L, A, X, rho, ita, epsi, T1, sum)

%record # of example n and the matrix size m.
[m, ~, n] = size(A);

%check feasibility
IDX = findexample_maxcut(A, X, epsi);

%continue counting # of rounds
T = T1;
sum_M = sum;
while IDX>0
    %Obeserve gain matrix
    M = 1/rho(IDX) * A(:,:,IDX);
    %sum_M: sum of cost matrix from beginning to current round.
    sum_M = sum_M + M;
   
    
    %update date distribution matrix
    W = expm(ita*sum_M);
    X = 1/trace(W)*W;
    
    %Print the value of cut
    current_cut = 1/4*trace(L*X)
    
  
    %Count # of rounds
    T = T + 1;
    
    %check feasibility
    %continue loop if IDX >0, otherwise stop
    IDX = findexample_maxcut(A, X, epsi);
end

Solu = X;
end

