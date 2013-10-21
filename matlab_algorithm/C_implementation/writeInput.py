from __future__ import division
from pylab import *
from scipy.misc import lena, imresize
from numpy import savetxt

x = lena()
#N = 2**9
#x = imresize(x, (N, N))
x = x / x.max()

savetxt('input.csv', x, delimiter=',')

show()




