

load('lena.mat')

N = 2^10;
x = imresize(image, [N N]);

csvwrite('input.csv', x)
% 1 

imagesc(x); colormap gray