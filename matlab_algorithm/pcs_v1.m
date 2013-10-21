close all;
clear;

addpath('/Users/DON/Dropbox/my work/Projects/ICASSP - 2014 PCS/rwt');
addpath('/Users/DON/Dropbox/my work/Projects/ICASSP - 2014 PCS/functions');
addpath('/Users/DON/Dropbox/my work/Projects/ICASSP - 2014 PCS/data');

% addpath('/Users/admin/Dropbox/my work/Projects/ICASSP - 2014 PCS/rwt');
% addpath('/Users/admin/Dropbox/my work/Projects/ICASSP - 2014 PCS/functions');
% addpath('/Users/admin/Dropbox/my work/Projects/ICASSP - 2014 PCS/data');
load('smooth.mat');
% load('smooth2.mat');
% load('lena.mat');


%% Parameters and Data

N = 2^4;        % input image dimension N x N
J = log2(N);
X = imresize(image, [N, N]);
% X = imresize(peppers256, [N, N]);
% imagesc(X); colormap gray;
x = mat2gray(X(:));

L = 1;      % L = 0,1,2,..., J - 1
Jn = J - L; 
M = 2^((J - L));
if(Jn > J)
    display('Jn should be less than J');
end

%% Construct restricted inverse 2D Haar matrix
H = compute_haar_matrix(N, L);
Hfull = H;
H = Hfull(:, 1:M^2);

%% Get random signals
m = floor(0.65*N^2);            % # of measurements

I = sparse(eye(N^2));
samples = randperm(N^2);

Phi = I(samples(1:m), :);
% get measurements
sig = 0;
y = Phi*x + sig*randn(m,1);



%% Use SPAMS to reconstruct
% param.lambda = 0.01; % not more than 20 non-zeros coefficients
% param.numThreads = -1; 
% param.mode = 1;        
% 
% the1 = mexLasso(y, full(Phi*H), param);


opts.k = 200;
opts.L = 2;
opts.lam = 0.05;

the1 = FISTA(full(Phi*H), y, opts);



xs = zeros(N^2, 1);
xs(samples(1:m)) = x(samples(1:m)); 
subplot(1,4,1)
imagesc(reshape(xs, [N, N])); colormap gray;
subplot(1,4,2)
imagesc(reshape(full(H*the1), [N, N]), [0, 1]); colormap gray
subplot(1,4,3)
imagesc(X); colormap gray;
subplot(1,4,4)
% imagesc(reshape(H*H'*x, [N, N])); colormap gray;

true_coeff = H'*x;

figure;
subplot(1,2,1)
plot(true_coeff(1:100));
subplot(1,2,2)
plot(the1(1:100))