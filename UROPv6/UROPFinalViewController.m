//
//  UROPFinalViewController.m
//  UROPv6
//
//  Created by Scott Sievert on 2/18/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import "UROPFinalViewController.h"
#import "UROPbrain.h"
#import <QuartzCore/QuartzCore.h>
//#import "Animations_s/CPAnimationSequence.h"
//#import "Animations_s/CPAnimationStep.h"
//#import "Animations_s/CPAnimationProgram.h"

@interface UROPFinalViewController ()
@property (nonatomic, strong) UROPbrain *brain;

@end



@implementation UROPFinalViewController
@synthesize brain = _brain;

-(void)stopAmination
{
    //[self.view.layer removeAllAnimations];
    self.imageView = nil; // gives errors, but works
    
    //[self.imageView.layer removeAllAnimations];
    
}

-(UROPbrain *)brain
{
    if (!_brain) _brain = [[UROPbrain alloc] init];
    return _brain;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self performSelectorOnMainThread:@selector(stopAmination) withObject:nil waitUntilDone:YES];


}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    NSLog(@"here");
    
    
    
    int i;
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];
    float rate = self.rate;
    float pix = self.imageStay.size.width * self.imageStay.size.height;
    
    float * y_r = (float *)malloc(sizeof(float) * pix * rate * 1.1);
    float * y_g = (float *)malloc(sizeof(float) * pix * rate * 1.1);
    float * y_b = (float *)malloc(sizeof(float) * pix * rate * 1.1);
    
    
    float * xold_r = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold_g = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold_b = (float *)malloc(sizeof(float) * pix * 1.1);
    
    float * xold1_r = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold1_g = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold1_b = (float *)malloc(sizeof(float) * pix * 1.1);
    
    float tn = 1;

    
    NSMutableArray * idx = [[NSMutableArray alloc] init];
    [self.brain makeIDX:idx ofLength:pix];
    // makeIDX takes in ofLength:pix, not rate*pix. Why does it look good with rate*pix?
    // the matlab code --> randperm(pix)
    
    [self.brain makeMeasurements:self.imageStay atRate:self.rate red:y_r green:y_g blue:y_b ofLength:pix idx:idx];
    
    for (i=0; i<pix; i++) {
        // initial all zeros estimate
        xold_r[i] = 0;
        xold_g[i] = 0;
        xold_b[i] = 0;
        
        xold1_r[i] = 0;
        xold1_g[i] = 0;
        xold1_b[i] = 0;

    }
    
    self.idx = idx; self.xold_g = xold_g;
    self.xold_b = xold_b; self.xold_r = xold_r;
    self.y_r = y_r; self.y_g = y_g; self.y_b = y_b;
    self.finished = NO;
    
//    for (int i=0; i<1; i++) {
//        self.imageView.image =
//        [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
//                                   idx:idx
//                                   y_r:y_r y_g:y_g y_b:y_b
//                                  rate:rate
//                                xold_r:xold_r xold1_r:xold1_r
//                                xold_g:xold_g xold1_g:xold1_g
//                                xold_b:xold_b xold1_b:xold1_b
//                            iterations:100 pastIterations:0 tn:&tn];
//        NSLog(@"%d", i);
//        // finally! got the IST working. now for the animation code...
//    }

 

    // we want tn to change: we should pass a pointer in
    float r = 1;
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         self.imageView.image =
                         [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                    idx:idx
                                                    y_r:y_r y_g:y_g y_b:y_b
                                                   rate:rate
                                                 xold_r:xold_r xold1_r:xold1_r
                                                 xold_g:xold_g xold1_g:xold1_g
                                                 xold_b:xold_b xold1_b:xold1_b
                                             iterations:1 pastIterations:0 tn:&tn];

                     }
                     completion:^(BOOL finished){
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
     [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                      animations:^(void){
                          self.imageView.image =
                          [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
                                                     idx:idx
                                                     y_r:y_r y_g:y_g y_b:y_b
                                                    rate:rate
                                                  xold_r:xold_r xold1_r:xold1_r
                                                  xold_g:xold_g xold1_g:xold1_g
                                                  xold_b:xold_b xold1_b:xold1_b
                                              iterations:1 pastIterations:0 tn:&tn];
                          
                      }
                      completion:^(BOOL finished){
                          
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];
    }];


/*
    
//    [main_view release];
//    NSLog(@"rate = %f", self.rate);
//    NSLog(@"coarse = %f", self.coarse);
//    
//    // image set up properly
    self.imageView.image = self.imageStay;
    //self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];
    //NSLog(@"%f", self.rate);
    //NSLog(@"%@", self.imageStay);
    //NSLog(@"%@", self.imageView.image);
    // no user-selected image: 0xf6... 0x715...
    // user-selected image:    0xf7... 0x11d
    // user-sel., largestKTerms0xf6822 0xf6c2
//    UIImage *image1 = [UIImage imageNamed:@"ted.jpg"];
//    UIImage *image2 = [UIImage imageNamed:@"mountain.jpg"];
//    self.imageView.animationImages = [NSArray arrayWithObjects:image1, image2, nil];
//    self.imageView.animationDuration = 6.00;
//    self.imageView.animationRepeatCount = 100;
//    [self.imageView startAnimating];
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
//    [self.scrollView setMaximumZoomScale:2.0];
////    self.scrollView.scrollEnabled = YES;
////    self.scrollView.pagingEnabled = YES;
//    [self.scrollView addSubview:self.imageView];
//    self.scrollView.delegate = self;
//    self.scrollView.scrollEnabled = YES;
//    self.scrollView.maximumZoomScale = 4.0;
//    self.scrollView.minimumZoomScale = 1.0;
    

    
    
    //NSLog(@"rate = %f", self.rate);
    //NSLog(@"coarse = %f", self.coarse);
    // [NSThread sleepForTimeInterval:1.0];
    
    // image set up properly
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];

    float rate = self.rate;
    float pix = self.imageStay.size.width * self.imageStay.size.height;
//    float coarseness = self.coarse;
    NSMutableArray * idx = [[NSMutableArray alloc] initWithCapacity:pix];
    // init xold
    float * xold_r = (float *)malloc(sizeof(float) * pix);
    float * xold_g = (float *)malloc(sizeof(float) * pix);
    float * xold_b = (float *)malloc(sizeof(float) * pix);
    float * xold = (float *)malloc(sizeof(float) * 1.01 * pix);
    
    float * y_r = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    float * y_g = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    float * y_b = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
//    float * y = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    
    int i;
    // make measurements
    // note that idx is modified in this
//    int measurement_length = rate*pix;
    
    // make idx
    // length not needed. [idx count]
    [self.brain makeIDX:idx ofLength:pix];
    //idx = self.idx;
    
    // make y
    // length needed
    // DEBUG: y is only the measurements in one color plane
    
    [self.brain makeMeasurements:self.imageStay atRate:rate
                             red:y_r green:y_g blue:y_b
                        ofLength:(int)rate*pix
                             idx:idx];
    // make xold
    // length not needed. use pix instead.
    for (i=0; i<pix; i++) {
        xold_r[i] = 0;
        xold_g[i] = 0;
        xold_b[i] = 0;
        xold[i] = 0;
        
    }

    self.idx = idx;
    self.y_r = y_r;
    self.y_g = y_g;
    self.y_b = y_b;
    self.xold_r = xold_r;
    self.xold_g = xold_g;
    self.xold_b = xold_b;
    self.finished = NO;
    BOOL fin = NO;
    NSLog(@"the right function....<>");
//    [UIView animateWithDuration:4.25 delay:0 options:nil animations:^{self.imageView.image = [UIImage imageNamed:@"lenna.jpg"];} completion:^(BOOL finished)
//    {self.imageView.image = [UIImage imageNamed:@"ted.jpg"];}];
//    [UIView setAnimationsEnabled:YES];
    self.finished = NO;
    //[UIView animateWithDuration:3 delay:3 options:nil animations:^(void){self.imageView.image = [UIImage imageNamed:@"ted.jpg"];} completion:^(BOOL finished) {self.imageView.image = [UIImage imageNamed:@"mountain.jpg"];}];
  
[UIView animateWithDuration:0.25 delay:0.0 options:nil animations:^{
//self.imageView.image = [UIImage imageNamed:@"ted.jpg"];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:0.0 options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:0];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:0.0 options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:1];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:0.0 options:nil animations:^{
NSLog(@"2");
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:2];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:0.0 options:nil animations:^{
NSLog(@"3");
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:3];
} completion:^(BOOL finished){
[UIView animateWithDuration:0.25 delay:0.0 options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:4];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:0.0 options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:5];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:6];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:0.0 options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
              iterations:1 pastIterations:7];
} completion:^(BOOL finished){

    [UIView animateWithDuration:0.25 delay:0.0 options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:8];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:0.0 options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:9];
} completion:^(BOOL finished){
[UIView animateWithDuration:0.25 delay:10.0 options:nil animations:^{
    //if(finished==YES) return;
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:10];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:11.0 options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:11];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:12.0 options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
 idx:self.idx
 y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:12];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:13.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:13];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:14.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:14];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:15.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:15];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:16.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:16];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:17.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:17];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:18.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:18];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:19.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:19];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:20.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:20];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:21.00
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:21];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:022.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
 idx:self.idx
 y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:22];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:23.00
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:23];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:24.00
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:24];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:25.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:25];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:26.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:26];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:27.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:27];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:28.0
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:28];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:29.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:29];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:30.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:30];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:31.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:31];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:32.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:32];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:33.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:33];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:34.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:34];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:35.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:35];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:36.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:36];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:37.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:37];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:38.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:38];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:39.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:39];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:40.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:40];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:41.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:41];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:42.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
 idx:self.idx
 y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:42];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:43.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:43];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:44.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:44];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:45.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:45];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:46.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:46];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:47.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:47];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:48.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:48];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:49.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:49];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:50.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:50];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:51.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:51];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:52.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:52];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:53.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:53];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:54.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:54];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:55.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:55];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:56.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:56];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:57.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:57];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:58.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:58];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:59.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:59];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:60.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:60];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:62.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:61];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:63.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:62];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:64.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:63];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:65.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:64];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:67.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:65];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:68.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:67];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:69.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:68];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:70.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:69];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:71.00 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:70];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:72.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:71];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:73.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:72];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:74.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
 idx:self.idx
 y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:73];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:75.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:74];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:76.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:75];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:77.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:76];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:78.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:77];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:79.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:78];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:80.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:79];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:81.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:80];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:82.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:82.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:83.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:82];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:85.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:83];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:87.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:84];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:89.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:85];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:91.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:86];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:93.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:87];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:95.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:88];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:97.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:89];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:99.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:90];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:101.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:91];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:103.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:92];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:105.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:93];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:107.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:94];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:109.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:95];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:111.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:96];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:113.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:97];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:115.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:98];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:117.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:99];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:119.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:100];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:121.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:101];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:123.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:102];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:125.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:103];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:127.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:104];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:129.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:105];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:131.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:106];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:133.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:107];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:135.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:108];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:137.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:109];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:139.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:110];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:141.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:111];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:143.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:112];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:145.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:113];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:147.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:114];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:149.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:115];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:151.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:116];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:153.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:117];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:155.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:118];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:157.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:119];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:159.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:120];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:161.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:121];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:163.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:122];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:165.0 
options:nil animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
                                iterations:1 pastIterations:123];
} completion:^(BOOL finished){


}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];
}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];
}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];
*/
 
}
- (IBAction)reconstruct:(id)sender {


NSLog(@"rate = %f", self.rate);
NSLog(@"coarse = %f", self.coarse);

// image set up properly
self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];
float rate = self.rate;
float pix = self.imageStay.size.width * self.imageStay.size.height;
//    float coarseness = self.coarse;
NSMutableArray * idx = [[NSMutableArray alloc] initWithCapacity:pix];
// init xold
float * xold_r = (float *)malloc(sizeof(float) * pix);
float * xold_g = (float *)malloc(sizeof(float) * pix);
float * xold_b = (float *)malloc(sizeof(float) * pix);
float * xold = (float *)malloc(sizeof(float) * 1.01 * pix);

float * y_r = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
float * y_g = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
float * y_b = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
//    float * y = (float *)malloc(sizeof(float) * 1.01 * rate * pix);

int i;
// make measurements
// note that idx is modified in this
//    int measurement_length = rate*pix;

// make idx
// length not needed. [idx count]
[self.brain makeIDX:idx ofLength:pix];

// make y
// length needed
// DEBUG: y is only the measurements in one color plane

[self.brain makeMeasurements:self.imageStay atRate:rate
red:y_r green:y_g blue:y_b
ofLength:(int)rate*pix
idx:idx];
// make xold
// length not needed. use pix instead.
for (i=0; i<pix; i++) {
xold_r[i] = 0;
xold_g[i] = 0;
xold_b[i] = 0;
xold[i] = 0;

}
//    UIImage * image =  self.imageView.image;
// with change: coarse=66
// no change: coarse  = 0.891
// an imageView, assumed to be grayed out

// image isn't touched in reconstruct2()
//
// then perhaps somehow presenting the camera roll disables the
// animation?

// or the animation recieves the same image each time?



NSLog(@"self.coarse = %f", self.coarse);
self.imageView.animationImages = [NSArray arrayWithObjects:[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:68
pastIterations:0],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:2 pastIterations:1],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:3 pastIterations:3],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:4 pastIterations:7],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:5 pastIterations:11],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:8 pastIterations:19],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:13 pastIterations:27],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:20 pastIterations:47],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:25 pastIterations:67],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:35 pastIterations:92],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:48 pastIterations:127],
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:idx y_r:y_r y_g:y_g y_b:y_b
rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:60 pastIterations:187],
//                                      [self.brain reconstruct2:self.imageView.image
//                                                        coarse:self.coarse
//                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
//                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:146 pastIterations:262],
//                                      [self.brain reconstruct2:self.imageView.image
//                                                        coarse:self.coarse
//                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
//                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:191 pastIterations:336],
//                                      [self.brain reconstruct2:self.imageView.image
//                                                        coarse:self.coarse
//                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
//                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:221 pastIterations:486],
//                                      [self.brain reconstruct2:self.imageView.image
//                                                        coarse:self.coarse
//                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
//                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:252 pastIterations:636],

nil];
self.imageView.animationDuration = 6.00;
self.imageView.animationRepeatCount = 100;
[self.imageView startAnimating];




}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
return self.imageView;
}

- (IBAction)reconstructV2:(id)sender {

NSLog(@"rate = %f", self.rate);
NSLog(@"coarse = %f", self.coarse);

// image set up properly
self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];
float rate = self.rate;
float pix = self.imageStay.size.width * self.imageStay.size.height;
//    float coarseness = self.coarse;
NSMutableArray * idx = [[NSMutableArray alloc] initWithCapacity:pix];
// init xold
float * xold_r = (float *)malloc(sizeof(float) * pix);
float * xold_g = (float *)malloc(sizeof(float) * pix);
float * xold_b = (float *)malloc(sizeof(float) * pix);
float * xold = (float *)malloc(sizeof(float) * 1.01 * pix);

float * y_r = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
float * y_g = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
float * y_b = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
//    float * y = (float *)malloc(sizeof(float) * 1.01 * rate * pix);

int i;
// make measurements
// note that idx is modified in this
//    int measurement_length = rate*pix;

// make idx
// length not needed. [idx count]
[self.brain makeIDX:idx ofLength:pix];

// make y
// length needed
// DEBUG: y is only the measurements in one color plane

[self.brain makeMeasurements:self.imageStay atRate:rate
red:y_r green:y_g blue:y_b
ofLength:(int)rate*pix
idx:idx];
// make xold
// length not needed. use pix instead.
for (i=0; i<pix; i++) {
xold_r[i] = 0;
xold_g[i] = 0;
xold_b[i] = 0;
xold[i] = 0;

}
//    UIImage * image =  self.imageView.image;
// with change: coarse=77
// no change: coarse  = 0.902
// an imageView, assumed to be grayed out

// image isn't touched in reconstruct2()
//
// then perhaps somehow presenting the camera roll disables the
// animation?

// or the animation recieves the same image each time?
self.idx = idx;
self.y_r = y_r;
self.y_g = y_g;
self.y_b = y_b;
self.xold_r = xold_r;
self.xold_g = xold_g;
self.xold_b = xold_b;
[UIView animateWithDuration:0.25 delay:0.0 options:NULL animations:^{
//self.imageView.image = [UIImage imageNamed:@"ted.jpg"];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:1.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:0];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:2.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:1];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:2.0 options:NULL animations:^{
NSLog(@"2");
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:2];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:3.0 options:NULL animations:^{
NSLog(@"3");
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:3];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:4.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:4];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:5.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:5];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:6.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:6];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:7.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:7];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:8.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:8];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:9.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:9];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:10.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:10];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:11.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:11];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25 delay:12.0 options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:12];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:103.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:13];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:105.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:14];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:107.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:15];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:109.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:16];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:111.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:17];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:113.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:18];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:115.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:19];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:117.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:20];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:119.00 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:21];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:0165.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:22];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:123.00 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:23];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:125.00 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:24];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:127.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:25];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:129.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:26];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:131.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:27];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:133.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:28];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:135.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:29];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:137.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:30];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:139.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:31];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:141.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:32];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:143.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:33];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:145.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:34];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:147.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:35];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:149.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:36];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:151.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:37];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:153.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:38];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:155.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:39];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:157.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:40];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:159.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:41];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:161.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:42];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:163.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:43];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:165.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:44];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:167.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:45];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:169.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:46];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:171.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:47];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:173.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:48];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:175.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:49];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:177.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:50];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:179.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:51];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:181.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:52];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:183.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:53];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:185.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:54];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:187.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:55];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:189.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:56];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:191.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:57];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:193.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:58];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:195.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:59];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:197.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:60];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:200.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:61];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:202.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:62];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:204.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:63];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:206.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:64];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:209.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:65];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:211.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:67];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:213.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:68];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:215.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:69];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:217.00 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:70];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:219.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:71];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:221.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:72];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:223.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:73];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:225.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:74];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:227.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:75];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:229.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:76];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:231.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:77];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:233.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:78];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:235.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:79];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:237.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:80];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:239.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){

[UIView animateWithDuration:0.25                                                                delay:240.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:242.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:243.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:244.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:245.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:246.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:247.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:248.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:249.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:250.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:251.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:252.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:253.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:254.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:256.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:257.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:258.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:259.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:260.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:261.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:262.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:263.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:264.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:265.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:266.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:267.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:268.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:270.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:271.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:272.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:273.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:274.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:275.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:276.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:277.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:278.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:279.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:280.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:281.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:282.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:284.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:285.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:286.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:287.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:288.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:81];
} completion:^(BOOL finished){


[UIView animateWithDuration:0.25                                                                delay:289.0 
options:NULL animations:^{
self.imageView.image =
[self.brain reconstruct2:self.imageView.image
coarse:self.coarse
idx:self.idx
y_r:self.y_r y_g:self.y_g y_b:self.y_b
rate:self.rate
xold_r:self.xold_r xold_g:self.xold_g
xold_b:self.xold_b
iterations:1 pastIterations:82];
} completion:^(BOOL finished){



}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];


}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];
}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];

}];
    
    /*
    NSMutableArray * steps = [[NSMutableArray alloc] initWithCapacity:10+1];
    for (i=0; i<100; i++) {
        [steps addObject:[CPAnimationStep
                          for:1 animate:^{ self.imageView.image =
                                        [self.brain reconstruct2:self.imageView.image
                                                          coarse:self.coarse
                                                             idx:self.idx
                                                             y_r:self.y_r y_g:self.y_g y_b:self.y_b
                                                            rate:self.rate
                                                          xold_r:self.xold_r xold_g:self.xold_g
                                                          xold_b:self.xold_b
                                                      iterations:1 pastIterations:i]; }]];
        
    }
    
//    NSArray * stepsStay = [[NSArray alloc] initWithArray:steps copyItems:YES];
    
//    CPAnimationSequence * anim= [[CPAnimationSequence alloc] init];
//    anim.steps = stepsStay;

    [[CPAnimationSequence sequenceWithSteps:
            [steps objectAtIndex:0],
            [steps objectAtIndex:1],
            [steps objectAtIndex:2],
            [steps objectAtIndex:3],
            [steps objectAtIndex:4],
            [steps objectAtIndex:5],
            [steps objectAtIndex:6],
            [steps objectAtIndex:7],
            [steps objectAtIndex:8],
            [steps objectAtIndex:9],
            [steps objectAtIndex:9],
            [steps objectAtIndex:10],
            [steps objectAtIndex:11],
            [steps objectAtIndex:12],
            [steps objectAtIndex:13],
            [steps objectAtIndex:14],
            [steps objectAtIndex:15],
            [steps objectAtIndex:16],
            [steps objectAtIndex:17],
            [steps objectAtIndex:18],
            [steps objectAtIndex:18],
            [steps objectAtIndex:19],
            [steps objectAtIndex:20],
            [steps objectAtIndex:21],
            [steps objectAtIndex:22],
            [steps objectAtIndex:23],
            [steps objectAtIndex:24],
            [steps objectAtIndex:25],
            [steps objectAtIndex:26],
            [steps objectAtIndex:27],
            [steps objectAtIndex:28],
            [steps objectAtIndex:29],
            [steps objectAtIndex:30],
            [steps objectAtIndex:31],
            [steps objectAtIndex:32],
            [steps objectAtIndex:33],
            [steps objectAtIndex:34],
            [steps objectAtIndex:35],
            [steps objectAtIndex:36],
            [steps objectAtIndex:37],
            [steps objectAtIndex:38],
            [steps objectAtIndex:39],
            [steps objectAtIndex:40],
            [steps objectAtIndex:41],
            [steps objectAtIndex:42],
            [steps objectAtIndex:43],
            [steps objectAtIndex:44],
            [steps objectAtIndex:45],
            [steps objectAtIndex:46],
            [steps objectAtIndex:47],
            [steps objectAtIndex:48],
            [steps objectAtIndex:49],
            [steps objectAtIndex:50],
            [steps objectAtIndex:51],
            [steps objectAtIndex:52],
            [steps objectAtIndex:53],
            [steps objectAtIndex:54],
            [steps objectAtIndex:55],
            [steps objectAtIndex:56],
            [steps objectAtIndex:57],
            [steps objectAtIndex:58],
            [steps objectAtIndex:59],
            [steps objectAtIndex:60],
            [steps objectAtIndex:61],
            [steps objectAtIndex:62],
            [steps objectAtIndex:63],
            [steps objectAtIndex:64],
            [steps objectAtIndex:65],
            [steps objectAtIndex:66],
            [steps objectAtIndex:67],
            [steps objectAtIndex:68],
            [steps objectAtIndex:69],
            [steps objectAtIndex:70],
            [steps objectAtIndex:71],
            [steps objectAtIndex:72],
            [steps objectAtIndex:73],
            [steps objectAtIndex:74],
            [steps objectAtIndex:75],
            [steps objectAtIndex:76],
            [steps objectAtIndex:77],
            [steps objectAtIndex:78],
            [steps objectAtIndex:79],
            [steps objectAtIndex:80],
            [steps objectAtIndex:81],
            nil]
     runAnimated:YES]; */

}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{

    // something done after the animation
    // start the next animation
    [UIView animateWithDuration:1.0 animations:^{self.imageView.image = [UIImage imageNamed:@"ted.jpg"];} completion:^(BOOL finished)
     {self.imageView.image = [UIImage imageNamed:@"mountain.jpg"];}];
     

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
