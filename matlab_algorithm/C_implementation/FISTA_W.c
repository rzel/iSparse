
#include "dwt.h"
#include "nice.c"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <Accelerate/Accelerate.h>

// the libschitz constant
#define LIP 2

// how many levels are we going to throw away?
#define LEVELS 0

// everything below this is set to 0.
#define LAMBDA 0.05

float * FISTA_W(int * A, float * b, int m, int N, int k);
float * pL(float * y, int * A, float * b_t, int M, int N);

int main(){
    int i;

    int N = powf(2, 9);
    int J = log2(N);

    float * x = (float *)malloc(sizeof(float) * N * N);
    float * xh = (float *)malloc(sizeof(float) * N * N);
    readImage(x, N, N);

    // how many levels do we want to keep?
    int L = LEVELS;
    int Jn = J - L;
    int M = powf(2, J-L);

    // how many samples should we take?
    int m = floor(1.0 * N * N);

    // the indicies where we sample.
    int * samples = (int *)malloc(sizeof(int) * N * N);
    randperm(N*N, samples);

    // out samples
    float * y = (float *)malloc(sizeof(float) * m);

    // making our samples
    float noise = 0;
    for (i=0; i<m; i++) y[i] = x[samples[i]] + noise * rand();
    for (i=0; i<10; i++) printf("%f\n", y[i]);

    int k = 30; // number of iterations
    xh = FISTA_W(samples, y, M, N, k);

    writeImage(xh, N, N);


    return 0;
}

float * FISTA_W(int * A, float * b, int M, int N, int k){
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
    float * x_nk = (float *)malloc(sizeof(float) * M * M);
    float * x_k = (float *)malloc(sizeof(float) * M * M);
    float * y = (float *)malloc(sizeof(float) * M * M);
    float * phi_b = (float *)malloc(sizeof(float) * N * N);
    float * phi_b_w = (float *)malloc(sizeof(float) * N * N);
    float * b_t = (float *)malloc(sizeof(float) * N * N);
    float * b_t_pre = (float *)malloc(sizeof(float) * N * N);

    // step sizes
    float t, t_k, t_nk;
    t = 1;
    


    // changing every element of y to x
    cblas_scopy(M * M, x, 1, y, 1);

    // I is the N x N identity matrix
    // b is the obeservation vector

    // precalculation H'*I'*b
    catlas_sset(N, 0, phi_b, 1); // setting every element to 0

    // DEBUG: A[0] = 0 for debugging purposes only
    for (i=0; i<M*M; i++) phi_b[A[i]] = b[i];

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

    // FISTA iterations
    int jj;
    for (jj=0; jj<k; jj++){
        x_nk = pL(y, A, b_t, M, N);
        // do we have to copy it over? before the pL call?
        x_k = x;
        t_k = t;

        for (i=0; i<N*N; i++){
            y[i] = x_nk[i] + ((t_k -1)/(t_nk))*(x_nk[i] - x_k[i]);
        }

        t_nk = 0.5*(1 + sqrt((1 + 4*t_k * t_k)));
        x = x_nk;
        t = t_nk;
    }
    idwt2_full(x, N, N);
    return x;
}

float * pL(float * y, int * A, float * b_t, int M, int N){
    /*
     * adapted from this matlab code:
        n  = N^2;
        n1 = n/2^(2*Level);
        N1 = sqrt(n1);
        Y  = reshape(y, [N1, N1]);
        Yt = zeros(N, N);
        Yt(1:N1, 1:N1) = Y;

        h = midwt(Yt, daubcqf(2, 'min'));
        y1 = vec(h);


        Phi_y    = zeros(n,1);
        Phi_y(A) = y1(A);
        h = reshape(Phi_y, [N N]);
        Phi_y_W  = mdwt(h, daubcqf(2, 'min'));
        y_t = vec(Phi_y_W(1:N/2^Level, 1:N/2^Level));


        % calculating the gradiend step
        temp_x = y - 2/L*(y_t - b_t);

        % thresholding
        temp_1 = (abs(temp_x) - lam/L);
        temp_1(temp_1 < 0) = 0;

        xk = temp_1 .* sign(temp_x);
    */
    int xx, yy, i;
    int n = powf(N, 2);
    int n1 = n / powf(2, 2*LEVELS);
    int N1 = sqrt(n1);
    int Nj = N / powf(2, LEVELS);

    float * Y = (float *)malloc(sizeof(float) * n);
    float * h = (float *)malloc(sizeof(float) * N * N);
    float * Yt = (float *)malloc(sizeof(float) * N * N);
    float * y_t = (float *)malloc(sizeof(float) * Nj * Nj);
    float * temp_x = (float *)malloc(sizeof(float) * Nj * Nj);
    float * temp_1 = (float *)malloc(sizeof(float) * Nj * Nj);
    float * xk = (float *)malloc(sizeof(float) * Nj * Nj);
    float * phi_y = (float *)malloc(sizeof(float) * N * N);
    float * phi_y_w = (float *)malloc(sizeof(float) * N * N);

    // is this necessary? we can replace this with a transpose
    for (xx=0; xx<N1; xx++){
        for (yy=0; yy<N1; yy++){
            Y[yy*N1 + xx] = y[i];
            i++;
        }
    }

    // we can replace this with a vectorized version easily
    for (i=0; i<N*N; i++){
        Yt[i] = 0;
    }

    for (xx=0; xx<N1; xx++){
        for (yy=0; yy<N1; yy++){
            Yt[yy*N1 + xx] = Y[yy*N + xx];
        }
    }

    dwt2_full(Yt, N, N);
    vec(Yt, N, N);
    // y1 is really Yt
    for (i=0; i<M; i++){
        phi_y[A[i]] = Yt[A[i]];
    }

    // TODO: have to see about un-vec'ing the function (or re-vec'ing)
    dwt2_full(phi_y, N, N);
        /*y_t = vec(Phi_y_W(1:N/2^Level, 1:N/2^Level));*/
    for (xx=0; xx<Nj; xx++){
        for (yy=0; yy<Nj; yy++){
            y_t[yy*Nj + xx] = phi_y[yy*N + xx];
        }
    }


        /*% calculating the gradiend step*/
        /*temp_x = y - 2/L*(y_t - b_t);*/
    for (i=0; i<Nj*Nj; i++){
        temp_x[i] = y[i] - 2/(LIP*1.0) * (y_t[i] - b_t[i]);
    }

    for (i=0; i<Nj*Nj; i++){
        temp_1[i] = (abs(temp_x[i] - LAMBDA / (1.0 * LIP)));
        if (temp_1[i] == 0) temp_1[i] = 0;
    }
    for (i=0; i<Nj*Nj; i++){
        xk[i] = temp_1[i] * 1; //sign(temp_x[i]);
    }
    return xk;

        /*% thresholding*/
        /*temp_1 = (abs(temp_x) - lam/L);*/
        /*temp_1(temp_1 < 0) = 0;*/

        /*xk = temp_1 .* sign(temp_x);*/
}







