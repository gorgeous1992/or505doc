%%%This is the main file of code for the project of class MA591
%%%Matrix Multiplicated Weights Algorithm for MAX CUT Problem

clc
clear all

% %% Generate one toy example with m = 4
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L = cell2mat(struct2cell(load('L_toyExample.mat')));
%  trace(L*[1 -1 1 -1; -1 1 -1 1; 1 -1 1 -1; -1 1 -1 1])
% 
% optvalue = 16;
% [~,m] = size(L);
% n = m+1;
% A = MAXCUT_A(m, optvalue, L)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generate one big example with file L_pw05_100_0.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = cell2mat(struct2cell(load('L_pw05_100_0.mat')));

optvalue = 8190;
[~,m] = size(L);
n = m+1;
A = MAXCUT_A(m, optvalue, L);
% %Rescale the last inequality
% A(:,:,m+1) = (m+1)/trace(A(:,:,m+1))*A(:,:,m+1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set parameters:
rho = 1*para_rho(A);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% ita (version 1)
%epsilon = 0.1;
%ita = epsilon/(2*rho);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ita (version 2)
epsilon = [1e-1, 1e-02, 1e-03, 1e-04];
ita = [-log(1-epsilon(1)),  -log(1-epsilon(2)),-log(1-epsilon(3)),  -log(1-epsilon(4))];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%epsi is the epsilon that for solving large-margin problem
epsi = [1e-1, 1e-02, 1e-03, 1e-04];


%Initialize density matrix
X = 1/m*eye(m);

%Run Matrix MW algorithm for epsi(1) to converges fast
[Solu, T1, ~] = Matrix_MW(L, A, X, rho, 6*ita(4), epsi(3));
% %Run again Matrix MW algorithm with solu from last run for epsi(2) to converges precisely
% for j = 1:9
%     [temp_Solu, T1, sum_M] = Matrix_MW_force(L, A, temp_Solu, rho, (10-j)*...
%         ita(2), (10-j)*epsi(2), T1, sum_M);
% end
% [Solu, T, ~] = Matrix_MW_force(L, A, temp_Solu, rho, ita(3), epsi(3), T1, sum_M);
% 
% 

%% verify feasibility of Solution
 feas = zeros(n,1);
for i = 1:n
    feas(i) = trace(A(:,:,i)*Solu);
end
fprintf('Feasible?\n')
if feas >= -epsi
    fprintf('--Yes--\n feasibility vector \n')
    feas
else 
    fprintf('No\n')
    feas
    pause;  
end



%% Print the solution
fprintf('\nSolution:\n')
Solu = m*Solu
Solu_value = 0.25*trace(L*Solu)

%% Compare # of rounds with theoretical upper bound of rounds
fprintf('\nTotal number of rounds:\n')
total_rounds = T1;
fprintf('\nTotal: %d\n', total_rounds);

%% Compare the generated answer and best cut
fprintf('\n err_b = %f\n', norm(Solu_value - optvalue));


