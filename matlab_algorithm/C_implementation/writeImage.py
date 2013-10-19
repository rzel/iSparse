#!/bin/sh
print "Starting Python script..."
from pylab import *
from pandas import read_csv

x = read_csv('image.csv', header=None)

figure()
imshow(x,  interpolation='nearest', cmap='gray')
colorbar()
axis('off')
title(str(array(x).shape))
savefig("image.png", dpi=300)

print "Ending Python script..."
