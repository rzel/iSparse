//
//  nice.c
//  iSensing
//
//  Created by Scott Sievert on 10/20/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#include <stdio.h>
#include <stdio.h>
#include "Accelerate/Accelerate.h"



void value(float * x, int N, float value){
    catlas_sset(N, value, x, 1);
}
void copy(float * source, float * dest, int N){
    cblas_scopy(N, source, 1, dest, 1);
}
void vecQuad(float * x, int xLimit, int yLimit, int width, int height, float * y){
    // overwrites!
    int yy;
    for (yy=0; yy<yLimit; yy++) {
        copy(x+yy*width, y+xLimit*yy, xLimit);
    }
    // now, y is the upper corner.
}