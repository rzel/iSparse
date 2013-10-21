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
float * vecQuad(float * x, int xLimit, int yLimit, int width, int height){
    float * y = (float *)malloc(sizeof(float) * width * height);
    float * y1 = (float *)malloc(sizeof(float) * width * height);
    int xx, yy;
    for (yy=0; yy<yLimit; yy++) {
//        for (xx=0; xx<xLimit; xx++) {
//            y[xLimit * yy + xx] = x[yy*width + xx];
//        }
        copy(x+yy*width, y+xLimit*yy, xLimit);
    }
    // now, y is the upper corner.
    vDSP_mtrans(y, 1, y1, 1, xLimit, yLimit);
    free(y);
    return y1;
}