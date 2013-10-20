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


// the libschitz constant
#define LIP 2.0f

// how many levels are we going to throw away?
#define LEVELS 1.0f

// sampling rate
#define P 0.55

// everything below this is set to 0.
#define LAMBDA 12



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

// from Akshat on 2013-10-10
-(float)FISTA_W:(float *)signal ofLength:(int)N
    ofWidth:(int)width ofHeight:(int)height order:(int)order
  iteration:(int)iter
     atRate:(float)p
       xold:(float *)xold xold1:(float *)xold1
          y:(float *)y
        idx:(NSMutableArray *)idx coarse:(float)coarse numberOfPastIterations:(int)pastIts
         tn:(float)tn
{
    // the function performs the "fast iterative soft thresholding algorithm (FISTA)". This is the meat of the code -- this is where your actual algorithm implementation goes. The rest is just (complicated) wrapper for this.
    
    // to straighten out:
    //      * xold/xold1, tn/tn1
    //      x vec possibly doesn't vectorize partial matricies right
    //      * various limit stuff
    //      * memory leaks
    //      * assigning x, xold, xold1, tn, tn1
    // --2013-10-12
    
    // how to test:
    //      * make your signal in this function. compare with matlab.
    
    /*     k     = opts.k;     % # of iterations
     L     = opts.L;     % Lipschitz constant of Grad(f)
     lam   = opts.lam;   % controls the sparsity
     Level = opts.level; % # of levels to discard
     M     = opts.M;     % M^2 == number of columns in new matrix of Haar
     N     = opts.N;     % N^2 == image dimension
     n     = N^2;
     % [~, n] = size(A);
     
     x = zeros(M^2,1);     % output initialization
     y = x;                % initialization for FISTA
     t = 1;                % step size
     
     % I IS THE N x N IDENTITY MATRIX
     % b IS THE OBSERVATION VECTOR
     
     % Precalulating H'*I'*b
     
     % calculate this once (meaning, in the app, pass it in each time)
     Phi_b = zeros(n,1);
     Phi_b(A) = b;           % calculate I'*b
     % do H'*I'*b and vectorize the result
     Phi_b_W = mdwt(reshape(Phi_b, [sqrt(n) sqrt(n)]), daubcqf(2, 'min'));
     b_t = vec(Phi_b_W(1:sqrt(n)/2^Level, 1:sqrt(n)/2^Level));
     
     % FISTA Iterations
         for i = 1:k
         
         % function call to calculate pL
         x_nk = pL(y, A, b_t, lam, L, N, Level);
         
         x_k  = x;
         t_k = t;
         
         % calculate step sizes
         t_nk = 0.5*(1 + sqrt((1 + 4*t_k^2)));
         y = x_nk + ((t_k -1)/(t_nk))*(x_nk - x_k);
         
         x = x_nk;
         t = t_nk;
     end
     
     */
    int i;
    float k   = iter;
    float L   = LIP;
    float lam = LAMBDA;
    int level = LEVELS;
    N = (int)sqrt(N); // already passed in. width!
    int n = (int)powf(1.0*N, 2.0);
    int M = (int)N / powf(2, L);
    
    float * b_t   = (float *)malloc(sizeof(float) * n);
    float * phi_b = (float *)malloc(sizeof(float) * n);
    float * phi_b_w = (float *)malloc(sizeof(float) * n);
    float * x_nk = (float *)malloc(sizeof(float) * n);
    float * x_k = (float *)malloc(sizeof(float) * n);
    float * x = (float *)malloc(sizeof(float) * n);
    
    float t_k;
    float t_nk;
    float t;
    
    int lenA = 16;

    // a need to be passed in
    int * A = (int *)malloc(sizeof(int) * n);
    int j = 0;
    for (i=0; i<N*N; i++) {
        if (rand() < 0.5) {
            A[j] = i;
            j++;
        }
    }
    lenA = j;

    // precalculating b_t
    for (i=0; i<lenA; i++) {
        phi_b[A[i]] = y[A[i]];
    }
    [self.dwt waveletOn2DArray:phi_b ofWidth:N andHeight:N];
    b_t = [self.dwt vec:phi_b toX:N/powf(2.0, level*1.0) toY:N/powf(2.0, level*1.0) width:N height:N];
    
    // TODO: to delete
    iter = 20;
    for (k=0; k<iter; k++) {
        /*x_nk = pL(y, A, b_t, lam, L, N, Level);
        
        x_k  = x;
        t_k = t;
        
        % calculate step sizes
        t_nk = 0.5*(1 + sqrt((1 + 4*t_k^2)));
        y = x_nk + ((t_k -1)/(t_nk))*(x_nk - x_k);
        
        x = x_nk;
        t = t_nk;*/
        x_nk = [self pL_y:y A:A lenA:lenA b_t:b_t lam:lam L:lam N:N level:level];
        
        for (i=0; i<n; i++) { x_k[i] = xold[i]; }
        
        t_k = tn;
        t_nk = 0.5 * (1+sqrtf(1 + 4* t_k * t_k));
        
        for (i=0; i<n; i++) { y[i] = x_nk[i] + ((t_k-1)/(t_nk)) * (x_nk[i] - x_k[i]); }
        
        for (i=0; i<n; i++) { x[i] = x_nk[i]; }
        t = t_nk;
    }


    
    return tn;
    
    
}

-(float *)pL_y:(float *)y A:(int *)A lenA:(int)lenA b_t:(float *)b_t lam:(float)lam L:(float) L N:(int) N level:(int)level{
    /* adapted from the following matlab code:
            n  = N^2;
            n1 = n/2^(2*Level);

            %
            Y  = reshape(y, [sqrt(n1), sqrt(n1)]);
            Yt = zeros(sqrt(n), sqrt(n));
            Yt(1:sqrt(n1), 1:sqrt(n1)) = Y;
            y1 = vec(midwt(Yt, daubcqf(2, 'min')));
            
            
            Phi_y    = zeros(n,1);
            Phi_y(A) = y1(A);
            Phi_y_W  = mdwt(reshape(Phi_y, [sqrt(n) sqrt(n)]), daubcqf(2, 'min'));
            y_t = vec(Phi_y_W(1:sqrt(n)/2^Level, 1:sqrt(n)/2^Level));
            
            
            % calculating the gradiend step
            temp_x = y - 2/L*(y_t - b_t);
            
            % thresholding
            temp_1 = (abs(temp_x) - lam/L);
            temp_1(temp_1 < 0) = 0;
            
            xk = temp_1 .* sign(temp_x);
     */

    int n = powf(N, 2);
    int n1 = n / powf(2.0, 2*level);
    int i;
    int xx, yy;
    int width = (int)sqrtf(N);
    int widthy = (int)sqrtf(n1);
    
    float * Yt = (float *)malloc(sizeof(float) * n);
    float * y1 = (float *)malloc(sizeof(float) * N * N);
    float * phi_y = (float *)malloc(sizeof(float) * n);
    float * phi_y_w = (float *)malloc(sizeof(float) * n);
    float * y_t = (float *)malloc(sizeof(float) * (int)(n / (powf(2, 2*level))));
    float * temp_x = (float *)malloc(sizeof(float) * (int)(n / powf(2, 2*level)));
    float * xk = (float *)malloc(sizeof(float) * n);
    float * temp1 = (float *)malloc(sizeof(float) * n);
    
    for (xx=0; xx<sqrtf(n1); xx++) {
        for (yy=0; yy<sqrtf(n1); yy++) {
            Yt[width * yy + xx] = y[yy * widthy + xx];
        }
    }
    
    Yt = [self.dwt inverseOn2DArray:Yt ofWidth:N andHeight:N];
    y1 = [self.dwt vec:Yt width:N height:N];
    
    for (i=0; i<lenA; i++) {
        phi_y[A[i]] = y1[A[i]];
    }
    
    phi_y = [self.dwt trans:y width:(int)sqrtf(n) height:(int)sqrtf(n)];
    phi_y_w = [self.dwt waveletOn2DArray:phi_y ofWidth:(int)sqrtf(n) andHeight:(int)sqrtf(n)];
    
    y_t = [self.dwt vec:phi_y_w width:(int)(sqrtf(n)/powf(2, level)) height:(int)(sqrtf(n)/powf(2, level))];
    
    // calculate the gradient step
    for (i=0; i<n/powf(2, 2*level); i++) {
        temp_x[i] = y[i] - (2/(L*1.0)) * (y_t[i] - b_t[i]);
    }
    
    // thresholding
    for (i=0; i<n/powf(2, 2*level); i++) {
        temp1[i] = fabsf(temp_x[i]) - lam/(L*1.0);
        if (temp1[i] < 0) temp1[i] = 0;
        xk[i] = temp1[i] * [self.dwt sign:temp_x[i]];
    }
    
    return xk;
}

// functions to sample the image for the initial viewing.
-(float *)sample:(float *)array atRate:(float)rate ofLength:(int)n
{
    srandom(42);
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
    int n, i;
    float * colorPlane = (float *)malloc(sizeof(float) * pix);
    float * array = (float *)malloc(sizeof(float) * pix * 4);
    array = [self.dwt UIImageToRawArray:image];
    srandom(42);
    for (n=0; n<3; n++) {

        colorPlane = [self.dwt getColorPlane:array ofArea:pix startingIndex:n into:colorPlane];

        
        colorPlane = [self sample:colorPlane atRate:rate ofLength:pix];
        for ( i=0; i<10; i++) {
        }

        //colorPlane = [self normalize:colorPlane ofLength:area max:&max min:&min];
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
    srandom(42); srand(42); // 'srand' works
    for (i=0; i<pix; i++) {
        int index = random() % pix;
        [idx exchangeObjectAtIndex:i withObjectAtIndex:index];
    }
   // NSLog(@"-----------");
    for (i=0; i<5; i++) {
       // NSLog(@"%@", [idx objectAtIndex:i]);

    }
    
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

// another init. to view while you're setting the largest k terms.
-(UIImage *)doWaveletKeepingLargestKTerms:(UIImage *)image coarse:(float)coarse
{
    int area = image.size.height * image.size.width;
    float width = image.size.width;
    float height = image.size.height;
    float * array = (float *)malloc(sizeof(float) * area);
    float * colorPlane = (float *)malloc(sizeof(float) * area);
    int order = (int)log2(image.size.width);
    NSLog(@"%f", coarse);
    
    // get data
    array = [self.dwt UIImageToRawArray:image];
    int  i;
    //float max, min;
    // end making raw array
    // begin the wavelet part
    
    // perform wavelet, 2D on image
    // using color planes, all of that
    for (int n=0; n<3; n++) {
        
        colorPlane = [self.dwt getColorPlane:array ofArea:area startingIndex:n into:colorPlane];
        
        colorPlane = [self.dwt waveletOn2DArray:colorPlane ofWidth:width andHeight:height ofOrder:order divide:@"null"]; // change from null to image if want /2
        
        float cut_off = coarse * 26.25;
        for (i=0; i<area; i++) {
            if (abs(colorPlane[i]) < cut_off) {
                colorPlane[i] = 0;
            }
        }
        
        colorPlane = [self.dwt inverseOn2DArray:colorPlane ofWidth:width andHeight:height ofOrder:order multiply:@"null"];
        
        array      = [self.dwt putColorPlaneBackIn:colorPlane into:array ofArea:area startingIndex:n];
    }
    for (i=0; i<4*area; i=i+4) {
        //NSLog(@"array[%d] = %f", i, array[i]);
    }
    
    
    for (long i=3; i<4*area; i=i+4)
    {array[i] = 255;}
    image = [self.dwt UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
    free(array); free(colorPlane);
    
    return image;
}

// the actual IST
-(float)IST:(float *)signal ofLength:(int)N
    ofWidth:(int)width ofHeight:(int)height order:(int)order
  iteration:(int)iter
     atRate:(float)p
       xold:(float *)xold xold1:(float *)xold1
          y:(float *)y
        idx:(NSMutableArray *)idx coarse:(float)coarse numberOfPastIterations:(int)pastIts
         tn:(float)tn
{
    // the function performs the "fast iterative soft thresholding algorithm (FISTA)". This is the meat of the code -- this is where your actual algorithm implementation goes. The rest is just (complicated) wrapper for this.
    float * t1 = (float *)malloc(sizeof(float) * N);
    float * temp = (float *)malloc(sizeof(float) * N);
    float * temp2 = (float *)malloc(sizeof(float) * N);
    float * temp3 = (float *)malloc(sizeof(float) * N);
    float * temp4 = (float *)malloc(sizeof(float) * N);
    float * tt = (float *)malloc(sizeof(float) * N);
    // allocations for T(.)
    float tn1;
    int i, index;
    
    // l for lambda. our threshold for setting everything below this to 0.
    float l = 15;
    for (int its=0; its<iter; its++) {
        tn1 = (1+sqrt(1+4*tn*tn))/2;
        // tn1 = tn_{k+1}. computing the tn
        
        // xold1 = xold_{k-1}
        // "calling" T(.) with a new xold
        for (i=0; i<N; i++)
        {xold[i] = xold[i] + ((tn - 1.0)/tn1) * (xold[i] - xold1[i]);} // check
        
        // implementing T(.) (could be a function)
        for (i=0; i<N; i++) {t1[i] = xold[i];}
        
        t1 = [self.dwt inverseOn2DArray:t1 ofWidth:width andHeight:height ofOrder:order multiply:@"null"];
        
        //          temp = t1(rp(1:floor(p*n)));
        for (i=0; i<p*N; i++) {
            index = [[idx objectAtIndex:i] intValue];
            temp[i] = t1[index];}
        
        
        //         temp2 = y-temp;
        for (i=0; i<p*N; i++) {
            temp2[i] = y[i] - temp[i];}
        
        
        //          temp3 = zeros(size(I3));
        for (i=0; i<N; i++) {
            temp3[i] = 0;}
        //          temp3(rp(1:floor(p*n))) = temp2;
        for (i=0; i<p*N; i++) {
            index = [[idx objectAtIndex:i] intValue];
            temp3[index] = temp2[i];}
        
        
        //          temp3 = dwt2_full(temp3);
        temp3 = [self.dwt waveletOn2DArray:temp3 ofWidth:width andHeight:height ofOrder:order divide:@"null"];
        
        
        //          temp4 = xold + temp3;
        for (i=0; i<N; i++) {
            //temp4[i] = xold[i] + temp3[i];
            temp4[i] = xold[i] + temp3[i];
        }
        for (i=0; i<N; i++) {
            //temp4[i] = xold[i] + temp3[i];
            xold[i] = temp4[i]; // probably unnecassary
        }
        // the end of T(.)
        
        // use iterative soft thresholding
        // look at each value, and see if abs() is less than l
        for (i=0; i<N; i++) {
            if (abs(xold[i]) < l) {
                xold[i] = 0;
            } else xold[i] = xold[i] - copysignf(1, xold[i]) * l;
        }
        
        // updating the past iteration
        for (i=0; i<N; i++) {
            xold1[i] = xold[i];
            xold[i] = xold[i]; // not nesecarry...
            // updating xold_{n-1} = xold_n            
        }
        // updating the tn
        tn = tn1;
        // updating tn = tn_{n+1}
    }
    
    free(temp);
    free(temp2);
    free(temp4);
    free(temp3);
    free(tt);
    free(t1);
    return tn;
    
    
}

// used in IST; it's called with a varying step size each time.
// not called: had to figure out a bug and didn't use it
-(float *)T:(float *)xold width:(int)width height:(int)height order:(int)order
    // an unused, hence untested, function.
          y:(float *)y
        idx:(NSMutableArray *)idx
{
    // changed from "return xnew" to "return xold" to squash a bug-error. I don't think it matters because the return value isn't used.
    int i=0;
    int index;
    int n=width*height;
    float * temp  = (float *)malloc(sizeof(float) * n);
    float * temp1 = (float *)malloc(sizeof(float) * n);
    float * temp2 = (float *)malloc(sizeof(float) * n);
    float * temp3 = (float *)malloc(sizeof(float) * n);
    float * temp4 = (float *)malloc(sizeof(float) * n);
    //float * xnew = (float *)malloc(sizeof(float) * n);
    temp1 = [self.dwt inverseOn2DArray:xold ofWidth:width andHeight:height ofOrder:order multiply:@"null"];
    for (i=0; i<[idx count]; i++) {
        index = [[idx objectAtIndex:i] intValue];
        temp[i] = temp1[index];
    }
    for (i=0; i<[idx count]; i++) {
        //index = [[idx objectAtIndex:i] intValue];
        temp2[i] = y[i] - temp[i];
    }
    for (i=0; i<n; i++) {
        temp3[i] = 0;
    }
    for (i=0; i<[idx count]; i++) {
        index = [[idx objectAtIndex:i] intValue];
        temp3[index] = temp2[i];
    }
    [self.dwt waveletOn2DArray:temp3 ofWidth:width andHeight:height ofOrder:order divide:@"null"];
    for (i=0; i<n; i++) {
        //index = [[idx objectAtIndex:i] intValue];
        temp4[i] = xold[i] + temp3[i];
    }
    for (i=0; i<n; i++) {
        //xnew[i] = temp4[i];
        xold[i] = temp4[i];
    }
    free(temp);
    free(temp1);
    free(temp2);
    free(temp3);
    free(temp4);
    return xold;
}

// and the function that takes in a UIImage and performs the IST.
-(UIImage *)reconstructWithIST:(UIImage *)image
                  coarse:(float)coarse
                     idx:(NSMutableArray *)idx
                     y_r:(float *)y_r y_g:(float *)y_g y_b:(float *)y_b
                    rate:(float)rate
                  xold_r:(float *)xold_r xold1_r:(float *)xold1_r
                  xold_g:(float *)xold_g xold1_g:(float *)xold1_g
                  xold_b:(float *)xold_b xold1_b:(float *)xold1_b
              iterations:(int)its pastIterations:(int)pastIts tn:(float *)tn
{
    static int logPastIts=0;
    logPastIts++;
    NSLog(@"%d", logPastIts);
    // We need no image-to-array function, as the arrays are held in the view controller.
    int height = image.size.height;
    int width = image.size.width;
    int order = log2(width);
    int pix = height * width;
    
    
    // get data
    //    array = [self.dwt UIImageToRawArray:image];
    int i, n;
    //float max, min;
    // end making raw array
    // begin the wavelet part
    
    // perform wavelet, 2D on image
    // using color planes, all of that
    if (width < 256){
        //NSLog(@"returned a small image");
        image = [UIImage imageNamed:@"one.jpg"];
        //NSLog(@"%@", image);
        return image;
    } else{
        float * array = (float *)malloc(sizeof(float) * pix * 4);
        float * colorPlane = (float *)malloc(sizeof(float) * pix);
        float * xold = (float *)malloc(sizeof(float) * pix);
        float * xold1 = (float *)malloc(sizeof(float) * pix);
        float * y = (float *)malloc(sizeof(float) * pix);
        float tnf = *tn;
        
        for (n=0; n<3; n++) {
            
            
            // properly init
            if (n==0) {
                for (i=0; i<rate*pix; i++) {y[i]    = y_r[i];}
                for (i=0; i<pix;      i++) {xold[i] = xold_r[i];}
                for (i=0; i<pix;      i++) {xold1[i] = xold1_r[i];}
            } else  if (n==1) {
                for (i=0; i<rate*pix; i++) {y[i]    = y_g[i];}
                for (i=0; i<pix;      i++) {xold[i] = xold_g[i];}
                for (i=0; i<pix;      i++) {xold1[i] = xold1_g[i];}

            } else if (n==2) {
                for (i=0; i<rate*pix; i++) {y[i]    = y_b[i]; }
                for (i=0; i<pix;      i++) {xold[i] = xold_b[i];}
                for (i=0; i<pix;      i++) {xold1[i] = xold1_b[i];}

            }
            
            // the do-what-you-want code should go here. actually performing the algorithm.
//            tnf = [self FISTA_W:xold ofLength:pix ofWidth:width ofHeight:height
//                     order:order iteration:its atRate:rate
//                      xold:xold xold1:xold1 y:y idx:idx
//                    coarse:coarse numberOfPastIterations:0 tn:tnf];
            tnf = [self IST:xold ofLength:pix ofWidth:width ofHeight:height
                          order:order iteration:its atRate:rate
                           xold:xold xold1:xold1 y:y idx:idx
                         coarse:coarse numberOfPastIterations:0 tn:tnf];
            
            // and then update
            if (n==0) {
                for (i=0; i<rate*pix; i++) {y_r[i]    = y[i];}
                for (i=0; i<pix;      i++) {xold_r[i] = xold[i];}
                for (i=0; i<pix;      i++) {xold1_r[i] = xold1[i];}
            } else if (n==1) {
                for (i=0; i<rate*pix; i++) {y_g[i]    = y[i];}
                for (i=0; i<pix;      i++) {xold_g[i] = xold[i];}
                for (i=0; i<pix;      i++) {xold1_g[i] = xold1[i];}

            } else if (n==2) {
                for (i=0; i<rate*pix; i++) {y_b[i]    = y[i];}
                for (i=0; i<pix;      i++) {xold_b[i] = xold[i];}
                for (i=0; i<pix;      i++) {xold1_b[i] = xold1[i];}

            }
            
            // end of do what you want
            [self.dwt inverseOn2DArray:xold ofWidth:width andHeight:height ofOrder:order multiply:@"null"];
            
            array      = [self.dwt putColorPlaneBackIn:xold into:array ofArea:pix startingIndex:n];
        }
        *tn = tnf;
        
        image = [self.dwt UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
        
        
        free(array);
        free(colorPlane);
        free(y);
        free(xold);
        free(xold1);
        return image;
    }
    
}

-(UIImage *)reconstructWithFISTA:(UIImage *)image
                          Xhat_r:(float *)Xhat_r Xhat_g:(float *)Xhat_g Xhat_b:(float *)Xhat_b
                         samples:(int *)samples
                             y_r:(float *)y_r y_g:(float *)y_g y_b:(float *)y_b
                            y2_r:(float *)y2_r y2_g:(float *)y2_g y2_b:(float *)y2_b
                             x_r:(float *)x_r x_g:(float *)x_g x_b:(float *)x_b
                           b_t_r:(float *)b_t_r  b_t_g:(float *)b_t_g  b_t_b:(float *)b_t_b
                             t_r:(float *)t_r t_g:(float *)t_g t_b:(float *)t_b
                               M:(int)M N:(int)N k:(int)k m:(int)m
{
    // t = FISTA_W(Xhat, samples, y, y2, x, b_t, t, M, N, 1, m);

    // we need no image-to-array function, as the arrays are held in the view controller.
    int height = image.size.height;
    int width = image.size.width;
    int order = log2(width);
    int pix = height * width;
    int i, n;
    float * array = (float *)malloc(sizeof(float) * 4 * N * N);


    if (width < 256){
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
                for (i=0; i<m; i++) {y[i]    = y_r[i];}
                for (i=0; i<N*N; i++) {Xhat[i] = Xhat_r[i];}
                for (i=0; i<M*M; i++) {y2[i] = y2_r[i];}
                for (i=0; i<M*M; i++) {x[i] = x_r[i];}
                for (i=0; i<M*M; i++) {b_t[i] = b_t_r[i];}
                tf = trf_r;
            } else  if (n==1) {
                for (i=0; i<m; i++) {y[i]    = y_g[i];}
                for (i=0; i<N*N; i++) {Xhat[i] = Xhat_g[i];}
                for (i=0; i<M*M; i++) {y2[i] = y2_g[i];}
                for (i=0; i<M*M; i++) {x[i] = x_g[i];}
                for (i=0; i<M*M; i++) {b_t[i] = b_t_g[i];}
                tf = trf_g;
            } else if (n==2) {
                for (i=0; i<m; i++) {y[i]    = y_b[i];}
                for (i=0; i<N*N; i++) {Xhat[i] = Xhat_b[i];}
                for (i=0; i<M*M; i++) {y2[i] = y2_b[i];}
                for (i=0; i<M*M; i++) {x[i] = x_b[i];}
                for (i=0; i<M*M; i++) {b_t[i] = b_t_b[i];}
                tf = trf_b;
            }
            //NSLog(@"in reconstructWithFista: %f", tf);
            // the do-what-you-want code should go here. actually performing the algorithm.
            tf = FISTA_W(Xhat, samples, y, y2, x, b_t, tf, M, N, 1, m);
            // and then update
            if (n==0) {
                for (i=0; i<m; i++) {y_r[i]    = y[i];}
                for (i=0; i<N*N; i++) {Xhat_r[i] = Xhat[i];}
                for (i=0; i<M*M; i++) {y2_r[i] = y2[i];}
                for (i=0; i<M*M; i++) {x_r[i] = x[i];}
                for (i=0; i<M*M; i++) {b_t_r[i] = b_t[i];}
                trf_r = tf;
            } else if (n==1) {
                for (i=0; i<m; i++) {y_g[i]    = y[i];}
                for (i=0; i<N*N; i++) {Xhat_g[i] = Xhat[i];}
                for (i=0; i<M*M; i++) {y2_g[i] = y2[i];}
                for (i=0; i<M*M; i++) {x_g[i] = x[i];}
                for (i=0; i<M*M; i++) {b_t_g[i] = b_t[i];}
                trf_g = tf;
            } else if (n==2) {
                for (i=0; i<m; i++) {y_b[i]    = y[i];}
                for (i=0; i<N*N; i++) {Xhat_b[i] = Xhat[i];}
                for (i=0; i<M*M; i++) {y2_b[i] = y2[i];}
                for (i=0; i<M*M; i++) {x_b[i] = x[i];}
                for (i=0; i<M*M; i++) {b_t_b[i] = b_t[i];}
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
              float t, int M, int N, int k, int m){
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
        
        // for some reason, the energy in my signal keeps growing.
        // it *looks* like pL is working... the first iteration prints
        //      approximately correct
        x_nk = pL(y, A, b_t, N, m);
        NSLog(@"::::: %d", A[4]);
        
        // do we have to copy it over? before the pL call?
        copy(x, x_k, M*M);
        t_k = t;
        t_nk = 0.5*(1 + sqrt((1 + 4 * t_k * t_k)));
        

        for (i=0; i<M*M; i++){
            y[i] = x_nk[i] + ((t_k -1)/(t_nk))*(x_nk[i] - x_k[i]);
        }
        
        copy(x_nk, x, M*M);
        t = t_nk;
        //NSLog(@"FISTA_W: %f", t);
        
    }
    
    /*float * Xhat = (float *)malloc(sizeof(float) * N * N);*/
    float * The1 = (float *)malloc(sizeof(float) * N * N);
    float * Temp1 = (float *)malloc(sizeof(float) * N * N);
    /*for (i=0; i<N*N; i++) Xhat[i] = 0;*/
    
    for (i=0; i<M*M; i++) The1[i] = x[i];
    vec(The1, M, M);
    
    for (i=0; i<N*N; i++) Temp1[i] = 0;
    for (xx=0; xx<M; xx++){
        for (yy=0; yy<M; yy++){
            Temp1[yy*N + xx] = The1[yy*M + xx];
        }
    }
    
    for (i=0; i<N*N; i++) Xhat[i] = Temp1[i];

    return t;
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
@end
