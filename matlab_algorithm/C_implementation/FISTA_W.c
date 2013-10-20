
#include "dwt.h"
#include "nice.c"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <Accelerate/Accelerate.h>

// the libschitz constant
#define LIP 2.0

// how many levels are we going to throw away?
#define LEVELS 1

// sampling rate
#define P 0.20

// everything below this is set to 0.
#define LAMBDA 0.05

float * pL(float * y, int * A, float * b_t, int N, int m);
float * FISTA_W(int * A, float * b, int M, int N, int k, int m);
void debug();

int main(){
    debug();
    int i, xx, yy;

    int N = powf(2, 9);
    int J = log2(N);

    // how many levels do we want to keep?
    int L = LEVELS;
    int Jn = J - L;
    int M = powf(2, J-L);

    float * x = (float *)malloc(sizeof(float) * N * N);
    float * xh = (float *)malloc(sizeof(float) * N * N);
    float * x_final = (float *)malloc(sizeof(float) * N * N);
    float * the1 = (float *)malloc(sizeof(float) * M * M);
    float * The1 = (float *)malloc(sizeof(float) * M * M);
    float * Temp1 = (float *)malloc(sizeof(float) * N * N);
    float * Xhat = (float *)malloc(sizeof(float) * N * N);
    readImage(x, N, N);

    // TODO: vectorize

    // how many samples should we take?
    int m = floor(P * N * N);

    // the indicies where we sample.
    int * samples = (int *)malloc(sizeof(int) * N * N);
    for (i=0; i<N*N; i++) samples[i] = i;
    randperm(N*N, samples);

    // out samples
    float * y = (float *)malloc(sizeof(float) * m);

    // making our samples
    float noise = 0;
    for (i=0; i<m; i++) y[i] = x[samples[i]] + noise * rand();

    // *****************************************************
    // *********** START OF FISTA NORMALLY *****************
    // *****************************************************
    float * x = (float *)malloc(sizeof(float) * M * M);
    float * x_nk = (float *)malloc(sizeof(float) * M * M);
    float * x_k = (float *)malloc(sizeof(float) * M * M);
    float * y = (float *)malloc(sizeof(float) * M * M);
    float * phi_b = (float *)malloc(sizeof(float) * N * N);
    float * phi_b_w = (float *)malloc(sizeof(float) * N * N);
    float * b_t = (float *)malloc(sizeof(float) * M * M);
    float * b_t_pre = (float *)malloc(sizeof(float) * M * M);
    for (i=0; i<N*N; i++) phi_b[i] = 0;


    // step sizes
    float t, t_k, t_nk;
    t = 1;

    for (i=0; i<M*M; i++) x[i] = 0;
    // changing every element of y to x
    cblas_scopy(M * M, x, 1, y, 1);

    // I is the N x N identity matrix
    // b is the obeservation vector

    // precalculation H'*I'*b
    catlas_sset(N*N, 0, phi_b, 1); // setting every element to 0

    // DEBUG: A[0] = 0 for debugging purposes only
    for (i=0; i<m; i++) phi_b[A[i]] = b[i];

    // overwrites phi_b
    dwt2_full(phi_b, N, N);
    vec(phi_b, N, N);

    // reshaping
    for (xx=0; xx<M; xx++){
        for (yy=0; yy<M; yy++){
            b_t_pre[yy*M + xx] = phi_b[yy*N + xx];
        }
    }

    // vec (just a transpose since C)
    vDSP_mtrans(b_t_pre, 1, b_t, 1, M, M);
    // similar output to matlab's

    // *****************************************************
    // *********** END OF FISTA NORMALLY *****************
    // *****************************************************

    int k = 30; // number of iterations
    the1 = FISTA_W(samples, y, M, N, k, m);

    for (i=0; i<M*M; i++) The1[i] = the1[i];
    vec(The1, M*M);

    for (i=0; i<N*N; i++) Temp1[i] = 0;
    for (xx=0; xx<M; xx++){
        for (yy=0; yy<M; yy++){
            Temp1[yy*N + xx] = The1[yy*M + xx];
        }
    }

    for (i=0; i<N*N; i++) Xhat[i] = Temp1[i];
    idwt2_full(Xhat, N, N);


    writeImage(Xhat, N, N);

    return 0;
}

float * FISTA_W(int * A, float * b, int M, int N, int k, int m){
    // M: how large the (approx) image is
    // N: how large the actual image is.
    // k: how many iterations.
    // A: the measurement matrix (m x n)
    // b: the observations (m x 1), randperm
    // the documentation for the BLAS stuff can be found at...
    //      https://developer.apple.com/performance/accelerateframework.html
    //      https://developer.apple.com/library/IOs/documentation/Accelerate/ Reference/AccelerateFWRef/_index.html#//apple_ref/doc/uid/TP40009465

    // FISTA iterations
    // this is where we want the function to start in iOS.
    // we need to precalculate b_t and return the right threshold
    int jj;
    for (jj=0; jj<k; jj++){
        // if using printf in this loop, use fflush(stdout)

        // for some reason, the energy in my signal keeps growing.
        // it *looks* like pL is working... the first iteration prints
        //      approximately correct
        x_nk = pL(y, A, b_t, N, m);
    /*printf("*** in pL *************************************\n");*/
    /*for (i=0; i<N*N; i++) printf("%f\n", x_nk[i]);*/

        // do we have to copy it over? before the pL call?
        copy(x, x_k, M*M);
        t_k = t;


        t_nk = 0.5*(1 + sqrt((1 + 4* t_k * t_k)));

        for (i=0; i<M*M; i++){
            y[i] = x_nk[i] + ((t_k -1)/(t_nk))*(x_nk[i] - x_k[i]);
        }

        copy(x_nk, x, M*M);
        t = t_nk;

    }
    return x;
}

float * pL(float * y, int * A, float * b_t, int N, int m){
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
    int n = (int)powf(N, 2);
    int n1 = (int)(n / (1.0 *powf(2, 2*LEVELS)));
    int N1 = (int)sqrt(n1);
    int Nj = (int)(N / (1.0 * powf(2, LEVELS)));

    float * Y = (float *)malloc(sizeof(float) * N1 * N1);
    float * h = (float *)malloc(sizeof(float) * N * N);
    float * Yt = (float *)malloc(sizeof(float) * N * N);
    float * y_t = (float *)malloc(sizeof(float) * Nj * Nj);
    float * temp_x = (float *)malloc(sizeof(float) * Nj * Nj);
    float * temp_1 = (float *)malloc(sizeof(float) * Nj * Nj);
    float * xk = (float *)malloc(sizeof(float) * Nj * Nj);
    float * phi_y = (float *)malloc(sizeof(float) * N * N);
    float * phi_y_w = (float *)malloc(sizeof(float) * N * N);
    for (i=0; i<N1*N1; i++) Y[i] = 0;
    for (i=0; i<N*N; i++) h[i] = 0;
    for (i=0; i<N*N; i++) Yt[i] = 0;
    for (i=0; i<Nj*Nj; i++) y_t[i] = 0;
    for (i=0; i<Nj*Nj; i++) temp_x[i] = 0;
    for (i=0; i<Nj*Nj; i++) temp_1[i] = 0;
    for (i=0; i<Nj*Nj; i++) xk[i] = 0;
    for (i=0; i<N*N; i++) phi_y[i] = 0;
    for (i=0; i<N*N; i++) phi_y_w[i] = 0;

    // is this necessary? we can replace this with a transpose
    // Y = reshape(y, [N1 N1])
    i = 0;
    for (xx=0; xx<N1; xx++){
        for (yy=0; yy<N1; yy++){
            Y[yy*N1 + xx] = y[yy*N1 + xx];
            i++;
        }
    }
    vec(Y, N1, N1);


    // we can replace this with a vectorized version easily
    for (i=0; i<N*N; i++){
        Yt[i] = 0;
    }

    for (xx=0; xx<N1; xx++){
        for (yy=0; yy<N1; yy++){
            Yt[yy*N + xx] = Y[yy*N1 + xx];
        }
    }

    idwt2_full(Yt, N, N);
    vec(Yt, N, N);


    /*vec(Yt, N, N);*/

    // END BUG
    // y1 is really Yt

    for (i=0; i<N*N; i++) phi_y[i] = 0;
    for (i=0; i<m; i++){
        phi_y[A[i]] = Yt[A[i]];
    }

    // TODO: have to see about un-vec'ing the function (or re-vec'ing)
    vec(phi_y, N, N);
    dwt2_full(phi_y, N, N);
        /*y_t = vec(Phi_y_W(1:N/2^Level, 1:N/2^Level));*/
    for (xx=0; xx<Nj; xx++){
        for (yy=0; yy<Nj; yy++){
            y_t[yy*Nj + xx] = phi_y[yy*N + xx];
        }
    }
    vec(y_t, Nj, Nj);


    for (i=0; i<Nj*Nj; i++){
        temp_x[i] = y[i] - 2/(LIP*1.0) * (y_t[i] - b_t[i]);
    }

    for (i=0; i<Nj*Nj; i++){
        temp_1[i] = fabs(temp_x[i]) - LAMBDA / (1.0 * LIP);
        if (temp_1[i] < 0){
            temp_1[i] = 0.0;
        }
    }

    for (i=0; i<Nj*Nj; i++){
        xk[i] = temp_1[i] * copysignf(1.0, temp_x[i]);
    }

    free(Y);
    free(h);
    free(Yt);
    free(y_t);
    free(temp_x);
    free(temp_1);
    free(phi_y);
    free(phi_y_w);
    return xk;
}

void debug(){
    /*float * pL(float * y, int * A, float * b_t, int N, int m){*/
    /*float * FISTA_W(int * A, float * b, int M, int N, int k, int m){*/
    int i;
    int N = 4;
    int N2 = N * N;
    int M = N;
    int k = 2;
    int m = 9;

    int * A = (int *)malloc(sizeof(float) * N);
    float * b_t = (float *)malloc(sizeof(float) * N * N);
    float * b = (float *)malloc(sizeof(float) * N * N);
    float * y = (float *)malloc(sizeof(float) * N * N);
    float * x = (float *)malloc(sizeof(float) * N * N);


    for (i = 0; i<N2; i++) b[i]   = i * i;
    for (i = 0; i<N2; i++) A[i]   = i;
    for (i = 0; i<N2; i++) b_t[i] = exp(i/10.0);

    k = 1;
    y = FISTA_W(A, b, M, N, k, m);
    /*x = pL(y, A, b_t, N, m);*/

    printf("***************************************\n");
    for (i=0; i<N2; i++) printf("%f\n", x[i]);
}





 
