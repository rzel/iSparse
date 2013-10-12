function [x] = FISTA_W(A, b, opts)
    % ALL RIGHTS RESERVED BY AUTHOR
    % Author  : Akshay Soni (UMN)
    % Contact : sonix022@umn.edu
    % Implementation -- FISTA for solving l1 minimization problem
    %
    % A        --- measurement matrix (m x n)
    % b        --- observations (m x 1) (randperm)
    % opts.k   --- number of iterations
    % opts.L   --- Lipschitz constant (generally 2*eigs(A'*A, 1))
    % opts.lam --- thresholding parameter
    %
    % REFERENCE
    % @article{Beck:2009:FIS:1658360.1658364,
    %     author = {Beck, Amir and Teboulle, Marc},
    %     title = {A Fast Iterative Shrinkage-Thresholding Algorithm for Linear Inverse Problems},
    %     journal = {SIAM J. Img. Sci.},
    %     issue_date = {January 2009},
    %     volume = {2},
    %     number = {1},
    %     month = mar,
    %     year = {2009}
    % } 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    k     = opts.k;     % # of iterations
    L     = opts.L;     % Lipschitz constant of Grad(f)
    lam   = opts.lam;   % controls the sparsity
    Level = opts.level; % # of levels to discard
    M     = opts.M;     % M^2 == number of columns in new matrix of Haar
    N     = opts.N;     % N^2 == image dimension
    n     = N^2;
    % [~, n] = size(A);

    x = zeros(M^2,1);     % output initialization
    y = x;                % initialization for FISTA
    t = 1;                % step size

    % I IS THE N x N IDENTITY MATRIX 
    % b IS THE OBSERVATION VECTOR

    % Precalulating H'*I'*b 

    % calculate this once (meaning, in the app, pass it in each time)
    Phi_b = zeros(n,1);
    Phi_b(A) = b;           % calculate I'*b
    % do H'*I'*b and vectorize the result
    Phi_b_W = mdwt(reshape(Phi_b, [sqrt(n) sqrt(n)]), daubcqf(2, 'min'));
    b_t = vec(Phi_b_W(1:sqrt(n)/2^Level, 1:sqrt(n)/2^Level));

    % FISTA Iterations
    for i = 1:k

        % function call to calculate pL
        x_nk = pL(y, A, b_t, lam, L, N, Level);

        x_k  = x;
        t_k = t;
        
        % calculate step sizes
        t_nk = 0.5*(1 + sqrt((1 + 4*t_k^2)));
        y = x_nk + ((t_k -1)/(t_nk))*(x_nk - x_k);

        x = x_nk;
        t = t_nk;
    end

end

function [xk] = pL(y, A, b_t, lam, L, N, Level)
    % Here we are trying to get H'*I'*I*H*y
    n  = N^2;
    n1 = n/2^(2*Level);
    Y  = reshape(y, [sqrt(n1), sqrt(n1)]);
    Yt = zeros(sqrt(n), sqrt(n));
    Yt(1:sqrt(n1), 1:sqrt(n1)) = Y;
    y1 = vec(midwt(Yt, daubcqf(2, 'min')));


    Phi_y    = zeros(n,1);
    Phi_y(A) = y1(A);
    Phi_y_W  = mdwt(reshape(Phi_y, [sqrt(n) sqrt(n)]), daubcqf(2, 'min'));
    y_t = vec(Phi_y_W(1:sqrt(n)/2^Level, 1:sqrt(n)/2^Level));


    % calculating the gradiend step
    temp_x = y - 2/L*(y_t - b_t);

    % thresholding
    temp_1 = (abs(temp_x) - lam/L);
    temp_1(temp_1 < 0) = 0;

    xk = temp_1 .* sign(temp_x);

end
