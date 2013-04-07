//
//  UROPFlipsideViewController.m
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

//
//  UROP2ndViewController.m
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//


#import "UROP2ndViewController.h"
#import "UROP3rdViewController.h"
#import "UROPMainViewController.h"
#import "UROPFinalViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface UROPFlipsideViewController ()

@end

@implementation UROPFlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.text.text = [NSString stringWithFormat:@"This app uses a technique that allows for reconstruction of images, as long as the image isn't infinitely complex. \n\nThe reason that the image doesn't show up as it would on other devices is that this method requires a time-intensive process that we avoided (since the iPhone is under powered), and this results in less detail in the image, the reason you see bright pixels. \n\nThis app was made by Dr. Jarvis Haupt and Scott Sievert at the University of Minnesota under the Undergraduate Research Oppurtunities Program. "];
    self.text.text = [NSString stringWithFormat:@"The app uses a technique to reconstruct the image that relies on large areas of the image being largely the same. If the image were completely random, this reconstruction would fail utterly. \n\nThis reconstruction method requires a time intensive process that we avoided, and processed the required values offline, though the rest of the reconstruction takes place on your phone. If this reconstruction were taking place on a higher powered computer, it would be better.\n\nThis app was made by Scott Sievert and Prof. Jarvis Haupt at the University of Minnesota under the Undergraduate Research Opportunities program."];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions
-(IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
