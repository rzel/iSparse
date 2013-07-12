from __future__ import division
from pylab import *
from scipy.misc import imresize
from scipy import signal
from scipy.ndimage import gaussian_filter, uniform_filter
from numpy import arctan, tan


mul = 1
n = mul * 57
radius = 10 * mul

k = imread('./UROPv6/lenna.jpg')
k = imresize(k, (n,n,3))

blur = 7
k[:,:,0] = uniform_filter(k[:,:,0], blur)
k[:,:,1] = uniform_filter(k[:,:,1], blur)
k[:,:,2] = uniform_filter(k[:,:,2], blur)

def paintRoundRectandBorder(arr, cornerRadius, width, color):
    # painting the rounded rect
    x = arange(arr.shape[0])
    y = arange(arr.shape[1])
    xmax, ymax = max(x), max(y)
    x, y = meshgrid(x, y)
    center = cornerRadius

    i = sqrt((x-center)**2 + (y-center)**2)
    j = arctan((y-center) / (x-center))

    j = j * 180 / 3.14
    j += 90
    m = (i > (cornerRadius - width)) & (j > 90) & (j < 180) & (x < center) & (y < center)
    arr[m] = color


    i = sqrt((xmax-x-center)**2 + (y-center)**2)
    j = (arctan((y-center) / (xmax-x-center))) * (180 / 3.14) #+ 90
    m = (i > (cornerRadius - width)) & (j > 0) & (j < 135) & (x-xmax < center) & (y < center)
    arr[m] = color

    i = sqrt((xmax-x-center)**2 + (ymax-y-center)**2)
    j = (arctan((ymax-y-center) / (xmax-x-center))) * (180 / 3.14) #+ 90
    m = (i > (cornerRadius - width)) & (j > 0) & (j < 135) & (x-xmax < center) & (ymax-y < center)
    arr[m] = color

    i = sqrt((x-center)**2 + (ymax-y-center)**2)
    j = (arctan((ymax-y-center) / (x-center))) * (180 / 3.14) #+ 90
    m = (i > (cornerRadius - width)) & (j > 0) & (j < 135) & (x < center) & (ymax-y < center)
    arr[m] = color

    # now, the borders
    i = x < width
    arr[i, :] = color

    i = xmax - x < width
    arr[i,:] = color

    i = ymax - y < width
    arr[i,:] = color

    i =  y < width
    arr[i,:] = color
    return arr

width = 3 * mul
width = 0
radius = mul * 12.5
color = (255, 255, 255)
#k = paintRoundRectandBorder(k, radius, width, color)


# thirds
zero  = width
one   = 1*(n-2*width)/3 + width
two   = 2*(n-2*width)/3 + width
three = 3*(n-2*width)/3 + width

# fourths
zero  = width
one   = 1*(n-2*width)/2 + width
two   = 2*(n-2*width)/2 + width

color = 0.87 * array(color)
k[zero:one, zero:one] = color
k[one:two, one:two] = color



#width = 3 * mul
#radius = mul * 12.5
#color = (255, 255, 255)
#k = paintRoundRectandBorder(k, radius, width, color)



imshow(k)
show()

filename = 'icon2x.png' if mul == 2 else 'icon.png'
imsave(filename,  k )
show()


