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
    self.text.text =    self.text.text = [NSString stringWithFormat:@"Currently, images are sampled at every pixel then information is lost when compressed into a JPG. Why not build a camera that only takes in the information it needs? \n\nThis application will simulate that. It will take an image from your camera roll, then delete some data (without modifing your camera roll). This data is never looked at again, and all of the blacked out areas are not taken in. \n\nThe applications of this are broad. It goes from consumer electronics to medical imaging to discovering planets, and that doesn't even touch an incredible number of fields."];
    
    self.text.textColor = [UIColor blackColor];
    
    [self.button setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateHighlighted];
    

    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5.0f;
    self.button.layer.borderWidth = 1.0f;
        [self.button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:131/255.0 blue:57/255.0 alpha:0.7]];
    [self.button setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    
    


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
    NSLog(@"In prepareForSegue");
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        //self.button.backg
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
