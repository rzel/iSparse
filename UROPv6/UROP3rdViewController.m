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

@interface UROP3rdViewController ()

@end

@implementation UROP3rdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imageView.image = self.imageStay;
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"samplingToFinal"]) {
        
        UROPFinalViewController *destViewController = segue.destinationViewController;
        destViewController.imageStay = self.imageStay;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
