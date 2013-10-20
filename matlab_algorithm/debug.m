% function [x] = debug(A, b, opts)
%     % ALL RIGHTS RESERVED BY AUTHOR
%     % Author  : Akshay Soni (UMN)
%     % Contact : sonix022@umn.edu
%     % Implementation -- FISTA for solving l1 minimization problem
%     %
%     % A        --- measurement matrix (m x n)
%     % b        --- observations (m x 1) (randperm)
%     % opts.k   --- number of iterations
%     % opts.L   --- Lipschitz constant (generally 2*eigs(A'*A, 1))
%     % opts.lam --- thresholding parameter
%     %
%     % REFERENCE
%     % @article{Beck:2009:FIS:1658360.1658364,
%     %     author = {Beck, Amir and Teboulle, Marc},
%     %     title = {A Fast Iterative Shrinkage-Thresholding Algorithm for Linear Inverse Problems},
%     %     journal = {SIAM J. Img. Sci.},
%     %     issue_date = {January 2009},
%     %     volume = {2},
%     %     number = {1},
%     %     month = mar,
%     %     year = {2009}
%     % } 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
%     k     = opts.k;     % # of iterations
%     L     = opts.L;     % Lipschitz constant of Grad(f)
%     lam   = opts.lam;   % controls the sparsity
%     Level = opts.level; % # of levels to discard
%     M     = opts.M;     % M^2 == number of columns in new matrix of Haar
%     N     = opts.N;     % N^2 == image dimension
%     n     = N^2;
%     % [~, n] = size(A);
% 
%     x = zeros(M^2,1);     % output initialization
%     y = x;                % initialization for FISTA
%     t = 1;                % step size
% 
%     % I IS THE N x N IDENTITY MATRIX 
%     % b IS THE OBSERVATION VECTOR
% 
%     % Precalulating H'*I'*b 
% 
%     % calculate this once (meaning, in the app, pass it in each time)
%     Phi_b = zeros(n,1);
%     Phi_b(A) = b;           % calculate I'*b
%     % do H'*I'*b and vectorize the result
%     Phi_b_W = mdwt(reshape(Phi_b, [N N]), daubcqf(2, 'min'));
%     b_t = vec(Phi_b_W(1:M, 1:M));
%     
%     % FISTA Iterations
%     for i = 1:k
%         x_nk = pL(y, A, b_t, lam, L, N, Level);
% 
%         x_k  = x;
%         t_k = t;
%         
%         % calculate step sizes
%         t_nk = 0.5*(1 + sqrt((1 + 4*t_k^2)));
%         y = x_nk + ((t_k -1)/(t_nk))*(x_nk - x_k);
% 
%         x = x_nk;
%         t = t_nk;
%     end
% 
% end

function [xk] = debug(y, A, b_t, N)
    % Here we are trying to get H'*I'*I*H*y
    lam = 0.05;
    Level = 0;
    L = 2;
    
    % Here we are trying to get H'*I'*I*H*y
    n  = N^2;
    n1 = n/2^(2*Level);
    N1 = sqrt(n1);

    Y  = reshape(y, [N1, N1]);
    Yt = zeros(N, N);
    Yt(1:N1, 1:N1) = Y;
    
    h = midwt(Yt, daubcqf(2));
    y1 = vec(h);


    Phi_y    = zeros(n,1);
    Phi_y(A) = y1(A);
    h = reshape(Phi_y, [N N]);
    Phi_y_W  = mdwt(h, daubcqf(2, 'min'));
    y_t = vec(Phi_y_W(1:N/2^Level, 1:N/2^Level));


    % calculating the gradiend step
    temp_x = y - 2/L*(y_t - b_t);

    % thresholding
    temp_1 = (abs(temp_x) - lam/L);
    temp_1(temp_1 < 0) = 0;

    xk = temp_1 .* sign(temp_x);
end