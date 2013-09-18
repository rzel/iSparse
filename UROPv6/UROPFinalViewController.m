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

#define IMAGE_STEP self.imageView.image = [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse idx:idx y_r:y_r y_g:y_g y_b:y_b rate:rate xold_r:xold_r xold1_r:xold1_r xold_g:xold_g xold1_g:xold1_g xold_b:xold_b xold1_b:xold1_b iterations:1 pastIterations:0 tn:&tn];



@interface UROPFinalViewController ()
@property (nonatomic, strong) UROPbrain *brain;


@end



@implementation UROPFinalViewController
@synthesize brain = _brain;

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)stopAmination{
    int n = 64;
    // n must be less than 256
    UIImage * image = [self imageWithImage:self.imageView.image scaledToSize:CGSizeMake(n, n)];
    self.imageView.image = image;
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
    // try setting width/height low: to 1/4/8/16?


}
- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    NSLog(@"Starting animation...");
    
 
    int i;
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:self.rate];
    float rate = self.rate;
    float pix = self.imageStay.size.width * self.imageStay.size.height;
    
    // our variables for measurement/reconstructing.
    float * y_r = (float *)malloc(sizeof(float) * pix * rate * 1.1);
    float * y_g = (float *)malloc(sizeof(float) * pix * rate * 1.1);
    float * y_b = (float *)malloc(sizeof(float) * pix * rate * 1.1);
    
    float * xold_r = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold_g = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold_b = (float *)malloc(sizeof(float) * pix * 1.1);
    
    float * xold1_r = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold1_g = (float *)malloc(sizeof(float) * pix * 1.1);
    float * xold1_b = (float *)malloc(sizeof(float) * pix * 1.1);
    
    // our threshold value.
    float tn = 1;

    NSMutableArray * idx = [[NSMutableArray alloc] init];
    [self.brain makeIDX:idx ofLength:pix];
    
    // goes into y_r, y_g, y_b
    [self.brain makeMeasurements:self.imageStay atRate:self.rate red:y_r green:y_g blue:y_b ofLength:pix idx:idx];
    
    // ensuring they're all zeros.
    for (i=0; i<pix; i++) {
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
    
    
    static int showIts = 0;
    self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts];

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts=0;
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts];
                         IMAGE_STEP;
//                         self.imageView.image =
//                         [self.brain reconstructWithIST:self.imageView.image coarse:self.coarse
//                                                    idx:idx
//                                                    y_r:y_r y_g:y_g y_b:y_b
//                                                   rate:rate
//                                                 xold_r:xold_r xold1_r:xold1_r
//                                                 xold_g:xold_g xold1_g:xold1_g
//                                                 xold_b:xold_b xold1_b:xold1_b
//                                             iterations:1 pastIterations:0 tn:&tn];

                     }
                     completion:^(BOOL finished){
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    }}];
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         showIts++; self.iterations.text = [NSString stringWithFormat:@"Iterations: %d", showIts]; self.imageView.image = 
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
                        if (self.imageView.image.size.width >= 256){

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
 

    // we want tn to change: we should pass a pointer in
    float r = 1;


}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
return self.imageView;
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
