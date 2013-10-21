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