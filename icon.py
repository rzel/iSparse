
from pylab import *

n = 57 * 2
k = zeros((n, n)) + 0.8
k[1*n/3:2*n/3, 0*n/3:1*n/3] = 1
k[1*n/3:2*n/3, 2*n/3:3*n/3] = 1
k[0*n/3:1*n/3, 1*n/3:2*n/3] = 1
k[2*n/3:3*n/3, 1*n/3:2*n/3] = 1
#k = 1-k

filename = 'icon2x.png'
cmap = 'Blues'
imsave(filename,  k, cmap=cmap)
imshow(k, cmap=cmap)
show()



