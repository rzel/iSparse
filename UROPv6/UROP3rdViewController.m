//
//  UROP3rdViewController.m
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//


#import "UROP3rdViewController.h"
#import "UROPFinalViewController.h"
#import "UROPMainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UROPbrain.h"
@interface UROP3rdViewController ()
@property (nonatomic, strong) UROPbrain *brain;

@end

@implementation UROP3rdViewController
@synthesize brain = _brain;

-(UROPbrain *)brain
{
    if (!_brain) _brain = [[UROPbrain alloc] init];
    return _brain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:0.5];
    self.rate = 0.5;
    self.label.text = [NSString stringWithFormat:@"%.0f%%", 50.0];
    
}
- (IBAction)samplingSliderChanged:(id)sender {
    float rate = 0.6*self.samplingSlider.value + 0.2;
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:rate];
    self.label.text = [NSString stringWithFormat:@"%.0f%%", 100*self.samplingSlider.value];
    self.rate = rate;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"samplingToFinal"]) {
        
        UROPFinalViewController *destViewController = segue.destinationViewController;
        destViewController.imageStay = self.imageStay;
        destViewController.rate = self.rate;
        destViewController.coarse = self.coarse;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
