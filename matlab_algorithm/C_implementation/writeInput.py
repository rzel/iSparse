from __future__ import division
from pylab import *
from scipy.misc import lena
from numpy import savetxt

x = lena()
x = x / x.max()

savetxt('input.csv', x, delimiter=',')





