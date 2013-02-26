//
//  UROPMainViewController.m
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import "UROPMainViewController.h"

@interface UROPMainViewController ()

@end

@implementation UROPMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.text.text =    self.text.text = [NSString stringWithFormat:@"Currently, images are sampled at every pixel then compressed into a JPG, a lossy compression. This is wasteful. Why not build a camera that only samples where it needs to? \n\n This application will simulate that. It will take an image from your camera roll, then delete some data. This data is never looked at again. \n\n The applications of this are broad. It goes from consumer electronics to medical imaging to discovering planets, and that doesn't even touch an incredible number of fields. \n\n Note that since the iPhone is a low-powered mobile device, the reconstruction will not be perfect."];;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(UROPFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
