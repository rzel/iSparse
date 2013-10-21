### Reconstruct

This app takes an image in, and then reconstructs it, without looking at the
deleted data, using a compressed sensing algorithm (iterative soft
thresholding).

Implementing iterative soft thresholding was anything but easy, and took a
significant amount of time (a whole semester, actually). At this point, the
user interface was shoddy, the slider lagged, the animation didn't exist, there
was only one image and there was only one view. I had to dive deep into the
depths of the iOS API to fix all these issues (the animation being the most
significant).

This app takes some image, sampled between 20 and 80 percent, and reconstruct
it. In pictures, it goes between these:

![this][sample].![this][finished].

<img src=https://raw.github.com/scottsievert/iSensing/master/images/demo/first_final/30p_18lam_30i_2lev.png width="320" height="568"> 

### Getting the app on your device 
We plan to release this app on the App Store in approximately October 2013.
Until then, you can run this app on your computer by cloning this repo, opening
the `.xcodeproject` (installing XCode first, of course) and clicking run. This will run on your computer, but you
can run this app on your device only if you're registered with the Apple
Developer Program.

[finished]:https://raw.github.com/scottsievert/iSensing/master/images/demo/first_final/30p_18lam_30i_2lev.png
[sample]:https://raw.github.com/scottsievert/iSensing/master/images/demo/first_final/goldy_smoke_sample.png

