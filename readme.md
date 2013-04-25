

This app reconstructs an image that's partially deleted, and will soon be
available in the app store (for iOS).

There is still some work on the user interface to do. The animation needs to
play in real time (no delay), the image needs to be pinch-to-zoom, and the
buttons need to be moved/the colors changed. 

I'm currently using deprecated methods that will be rejected from the app store
to get photos from the camera roll. These also need to be fixed.

In short, this application goes from sampling an image at a ~50% rate to
reconstructing it, though not perfectly. In pictures: 

![this][sample] 

to...

![this][finished].

[finished]:https://raw.github.com/scottsievert/UROPv6/master/50reconstruct.png
[sample]:https://raw.github.com/scottsievert/UROPv6/master/50sample-cropped.png

