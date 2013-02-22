//
//  UROPFinalViewController.m
//  UROPv6
//
//  Created by Scott Sievert on 2/18/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import "UROPFinalViewController.h"
#import "UROPbrain.h"

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
    // an imageView, assumed to be grayed out
    //    for (i=0; i<1; i++) {
    //        NSLog(@"%d", i);
    //        [self.imageView setImage:image];
    //        [NSThread sleepForTimeInterval:1.0];
    //
    //        image = [self.brain reconstruct2:self.imageView.image
    //                                 coarse:coarseness
    //                                    idx:idx
    //                                    y_r:y_r y_g:y_g y_b:y_b
    //                                   rate:rate
    //                                 xold_r:xold_r
    //                                 xold_g:xold_g xold_b:xold_b];
    //
    //        [self.imageView setImage:image];
    //    }
        self.imageView.animationImages = [NSArray arrayWithObjects:[self.brain reconstruct2:self.imageView.image
                                                                                     coarse:coarseness
                                                                                        idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                                                       rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:1],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:2],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:3],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:4],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:5],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:8],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:13],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:20],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:25],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:35],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:48],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:60],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:75],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:120],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:150],
                                          [self.brain reconstruct2:self.imageView.image
                                                            coarse:coarseness
                                                               idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                              rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:180],
                                          
                                                                       nil];
    self.imageView.animationDuration = 6.00;
    self.imageView.animationRepeatCount = 100;
    [self.imageView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
