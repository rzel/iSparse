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
 * IMAGE_STEP.
 *
 * --Scott Sievert, sieve121 at umn.edu, 2013-09-17
 *
 */

#import "UROPFinalViewController.h"
#import "UROPbrain.h"
#import <QuartzCore/QuartzCore.h>

// change this to change the algorithm!
#define IMAGE_STEP\
       self.imageView.image = [self.brain reconstructWithIST:self.imageView.image \
                                                    coarse:self.coarse idx:idx    \
                                                    y_r:y_r y_g:y_g y_b:y_b       \
                                                    rate:rate                     \
                                                    xold_r:xold_r xold1_r:xold1_r \
                                                    xold_g:xold_g xold1_g:xold1_g \
                                                    xold_b:xold_b xold1_b:xold1_b \
                                                    iterations:1 pastIterations:0 \
                                                    tn:(float *)&tn];
// updates the text that says "Iterations: 42"
#define ITERATION_STEP \
       showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts];

#define ANIMATION_COMMAND     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState \
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
    [super viewDidLoad];    
 
    int i;
    
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];
    
    float rate = self.rate;
    float pix = self.imageStay.size.width * self.imageStay.size.height;
    
    // our variables for measurement/reconstructing.
    // y_ holds the measurements for that color plane
    float * y_r = (float *)malloc(sizeof(float) * pix * rate * 1.1);
    float * y_g = (float *)malloc(sizeof(float) * pix * rate * 1.1);
    float * y_b = (float *)malloc(sizeof(float) * pix * rate * 1.1);
    
    // xold_ holds the wavelet transform for that color plane
    float * xold_r = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold_g = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold_b = (float *)malloc(sizeof(float) * pix * 1.1);
    
    // xold_{n-1}. the previous iteration of xold
    float * xold1_r = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold1_g = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold1_b = (float *)malloc(sizeof(float) * pix * 1.1);
    
    // our threshold value.
    float tn = 1;

    // the indicies where we want to sample
    NSMutableArray * idx = [[NSMutableArray alloc] init];
    [self.brain makeIDX:idx ofLength:pix];
    
    // goes into y_r, y_g, y_b
    [self.brain makeMeasurements:self.imageStay atRate:self.rate 
                             red:y_r green:y_g blue:y_b 
                        ofLength:pix idx:idx];
    
    // ensuring they're all zeros.
    for (i=0; i<pix; i++) {
        xold_r[i] = 0;
        xold_g[i] = 0;
        xold_b[i] = 0;
        
        xold1_r[i] = 0;
        xold1_g[i] = 0;
        xold1_b[i] = 0;
    }
    
    
    // making those global variables the same. for the animation.
    self.idx = idx; self.xold_g = xold_g;
    self.xold_b = xold_b; self.xold_r = xold_r;
    self.y_r = y_r; self.y_g = y_g; self.y_b = y_b;
    self.finished = NO;
    

    
    // the start of the animation. You shouldn't have to touch anything below here; 
    // it's all taken care of in IMAGE_STEP.
    // everything critical is in #defines: N_MIN, ITERATION_STEP, IMAGE_STEP
    static int showIts = 0;
    self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts];
    ANIMATION_COMMAND{
                         showIts=0;
                         ITERATION_STEP
                         IMAGE_STEP;
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP;
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP;
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP;
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    }}];
    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP

                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{

    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     FINISHED_IF{
    ANIMATION_COMMAND{
                         ITERATION_STEP
                         IMAGE_STEP
                     }
                     completion:^(BOOL finished){
                         if (self.imageView.image.size.width >= N_MIN){
                             
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
    }}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
