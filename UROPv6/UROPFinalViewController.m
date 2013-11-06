/*
 * made by    : SparKEL Lab
 * at the     : University of Minnesota
 * advisor    : Dr. Jarvis Haupt
 * programmer : Scott Sievert
 *
 * Copyright (c) 2013 by Scott Sievert. All rights reserved.
 *
 *
 * This is the final screen of this app. It shows the image being
 * reconstructed step by step -- an animation. To do this, it goes through some
 * init'ing first, then the beast of an animation.
 *
 * I tried making this animation shorter in terms of lines-of-code. I tried
 * using a for-loop, but iOS waits until the last image in the for loop has
 * been reached. After searching long and hard, I found another code snippet to
 * have an animation where I didn't know the end state. This code is nested,
 * meaning I can't use a for-loop. I could use recursion, but that idea was
 * suggested to me much later and this is good enough, becuase I now have
 * IMAGE_STEP.
 *
 * To change what each frame of the animation looks like, change IMAGE_STEP.
 * You should have a self.imageView.iamge = [functions that returns UIImage].
 *
 * You shouldn't have to touch anything below line 140 or so -- that's where
 * the animation starts. Anything in there will be taken care of with
 * IMAGE_STEP and other #defines.
 *
 * --Scott Sievert, sieve121 at umn.edu, 2013-09-17
 *
 */

#import "UROPFinalViewController.h"
#import "UROPbrain.h"
#import <QuartzCore/QuartzCore.h>
#include "dwt.h"
#include "nice.h"

// change this to change the algorithm!
#define IMAGE_STEP                                                           \
self.imageView.image = [self.brain reconstructWithFISTA:self.imageView.image \
                        Xhat_r:Xhat_r Xhat_g:Xhat_g Xhat_b:Xhat_b            \
                        samples:samples                                      \
                         y_r:y_r     y_g:y_g     y_b:y_b                     \
                        y2_r:y2_r   y2_g:y2_g   y2_b:y2_b                    \
                         x_r:x_r     x_g:x_g     x_b:x_b                     \
                       b_t_r:b_t_r b_t_g:b_t_g b_t_b:b_t_b                   \
                         t_r:&t_r    t_g:&t_g    t_b:&t_b                    \
                           M:M N:N k:2 m:m levels:self.levels];

// updates the text that says "Iterations: 42"
#define ITERATION_STEP \
       showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d / 30", showIts]; NSLog(@"iteration %d", showIts);

#define ANIMATION_COMMAND     [UIView animateWithDuration:0.0 delay:0.0 \
                                    options:UIViewAnimationOptionBeginFromCurrentState \
                                               animations:^(void)

#define FINISHED_IF completion:^(BOOL finished){ \
                        if (self.imageView.image.size.width >= N_MIN)

// should the animation continue?
#define IF_STATEMENT self.imageView.image.size.width >= N_MIN


// the minimum N for the animation to continue.
#define N_MIN 256

// what size should the image be when we stop the animation?
#define N_STOP 64

@interface UROPFinalViewController ()
@property (nonatomic, strong) UROPbrain *brain;
@end

@implementation UROPFinalViewController
@synthesize brain = _brain;

// scaling a UIImage to a CGSize
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// how should we stop the animation?
-(void)stopAmination{
    int n = N_STOP;
    // n must be less than 256
    UIImage * image = [self imageWithImage:self.imageView.image scaledToSize:CGSizeMake(n, n)];
    self.imageView.image = image;
}

// init'ing the brain
-(UROPbrain *)brain
{
    if (!_brain) _brain = [[UROPbrain alloc] init];
    return _brain;
}

// good-bye
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self performSelectorOnMainThread:@selector(stopAmination) withObject:nil waitUntilDone:YES];
}

// when the screen pops up
- (void)viewDidLoad
{
    // TODO: make samples out of idx
    // TODO: N vs. sqrt(N)
    [super viewDidLoad];    
    int i;
    
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];
    
    [self animateFISTA];


}

-(void)animateFISTA{
    /* Use this to time stuff:
     tic = [NSDate date];
     NSTimeInterval toc = [tic timeIntervalSinceNow];
     NSLog(@"Time: %f", toc);
     
     */
    // it's getRGBAsFromImage that slows this down (go figure)
    

    NSDate * tic = [NSDate date];
    int i;
    float rate = self.rate;
    float pix = self.imageStay.size.width * self.imageStay.size.height;
    int N = (int)sqrtf(pix);
    
    int m = (int)floorf(rate * N * N);
    int J = log2(N);
    
    // how many levels do we want to keep?
    int L = self.levels;
    int M = powf(2, J-L);
    // the indicies where we want to sample
    //int * samples1 = (int *)malloc(sizeof(int) * N*N);
    int * samples = (int *)malloc(sizeof(int) * N*N);
    
    //makeIDX(samples1, N*N); //  there's a bug in here
    NSMutableArray * idx = [[NSMutableArray alloc] init];
    [self.brain makeIDX:idx ofLength:pix];
    
    // FOR LOOP
    srand(42);
    for (i=0; i<N*N; i++) {
        samples[i] = [[idx objectAtIndex:i] integerValue];
    }
    // samples[i] takes about 36% of the total time
    float * x_r = (float *)malloc(sizeof(float) * N*N);
    float * x_g = (float *)malloc(sizeof(float) *  N*N);
    float * x_b = (float *)malloc(sizeof(float) *  N*N);
    
    float * y_r = (float *)malloc(sizeof(float) * N*N);
    float * y_g = (float *)malloc(sizeof(float) *  N*N);
    float * y_b = (float *)malloc(sizeof(float) *  N*N);
    
    float * Xhat_r = (float *)malloc(sizeof(float) * N * N);
    float * Xhat_g = (float *)malloc(sizeof(float) * N * N);
    float * Xhat_b = (float *)malloc(sizeof(float) * N * N);
    
    float * y2_r = (float *)malloc(sizeof(float) * N * N);
    float * y2_g = (float *)malloc(sizeof(float) * N * N);
    float * y2_b = (float *)malloc(sizeof(float) * N * N);
    
    float * phi_b_r = (float *)malloc(sizeof(float) * N * N);
    float * phi_b_g = (float *)malloc(sizeof(float) * N * N);
    float * phi_b_b = (float *)malloc(sizeof(float) * N * N);
    
    float * b_t_r = (float *)malloc(sizeof(float) * M * M);
    float * b_t_g = (float *)malloc(sizeof(float) * M * M);
    float * b_t_b = (float *)malloc(sizeof(float) * M * M);
    
    float * b_t_r_pre = (float *)malloc(sizeof(float) * M * M);
    float * b_t_g_pre = (float *)malloc(sizeof(float) * M * M);
    float * b_t_b_pre = (float *)malloc(sizeof(float) * M * M);
    
    // FOR LOOP
    // makeMeasurements takes about 50% of the total time
    // vDSP_vgathr!! is equivalent to a[b[i]]
    [self.brain makeMeasurements2:self.imageStay atRate:self.rate
                             red:y_r green:y_g blue:y_b
                        ofLength:pix idx:samples];


    
    
    value(phi_b_r, N*N, 0);
    value(phi_b_g, N*N, 0);
    value(phi_b_b, N*N, 0);
    
    // FOR LOOP

    for (i=0; i<m; i++) {
        phi_b_r[samples[i]] = y_r[i];
        phi_b_g[samples[i]] = y_g[i];
        phi_b_b[samples[i]] = y_b[i];
    }


    // overwrites phi_b
    dwt2_full(phi_b_r, N, N);
    dwt2_full(phi_b_g, N, N);
    dwt2_full(phi_b_b, N, N);
    vec(phi_b_r, N, N);
    vec(phi_b_g, N, N);
    vec(phi_b_b, N, N);
    // reshaping
    
    // FOR LOOP
    // here takes about 14% of the total time
    vecQuad(phi_b_r, M, M, N, N, b_t_r_pre);
    vecQuad(phi_b_g, M, M, N, N, b_t_g_pre);
    vecQuad(phi_b_b, M, M, N, N, b_t_b_pre);
    
    
    // vec (just a transpose since C)
    vDSP_mtrans(b_t_r_pre, 1, b_t_r, 1, M, M);
    vDSP_mtrans(b_t_g_pre, 1, b_t_g, 1, M, M);
    vDSP_mtrans(b_t_b_pre, 1, b_t_b, 1, M, M);
    // ------------------------ done calculating b_t
    
    // ensuring all 0's
    value(Xhat_r, N*N, 0);
    value(Xhat_g, N*N, 0);
    value(Xhat_b, N*N, 0);
    value(y2_r, N*N, 0);
    value(y2_g, N*N, 0);
    value(y2_b, N*N, 0);
    value(y_r, N*N, 0);
    value(y_g, N*N, 0);
    value(y_b, N*N, 0);
    
    
    // the thresholds. __block required for ANIMATION_COMMAND
    __block float t_r = 1.0;
    __block float t_g = 1.0;
    __block float t_b = 1.0;

    // the start of the animation. You shouldn't have to touch anything below here;
    // it's all taken care of in IMAGE_STEP.
    // everything critical is in #defines: N_MIN, ITERATION_STEP, IMAGE_STEP
    
    //free(x_r);
    //free(y_r);
    //free(Xhat_r);
    //free(y2_r);
    //free(b_t_r);
    // we need to free these in the return. use free(self.x_r);
    
    free(phi_b_r);
    free(phi_b_g);
    free(phi_b_b);
    
    free(b_t_r_pre);
    free(b_t_g_pre);
    free(b_t_b_pre);
    
    static int showIts = 0;
    self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts];
    NSTimeInterval toc = [tic timeIntervalSinceNow];
    NSLog(@"Time: %f", 0-toc);
    
    // total time: ~1.5 --> 0.8

    ANIMATION_COMMAND{
        showIts=0;
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{

    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{

    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{
    ANIMATION_COMMAND{
        ITERATION_STEP;
        IMAGE_STEP;

        }
        FINISHED_IF{

    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];
    }}];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
