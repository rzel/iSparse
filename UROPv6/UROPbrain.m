/*
 *  Made by    : SparKEL Lab
 *  at the     : University of Minnesota
 *  advisor    : Jarvis Haupt
 *  programmer : Scott Sievert
 *  Copyright (c) 2013 by Scott Sievert. All rights reserved.
 *
 *  This file is best viewed when you fold all the functions; there are many
 *  many functions and the most important ones are at the bottom of the file.
 *  Additionally, there are comments starting with "the following
 *  functions...". Use your editors fold mode to get a grasp of the file before
 *  you make any edits.
 *
 *  The most important functions -- the purpose of this file, really --
 *  reconstructWithIST (the second to last function). It takes in a UIImage and
 *  converts to RGB then actually calls the reconstruction algorithm function,
 *  IST.
 *
 *  --Scott Sievert (sieve121 at umn.edu), 2013-09-17
 *
 */
#import "UROPbrain.h"
#import "UROPdwt.h"
#include "dwt.h"
#include "nice.h"

// below this value, we stop the animation
#define N_STOP 256

// #define....
// LAMBDA, LEVELS, LIPSHITZ_CONTANT defined in UROPbrain.h
//      -- Scott Sievert, 2013-10-20, sieve121 (at) umn.edu

@interface UROPbrain ()
@property (nonatomic, strong) UROPdwt *dwt;
@end

@implementation UROPbrain

// init'ing the dwt functions
-(UROPdwt *)dwt
{
    if (!_dwt) _dwt = [[UROPdwt alloc] init];
    return _dwt;
}

// functions to sample the image for the initial viewing.
-(float *)sample:(float *)array atRate:(float)rate ofLength:(int)n
{
    // vDSP_vthr will speed this up.
    // but how to make a random vector?
    
    // vDSP_vgen to make a ramped function
    // gsl_ran_shuffle to shuffle
    // vDSP_vthr to threshold
    
    srand(42);
    for (int i=0; i<n; i++) {
        float ra = (float)(rand() % n)/n;
        if (ra > rate) {
            array[i] = 0;
        }
    }

    return array;
}
-(UIImage *)sampleImage:(UIImage *)image atRate:(float)rate
{
    float pix = image.size.width * image.size.height;
    int n;
    float * colorPlane = (float *)malloc(sizeof(float) * pix);
    float * array = (float *)malloc(sizeof(float) * pix * 4);
    [self.dwt imageToRawArray:image into:array pix:pix];
    srandom(42); srand(42);
    for (n=0; n<3; n++) {

        colorPlane = [self.dwt getColorPlane:array ofArea:pix startingIndex:n into:colorPlane];
        colorPlane = [self sample:colorPlane atRate:rate ofLength:pix];
        array      = [self.dwt putColorPlaneBackIn:colorPlane into:array ofArea:pix startingIndex:n];
    }
    image = [self.dwt UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
    free(array);
    free(colorPlane);
    return image;
}
-(void)makeIDX:(NSMutableArray *)idx ofLength:(int)pix
{
    srand(42);
    int i;
    for (i=0; i<pix; i++) {
        [idx addObject:[NSNumber numberWithInt:i]];
    }
    srand(42); // 'srand' works
    for (i=0; i<pix; i++) {
        int index = random() % pix;
        [idx exchangeObjectAtIndex:i withObjectAtIndex:index];
    }
}

-(void)makeMeasurements2:(UIImage *)image atRate:(float)rate
                     red:(float *)y_r green:(float *)y_b blue:(float *)y_g
                ofLength:(int)length idx:(int *)idx{
    // vDSP_vgathr is equivalent to a[i] = b[c[i]] (!)
    int pix = image.size.height * image.size.width;
    float * array = (float *)malloc(sizeof(float) * pix * 4);
    float * colorPlane = (float *)malloc(sizeof(float) * pix);
    // get data

    [self.dwt imageToRawArray:image into:array pix:length];
    int n;

    // perform wavelet, 2D on image
    // using color planes, all of that
    // vDSP_vgathr is the equivalent of a[i] = b[c[i]]
    for (n=0; n<3; n++) {
        // copy from "array", which is RGBA,RGBA,RGBA...
        // and get the colorplane out
        cblas_scopy(pix, array+n, 4, colorPlane, 1);
        
        // the do-what-you-want code should go here.
        if (n == 0) {
            vDSP_vgathr(colorPlane, (const vDSP_Length *)idx, 1, y_r, 1, (int)(rate*pix));
        }
        if (n == 1) {
            vDSP_vgathr(colorPlane, (const vDSP_Length *)idx, 1, y_b, 1, (int)(rate*pix));
        }
        if (n == 2) {
            vDSP_vgathr(colorPlane, (const vDSP_Length *)idx, 1, y_g, 1, (int)(rate*pix));
        }
        cblas_scopy(pix, colorPlane, 1, array+n, 4);
    }
    
    catlas_sset(pix, 255, array+3, 4);
    
    image = [self.dwt UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
    free(array);
    free(colorPlane);



}

// another init. actual for initial view.
-(void)makeMeasurements:(UIImage *)image atRate:(float)rate
                   red:(float *)y_r green:(float *)y_b
                   blue:(float *)y_g
               ofLength:(int)length
                    idx:(NSMutableArray *)idx
{
    int pix = image.size.height * image.size.width;
    float * array = (float *)malloc(sizeof(float) * pix * 4);
    float * colorPlane = (float *)malloc(sizeof(float) * pix);
    // get data
    array = [self.dwt UIImageToRawArray:image];
    int j, n;
    //float max, min;
    // end making raw array
    // begin the wavelet part
    
    // perform wavelet, 2D on image
    // using color planes, all of that
    for (n=0; n<3; n++) {
        
        colorPlane = [self.dwt getColorPlane:array ofArea:pix startingIndex:n into:colorPlane];
        
        // the do-what-you-want code should go here.
        if (n == 0) {
            for (j=0; j<rate * pix; j++) {
                int index = [[idx objectAtIndex:j] intValue];
                y_r[j] = colorPlane[index];
            }
        }
        if (n == 1) {
            for (j=0; j<rate * pix; j++) {
                int index = [[idx objectAtIndex:j] intValue];
                y_b[j] = colorPlane[index];
            }
        }
        if (n == 2) {
            for (j=0; j<rate * pix; j++) {
                int index = [[idx objectAtIndex:j] intValue];
                y_g[j] = colorPlane[index];
            }
        }
        
        
        // end of do what you want
        
        array      = [self.dwt putColorPlaneBackIn:colorPlane into:array ofArea:pix startingIndex:n];
    }
    
    
    
    for (long i=3; i<4*pix; i=i+4)
    {array[i] = 255;}
    // return image
    image = [self.dwt UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
    free(array);
    free(colorPlane);
    
    
}

-(UIImage *)reconstructWithFISTA:(UIImage *)image
                          Xhat_r:(float *)Xhat_r Xhat_g:(float *)Xhat_g Xhat_b:(float *)Xhat_b
                         samples:(int *)samples
                             y_r:(float *)y_r y_g:(float *)y_g y_b:(float *)y_b
                            y2_r:(float *)y2_r y2_g:(float *)y2_g y2_b:(float *)y2_b
                             x_r:(float *)x_r x_g:(float *)x_g x_b:(float *)x_b
                           b_t_r:(float *)b_t_r  b_t_g:(float *)b_t_g  b_t_b:(float *)b_t_b
                             t_r:(float *)t_r t_g:(float *)t_g t_b:(float *)t_b
                               M:(int)M N:(int)N k:(int)k m:(int)m levels:(int)levels
{
    // t = FISTA_W(Xhat, samples, y, y2, x, b_t, t, M, N, 1, m);

    // we need no image-to-array function, as the arrays are held in the view controller.
    int height = image.size.height;
    int width = image.size.width;
    int pix = height * width;
    int n;
    float * array = (float *)malloc(sizeof(float) * 4 * N * N);


    if (width < N_STOP){
        image = [UIImage imageNamed:@"one.jpg"];
        return image;
    } else{
        float * Xhat = (float *)malloc(sizeof(float) * pix * 4);
        float * y = (float *)malloc(sizeof(float) * pix);
        float * y2 = (float *)malloc(sizeof(float) * pix);
        float * x = (float *)malloc(sizeof(float) * pix);
        float * b_t = (float *)malloc(sizeof(float) * pix);
        float tf;
        float trf_r = *t_r;
        float trf_g = *t_g;
        float trf_b = *t_b;

        
        for (n=0; n<3; n++) {
            // for each color plane
            // properly init
            if (n==0) {
                copy(y_r, y, m);
                copy(Xhat_r, Xhat, N*N);
                copy(y2_r, y2, M*M);
                copy(x_r, x, M*M);
                copy(b_t_r, b_t, M*M);
                tf = trf_r;
            } else  if (n==1) {
                copy(y_g, y, m);
                copy(Xhat_g, Xhat, N*N);
                copy(y2_g, y2, M*M);
                copy(x_g, x, M*M);
                copy(b_t_g, b_t, M*M);
                tf = trf_g;
            } else if (n==2) {
                copy(y_b, y, m);
                copy(Xhat_b, Xhat, N*N);
                copy(y2_b, y2, M*M);
                copy(x_b, x, M*M);
                copy(b_t_b, b_t, M*M);
                tf = trf_b;
            }
            // the do-what-you-want code should go here. actually performing the algorithm.
            tf = FISTA_W(Xhat, samples, y, y2, x, b_t, tf, M, N, 1, m, levels);
            // and then update
            if (n==0) {
                copy(y, y_r, m);
                copy(Xhat, Xhat_r, N*N);
                copy(y2, y2_r, M*M);
                copy(x, x_r, M*M);
                copy(b_t, b_t_r, M*M);
                trf_r = tf;
            } else if (n==1) {
                copy(y, y_g, m);
                copy(Xhat, Xhat_g, N*N);
                copy(y2, y2_g, M*M);
                copy(x, x_g, M*M);
                copy(b_t, b_t_g, M*M);
                trf_g = tf;
            } else if (n==2) {
                copy(y, y_b, m);
                copy(Xhat, Xhat_b, N*N);
                copy(y2, y2_b, M*M);
                copy(x, x_b, M*M);
                copy(b_t, b_t_b, M*M);
                trf_b = tf;
            }
            
            // end of do what you want
            idwt2_full(Xhat, N, N);
            vec(Xhat, N, N);
            
            array      = [self.dwt putColorPlaneBackIn:Xhat into:array ofArea:N*N startingIndex:n];
        }
        *t_r = trf_r;
        *t_g = trf_g;
        *t_b = trf_b;
        // the assignment isn't working.

        image = [self.dwt UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
        
        
        free(array);
        free(y2);
        free(y);
        free(b_t);
        free(Xhat);
        free(x);
        return image;
    }
    
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

float FISTA_W(float * Xhat, int * A, float * b, float * y, float * x, float * b_t,
              float t, int M, int N, int k, int m, int levels){
    /*
     *   Xhat : the current wavelet estimate
     *   A : sampling locations
     *   b : the observation vector
     *   y : an intermediate array we need
     *   x : an intermediate array we need
     *   b_t : precalculated thing for FISTA
     *   t : threshold
     *   M : how large we want wavelet to be after we drop levels
     *   N : how large with drop_levels=0;
     *   k : iterations
     *   m : how samples to take
     *
     *   -- Scott Sievert, 2013-10-20, sieve121 (at) umn.edu
     */
    // the documentation for the BLAS stuff can be found at...
    //      https://developer.apple.com/performance/accelerateframework.html
    //      https://developer.apple.com/library/IOs/documentation/Accelerate/ Reference/AccelerateFWRef/_index.html#//apple_ref/doc/uid/TP40009465
    
    int i;
    int xx, yy;
    float * x_nk = (float *)malloc(sizeof(float) * M * M);
    float * x_k = (float *)malloc(sizeof(float) * M * M);
    
    // step sizes
    float t_k, t_nk;
    
    // FISTA iterations
    int jj;
    for (jj=0; jj<k; jj++){
        // if using printf in this loop, use fflush(stdout)
        x_nk = pL(y, A, b_t, N, m, levels);
        
        // do we have to copy it over? before the pL call?
        copy(x, x_k, M*M);
        t_k = t;
        t_nk = 0.5*(1 + sqrt((1 + 4 * t_k * t_k)));

        for (i=0; i<M*M; i++){
            y[i] = x_nk[i] + ((t_k -1)/(t_nk))*(x_nk[i] - x_k[i]);
        }
        
        copy(x_nk, x, M*M);
        t = t_nk;
    }
    
    float * The1 = (float *)malloc(sizeof(float) * N * N);
    float * Temp1 = (float *)malloc(sizeof(float) * N * N);

    copy(x, The1, M*M);
    vec(The1, M, M);
    
    for (i=0; i<N*N; i++) Temp1[i] = 0;
    for (xx=0; xx<M; xx++){
        for (yy=0; yy<M; yy++){
            Temp1[yy*N + xx] = The1[yy*M + xx];
        }
    }
    
    for (i=0; i<N*N; i++) Xhat[i] = Temp1[i];
    
    free(The1);
    free(Temp1);
    free(x_k);
    free(x_nk);

    return t;
}

float * pL(float * y, int * A, float * b_t, int N, int m, int levels){
    int xx, yy, i;
    int n = (int)powf(N, 2);
    int n1 = (int)(n / (1.0 *powf(2, 2*levels)));
    int N1 = (int)sqrt(n1);
    int Nj = (int)(N / (1.0 * powf(2, levels)));
    
    float * Y = (float *)malloc(sizeof(float) * N1 * N1);
    float * h = (float *)malloc(sizeof(float) * N * N);
    float * Yt = (float *)malloc(sizeof(float) * N * N);
    float * y_t = (float *)malloc(sizeof(float) * Nj * Nj);
    float * temp_x = (float *)malloc(sizeof(float) * Nj * Nj);
    float * temp_1 = (float *)malloc(sizeof(float) * Nj * Nj);
    float * xk = (float *)malloc(sizeof(float) * Nj * Nj);
    float * phi_y = (float *)malloc(sizeof(float) * N * N);
    float * phi_y_w = (float *)malloc(sizeof(float) * N * N);
    value(Y, N1*N1, 0);
    value(h, N*N, 0);
    value(Yt, N*N, 0);
    value(y_t, Nj*Nj, 0);
    value(temp_x, Nj*Nj, 0);
    value(temp_1, Nj*Nj, 0);
    value(xk, Nj*Nj, 0);
    value(phi_y, N*N, 0);
    value(phi_y_w, N*N, 0);
    
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
    value(Yt, N*N, 0);
    for (xx=0; xx<N1; xx++){
        for (yy=0; yy<N1; yy++){
            Yt[yy*N + xx] = Y[yy*N1 + xx];
        }
    }
    
    idwt2_full(Yt, N, N);
    vec(Yt, N, N);

    for (i=0; i<N*N; i++) phi_y[i] = 0;
    for (i=0; i<m; i++){
        phi_y[A[i]] = Yt[A[i]];
    }
    
    vec(phi_y, N, N);
    dwt2_full(phi_y, N, N);
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
@end
