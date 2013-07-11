
from pylab import *

mul = 1
cmap = 'OrRd'


n = 57 * mul
k = zeros((n, n)) + 0.0
k[1*n/3:2*n/3, 0*n/3:1*n/3] = 1
k[1*n/3:2*n/3, 2*n/3:3*n/3] = 1
k[0*n/3:1*n/3, 1*n/3:2*n/3] = 1
k[2*n/3:3*n/3, 1*n/3:2*n/3] = 1
#k = 1-k

filename = 'icon2x.png' if mul == 2 else 'icon.png'
imsave(filename,  k, cmap=cmap)
imshow(k, cmap=cmap)
show()



