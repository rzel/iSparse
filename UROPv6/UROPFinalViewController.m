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
#import "Animations_s/CPAnimationSequence.h"
#import "Animations_s/CPAnimationStep.h"
#import "Animations_s/CPAnimationProgram.h"

@interface UROPFinalViewController ()
@property (nonatomic, strong) UROPbrain *brain;

@end



@implementation UROPFinalViewController
@synthesize brain = _brain;

-(UROPbrain *)brain
{
    if (!_brain) _brain = [[UROPbrain alloc] init];
    return _brain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"rate = %f", self.rate);
//    NSLog(@"coarse = %f", self.coarse);
//    
//    // image set up properly
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];
    NSLog(@"%@", self.imageStay);
    NSLog(@"%@", self.imageView.image);
    // no user-selected image: 0xf6... 0x715...
    // user-selected image:    0xf7... 0x11d
    // user-sel., largestKTerms0xf6822 0xf6c29
//    UIImage *image1 = [UIImage imageNamed:@"ted.jpg"];
//    UIImage *image2 = [UIImage imageNamed:@"mountain.jpg"];
//    self.imageView.animationImages = [NSArray arrayWithObjects:image1, image2, nil];
//    self.imageView.animationDuration = 6.00;
//    self.imageView.animationRepeatCount = 100;
//    [self.imageView startAnimating];
    
}
- (IBAction)reconstruct:(id)sender {
    
    
    NSLog(@"rate = %f", self.rate);
    NSLog(@"coarse = %f", self.coarse);

    // image set up properly
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];
    float rate = self.rate;
    float pix = self.imageStay.size.width * self.imageStay.size.height;
    float coarseness = self.coarse;
    NSMutableArray * idx = [[NSMutableArray alloc] initWithCapacity:pix];
    // init xold
    float * xold_r = (float *)malloc(sizeof(float) * pix);
    float * xold_g = (float *)malloc(sizeof(float) * pix);
    float * xold_b = (float *)malloc(sizeof(float) * pix);
    float * xold = (float *)malloc(sizeof(float) * 1.01 * pix);
    
    float * y_r = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    float * y_g = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    float * y_b = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    float * y = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    
    int i, j;
    // make measurements
    // note that idx is modified in this
    int measurement_length = rate*pix;
    
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
    UIImage * image =  self.imageView.image;
    // with change: coarse=0
    // no change: coarse  = 0.825
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
                                                                                   rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:1
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
//                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:75 pastIterations:262],
//                                      [self.brain reconstruct2:self.imageView.image
//                                                        coarse:self.coarse
//                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
//                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:120 pastIterations:336],
//                                      [self.brain reconstruct2:self.imageView.image
//                                                        coarse:self.coarse
//                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
//                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:150 pastIterations:486],
//                                      [self.brain reconstruct2:self.imageView.image
//                                                        coarse:self.coarse
//                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
//                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:180 pastIterations:636],
                                      
                                                                   nil];
    self.imageView.animationDuration = 6.00;
    self.imageView.animationRepeatCount = 100;
    [self.imageView startAnimating];

    

}

- (IBAction)reconstructV2:(id)sender {
    
    NSLog(@"rate = %f", self.rate);
    NSLog(@"coarse = %f", self.coarse);
    
    // image set up properly
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];
    float rate = self.rate;
    float pix = self.imageStay.size.width * self.imageStay.size.height;
    float coarseness = self.coarse;
    NSMutableArray * idx = [[NSMutableArray alloc] initWithCapacity:pix];
    // init xold
    float * xold_r = (float *)malloc(sizeof(float) * pix);
    float * xold_g = (float *)malloc(sizeof(float) * pix);
    float * xold_b = (float *)malloc(sizeof(float) * pix);
    float * xold = (float *)malloc(sizeof(float) * 1.01 * pix);
    
    float * y_r = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    float * y_g = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    float * y_b = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    float * y = (float *)malloc(sizeof(float) * 1.01 * rate * pix);
    
    int i, j;
    // make measurements
    // note that idx is modified in this
    int measurement_length = rate*pix;
    
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
    UIImage * image =  self.imageView.image;
    // with change: coarse=0
    // no change: coarse  = 0.825
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
    
    NSMutableArray * steps = [[NSMutableArray alloc] initWithCapacity:10+1];
    int pastIts = 1;
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
                                                      iterations:10
                                                  pastIterations:pastIts]; }]];
        pastIts = 10 + pastIts;
        NSLog(@"pastIts = %d", pastIts);
        
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
     runAnimated:YES];

}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{

    // something done after the animation
    // start the next animation
    self.imageView.image = 
            [self.brain reconstruct2:self.imageView.image
                              coarse:self.coarse
                                 idx:self.idx
                                 y_r:self.y_r y_g:self.y_g y_b:self.y_b
                                rate:self.rate
                              xold_r:self.xold_r xold_g:self.xold_g
                              xold_b:self.xold_b
                          iterations:2 pastIterations:1];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
