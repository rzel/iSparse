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
    self.text.text = @"This app uses a procedure called compressed sensing. What it does is applies a transformation to the image, then tries to match the measurements to the reconstruction iteratively. The coarseness slider dictates how much detail your final reconstruction can have.";
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
