close all; clear all; clc;
%  SCOTT SIEVERT , AKSHAY SONI , JARVIS HAUPT
% {sieve121      , sonix022    , jdhaupt     }@umn.edu

% adding the paths
addpath('./functions');
addpath('./rwt');
S2run = 1; 
addpath('./data');

% loading the data
% load('smooth.mat');
% load('smooth2.mat');
load('lena.mat');
% load('image2.mat');
% load('obama_full.mat');
%load('dome.mat');

%% Parameters and Data
N = 2^11;                    % input image dimension N x N
J = log2(N);                 % how many levels there are
X = imresize(image, [N, N]); % resizing the image
x = mat2gray(X(:));          % making it gray scale
x_stay = x;

% L == levels we want to drop
L = 2;           % levels we want to drop
Jn = J - L;      % the levels we want to keep
M = 2^((J - L)); % the size that we want to keep
if(Jn > J) display('Jn should be less than J'); end

%% Get random signals
m = floor(0.15*N^2);  % # of measurements

% where to sample
samples = randperm(N^2);
%samples = 1:N^2;
% get measurements
sig = 0; % the noise term
y = x(samples(1:m)) + sig*randn(m,1);
display(y(1:10));


%% Use SPAMS to reconstruct

% FISTA Parameters
opts.k     = 40;   % iterations
opts.L     = 2;    % Lipschitz constant
opts.lam   = 0.05; % lam -- sparsity (everything below this =  = 0)
opts.M     = M;    % size of sampled image
opts.N     = N;    % size of full image
opts.level = L;    % levels we want to throw

%% Call FISTA
tic;
the1 = FISTA_W(samples(1:m), y, opts);

% Get the reconstruction
The1 = reshape(the1, [M, M]);
Temp1 = zeros(N, N);
Temp1(1:M ,1:M) = The1;
Xhat = midwt(Temp1, daubcqf(2, 'min'));
toc;

%% Show the images
xs = zeros(N^2, 1);
xs(samples(1:m)) = x(samples(1:m)); 

subplot(1,3,1)
imshow(reshape(xs, [N, N])); colormap gray;
title('Samples')

subplot(1,3,2)
imshow(Xhat, [0, 1]); colormap gray
title('Reconstruction')

subplot(1,3,3)
imshow(mat2gray(X)); colormap gray;
title('Original')

