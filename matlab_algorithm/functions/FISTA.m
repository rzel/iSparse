function [x] = FISTA(A, b, opts)
% ALL RIGHTS RESERVED BY AUTHOR
%
%
%
%
% Author: Akshay Soni (UMN)
% Contact: sonix022@umn.edu
% Implementation -- FISTA for solving l1 minimization problem
%
% A: measurement matrix (m x n)
% b: observations (m x 1)
% opts.k --- number of iterations 
% opts.L --- Lipschitz constant (generally 2*eigs(A'*A, 1))
% opts.lam --- thresholding parameter 
%
% REFERENCE
% @article{Beck:2009:FIS:1658360.1658364,
% author = {Beck, Amir and Teboulle, Marc},
% title = {A Fast Iterative Shrinkage-Thresholding Algorithm for Linear Inverse Problems},
% journal = {SIAM J. Img. Sci.},
% issue_date = {January 2009},
% volume = {2},
% number = {1},
% month = mar,
% year = {2009}
% } 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


k = opts.k;         % # of iterations
L = opts.L;         % Lipschitz constant of Grad(f)
lam = opts.lam;      % controls the sparsity

[~, n] = size(A);

x = zeros(n,1);     % output initialization
y = x;
t = 1;              % step size

Ai = A'*A;          % precalculate the Gram matrix
% FISTA Iterations
    for i = 1:k

        % function call to calculate pL
        x_nk = pL(y, Ai, A, b, lam, L);

        x_k  = x;
        t_k = t;
        
        % calculate step sizes
        t_nk = 0.5*(1 + sqrt((1 + 4*t_k^2)));
        y = x_nk + ((t_k -1)/(t_nk))*(x_nk - x_k);

        x = x_nk;
        t = t_nk;
    end

end

function [xk] = pL(y, Ai, A, b, lam, L)

% calculating the gradiend step
temp_x = y - 2/L*(Ai*y - A'*b);

% thresholding
temp_1 = (abs(temp_x) - lam/L);
temp_1(temp_1 < 0) = 0;

xk = temp_1.*sign(temp_x);

end