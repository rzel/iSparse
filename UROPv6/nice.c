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

void swapS2(float * a, float * b);

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
void makeIDX(int * array, int N){
    // samples: an array of int's, malloc'd. gets overwritten.
    // N: how large samples should be
    float * in1 = (float *)malloc(sizeof(float) * N);
    float * in2 = (float *)malloc(sizeof(float) * N);
    float * out1 = (float *)malloc(sizeof(float) * N);
    value(in1, N, 0);
    value(in2, N, 1);
    vDSP_vramp(in1, in2, out1, 1, N);
    // ^ we've built the ramp vector from 0 to N-1
    
    // now, scramble that vector
    srand(42);
    for (int i=0; i<N; i++) {
        int ind = (random() % N);
        swapS2(out1+i, out1+ind);
    }
    vDSP_vfix32(out1, 1, array, 1, N);

    free(in1);
    free(in2);
    free(out1);
}
void swapS2(float * a, float * b){
    float temp = a[0];
    a[0] = b[0];
    b[0] = temp;
}