filename = 'goldy_smoke';%.jpg';

x = imread(strcat(filename, '.jpg'));
x = imresize(x, [1024 1024]);

imshow(x)
print('-djpeg100', strcat(filename,'_temp.jpg'))
close;

!convert goldy_smoke_temp.jpg -fuzz 10000 -trim +repage goldy_smoke_resize.jpg
!rm goldy_smoke_temp.jpg