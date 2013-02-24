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
                                      [self.brain reconstruct2:self.imageView.image
                                                        coarse:self.coarse
                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:75 pastIterations:262],
                                      [self.brain reconstruct2:self.imageView.image
                                                        coarse:self.coarse
                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:120 pastIterations:336],
                                      [self.brain reconstruct2:self.imageView.image
                                                        coarse:self.coarse
                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:150 pastIterations:486],
                                      [self.brain reconstruct2:self.imageView.image
                                                        coarse:self.coarse
                                                           idx:idx y_r:y_r y_g:y_g y_b:y_b
                                                          rate:rate xold_r:xold_r xold_g:xold_g xold_b:xold_b iterations:180 pastIterations:636],
                                      
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
