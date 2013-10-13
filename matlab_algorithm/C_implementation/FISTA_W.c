
#include "dwt.h"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <Accelerate/Accelerate.h>

// libschitz constant
#define LIPSHITZ_CONSTANT 2

// how many levels are we going to throw away?
#define LEVELS 2

// everything below this is set to 0.
#define LAMBDA 0.05

void FISTA_W(int * A, float * b, int m, int N, int k);
void pL(float * y, int * A, float * b_t, int M, int N);

int main(){
    int i;

    int N = powf(2, 10);
    int J = log2(N);

    float * x = malloc(sizeof(float) * N * N);
    for (i=0; i<N*N; i++){
        if (i < N*N/2) x[i] = i / (1.0 * N * N);
        else x[i] = 255;
    }

    // how many levels do we want to keep?
    int L = LEVELS;
    int Jn = J - L;
    int M = powf(2, J-L);

    // how many samples should we take?
    int m = floor(0.7 * N * N);

    // the indicies where we sample.
    int * samples = (int *)malloc(sizeof(int) * N * N);
    randperm(N*N, samples);

    // out samples
    float * y = (float *)malloc(sizeof(float) * m);

    // making our samples
    float noise = 0;
    for (i=0; i<m; i++) y[i] = x[samples[i]] + noise * rand();

    int k = 30; // number of iterations
    FISTA_W(samples, y, M, N, k);


    return 0;
}

void FISTA_W(int * A, float * b, int M, int N, int k){
    // M: how large the (approx) image is
    // N: how large the actual image is.
    // k: how many iterations.
    // A: the measurement matrix (m x n)
    // b: the observations (m x 1), randperm
    // the documentation for the BLAS stuff can be found at...
    //      https://developer.apple.com/performance/accelerateframework.html
    //      https://developer.apple.com/library/IOs/documentation/Accelerate/ Reference/AccelerateFWRef/_index.html#//apple_ref/doc/uid/TP40009465
    int i;
    int xx, yy;
    float * x = (float *)malloc(sizeof(float) * M * M);
    float * y = (float *)malloc(sizeof(float) * M * M);
    float * phi_b = (float *)malloc(sizeof(float) * N * N);
    float * phi_b_w = (float *)malloc(sizeof(float) * N * N);
    float * b_t = (float *)malloc(sizeof(float) * N * N);
    float * b_t_pre = (float *)malloc(sizeof(float) * N * N);

    // changing every element of y to x
    cblas_scopy(M * M, x, 1, y, 1);

    // step size
    float t = 1;


    // I is the N x N identity matrix
    // b is the obeservation vector

    // precalculation H'*I'*b
    catlas_sset(N, 0, phi_b, 1); // setting every element to 0

    // DEBUG: A[0] = 0 for debugging purposes only
    A[0] = 0;
    for (i=0; i<M; i++) phi_b[A[i]] = b[i];

    // overwrites phi_b
    dwt2_full(phi_b, M, M);

    // reshaping
    for (xx=0; xx<M; xx++){
        for (yy=0; yy<M; yy++){
            b_t_pre[yy*M + xx] = phi_b[yy*N + xx];
        }
    }

    // vec
    vDSP_mtrans(b_t_pre, 1, b_t, 1, M, M);

    pL(y, A, b_t, M, N);
}

void pL(float * y, int * A, float * b_t, int M, int N){
    int n = powf(N, 2);
    int n1 = n / powf(2, 2*LEVELS);








}







