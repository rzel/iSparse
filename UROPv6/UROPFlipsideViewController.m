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
    self.text.text = [NSString stringWithFormat:@"This app uses a technique that allows for the nearly perfect reconstruction, as long as the image isn't infinitely complex. \n\nThe reason that the image doesn't show up perfectly is that this method requires a time-intensive process that we avoided (since the iPhone is under powered), and this results in less detail in the image, the reason you see bright pixels. \n\nThis app was made by Dr. Jarvis Haupt and Scott Sievert at the University of Minnesota under the Undergraduate Research Oppurtunities Program. "];
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
