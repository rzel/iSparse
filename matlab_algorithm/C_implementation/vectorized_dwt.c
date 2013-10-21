
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <Accelerate/Accelerate.h>

float * dwt(float * x, int N);

int main(){
    int N = 16;
    int i;
    float * x = (float *)malloc(sizeof(float) * N);
    float * y = (float *)malloc(sizeof(float) * N);

    
    for (i=0; i<N; i++) x[i] = i;
    y = dwt(x, N);

    printf("-------\n");
    for (i=0; i<N; i++) printf("%f\n", y[i]);


    return 0;
}

float * dwt(float * x, int n){
    float * one = (float *)malloc(sizeof(float) * n/2);
    float * two = (float *)malloc(sizeof(float) * n/2);
    float * low = (float *)malloc(sizeof(float) * n/2);
    float * high = (float *)malloc(sizeof(float) * n/2);
    float * w = (float *)malloc(sizeof(float) * n/1);

    int i;

    // getting every other element
    cblas_scopy(n/2, x, 2, one, 1);
    cblas_scopy(n/2, x+1, 2, two, 1);

    // adding those elements
    cblas_scopy(n/2, two, 1, low, 1);
    cblas_scopy(n/2, two, 1, high, 1);
    catlas_saxpby(n/2, 1, one, 1, 1, low, 1);
    catlas_saxpby(n/2, 1, one, 1, -1, high, 1);

    cblas_scopy(n/2, low, 1, w, 1);
    cblas_scopy(n/2, high, 1, w+n/2, 1);


    free(one);
    free(two);
    free(low);
    free(high);

    return w;

}
