
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <Accelerate/Accelerate.h>

float * dwt(float * x, int N);
float * idwt(float *x, int N);

int main(){
    int N = 16;
    int i;
    float * x = (float *)malloc(sizeof(float) * N);
    float * y = (float *)malloc(sizeof(float) * N);

    
    for (i=0; i<N; i++) x[i] = i;
    y = dwt(x, N);
    idwt(y, N);

    printf("-------\n");
    for (i=0; i<N; i++) printf("%f\n", y[i]);


    return 0;
}

float * idwt(float *x, int N){
    float * one = (float *)malloc(sizeof(float) * N/2);
    float * two = (float *)malloc(sizeof(float) * N/2);
    float * low = (float *)malloc(sizeof(float) * N/2);
    float * high = (float *)malloc(sizeof(float) * N/2);
    float * w = (float *)malloc(sizeof(float) * N/1);
    int i;

    // one and two are the first halfs of the signal
    cblas_scopy(N/2, x, 1, one, 1);
    cblas_scopy(N/2, x+N/2, 1, two, 1);

    // the additions
    cblas_scopy(N/2, two, 1, low, 1);
    catlas_saxpby(N/2, 1, one, 1, 1, low, 1);

    // the subtractions
    cblas_scopy(N/2, two, 1, high, 1);
    catlas_saxpby(N/2, 1, one, 1, -1, high, 1);

    // now, the arrays are split up: the first and third elements are in one
    // array, the second and fourth elements in the other.
    
    cblas_scopy(N/2, low, 1, w, 2);
    cblas_scopy(N/2, high, 1, w+1, 2);
    // and scaling properly
    cblas_sscal(N, 1/sqrt(2), w, 1);
}

float * dwt(float * x, int N){
    float * one = (float *)malloc(sizeof(float) * N/2);
    float * two = (float *)malloc(sizeof(float) * N/2);
    float * low = (float *)malloc(sizeof(float) * N/2);
    float * high = (float *)malloc(sizeof(float) * N/2);
    float * w = (float *)malloc(sizeof(float) * N/1);

    // gettiNg every other elemeNt
    cblas_scopy(N/2, x, 2, one, 1);
    cblas_scopy(N/2, x+1, 2, two, 1);

    // addiNg those elemeNts
    cblas_scopy(N/2, two, 1, low, 1);
    cblas_scopy(N/2, two, 1, high, 1);
    catlas_saxpby(N/2, 1, one, 1, 1, low, 1);
    catlas_saxpby(N/2, 1, one, 1, -1, high, 1);

    cblas_scopy(N/2, low, 1, w, 1);
    cblas_scopy(N/2, high, 1, w+N/2, 1);
    cblas_sscal(N, 1.0f/sqrt(2), w, 1);

    free(one);
    free(two);
    free(low);
    free(high);

    return w;

}
