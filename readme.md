### Reconstruct

This app takes an image in, and then reconstructs it, without looking at the
deleted data, using a compressed sensing algorithm (iterative soft
thresholding).

Implementing iterative soft thresholding was anything but easy, and took a
significant amount of time (a whole semester, actually). At this point, the
user interface was shoddy, the slider lagged, the animation didn't exist, and
there was only one view. I had to dive deep into the depths of the iOS API to
fix all these issues (the animation being the most significant).


This app takes some image, sampled between 20 and 80 percent, and reconstruct
it. In pictures, it goes between these:

![this][sample] 
![this][finished].

[finished]:https://raw.github.com/scottsievert/UROPv6/master/50-reconstruct.png
[sample]:https://raw.github.com/scottsievert/UROPv6/master/50-sample.png

