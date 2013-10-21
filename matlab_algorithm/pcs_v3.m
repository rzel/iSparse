close all;
clear;

% Here I am trying to make color images

addpath('./rwt');
addpath('./functions');
addpath('./data');
% load('smooth.mat');
% load('smooth2.mat');
% load('lena.mat');
% load('image2.mat');
% load('obama_full.mat');
% load('dome.mat');

load('obama_full_C.mat');
% load('dome_C.mat');
%% Parameters and Data

N = 2^12;        % input image dimension N x N
J = log2(N);

X1 = double(imresize(obama_full(:,:,1), [N, N]))/255;
X2 = double(imresize(obama_full(:,:,2), [N, N]))/255;
X3 = double(imresize(obama_full(:,:,3), [N, N]))/255;

% X1 = double(imresize(dome(:,:,1), [N, N]))/255;
% X2 = double(imresize(dome(:,:,2), [N, N]))/255;
% X3 = double(imresize(dome(:,:,3), [N, N]))/255;


% X = imresize(image, [N, N]);
x1 = (X1(:));
x2 = (X2(:));
x3 = (X3(:));




L = 1;      % L = 0,1,2,..., J - 1
Jn = J - L; 
M = 2^((J - L));
if(Jn > J)
    display('Jn should be less than J');
end


%% Get random signals
m = floor(0.1*N^2);            % # of measurements

% m = 0.2*N^2;
% m = 50000;
samples = randperm(N^2);

% get measurements
sig = 0;

y1 = x1(samples(1:m)) + sig*randn(m,1);
y2 = x2(samples(1:m)) + sig*randn(m,1);
y3 = x3(samples(1:m)) + sig*randn(m,1);



%% Use SPAMS to reconstruct

% FISTA Parameters
opts.k = 50;
opts.L = 2;
opts.lam = 0.05;
opts.M = M;
opts.N = N;
opts.level = L;

tic;
% Call FISTA
the1 = FISTA_W(samples(1:m), y1, opts);
the2 = FISTA_W(samples(1:m), y2, opts);
the3 = FISTA_W(samples(1:m), y3, opts);
toc;

% Get the reconstruction
The1 = reshape(the1, [M, M]);
Temp1 = zeros(N, N);
Temp1(1:M ,1:M) = The1;
Xhat1 = midwt(Temp1, daubcqf(2, 'min'));

The2 = reshape(the2, [M, M]);
Temp2 = zeros(N, N);
Temp2(1:M ,1:M) = The2;
Xhat2 = midwt(Temp2, daubcqf(2, 'min'));

The3 = reshape(the3, [M, M]);
Temp3 = zeros(N, N);
Temp3(1:M ,1:M) = The3;
Xhat3 = midwt(Temp3, daubcqf(2, 'min'));

xs1 = zeros(N^2, 1);
xs1(samples(1:m)) = x1(samples(1:m)); 

xs2 = zeros(N^2, 1);
xs2(samples(1:m)) = x2(samples(1:m)); 

xs3 = zeros(N^2, 1);
xs3(samples(1:m)) = x3(samples(1:m)); 


xsam = zeros(N^2,3);
xsam(:,1) = xs1;
xsam(:,2) = xs2;
xsam(:,3) = xs3;

xhat = zeros(N,N,3);
xhat(:,:,1) = Xhat1;
xhat(:,:,2) = Xhat2;
xhat(:,:,3) = Xhat3;

subplot(1,3,1)
imshow(reshape(xsam, [N, N, 3]));
subplot(1,3,2)
imshow(xhat, [0, 1]);
subplot(1,3,3)
imshow(imresize(obama_full, [N, N])); 
% subplot(1,4,4)
% imagesc(reshape(H*H'*x, [N, N])); colormap gray;

