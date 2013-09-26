/*
 * made by    : SparKEL Lab
 * at the     : University of Minnesota
 * advisor    : Dr. Jarvis Haupt
 * programmer : Scott Sievert
 *
 * Copyright (c) 2013 by Scott Sievert. All rights reserved.
 *
 * This code can be found online at https://github.com/scottsievert/UROPv6
 *
 * This app presents you with an intial starting screen, presents another
 * screen that offers how much information you should take in, then
 * reconstructs the given image with that information.
 *
 * This file is for the intial startup screen. It presents you with some
 * information about why compressed sensing is important, and gives you the
 * basics of how it works (as in, ultra-basic).
 *
 * It presents a button to....  
 *     1. allow you to go to the sampling screen.  
 *     2. an "info" button to see more info.
 *
 *
 *  The tree structure for this app: 
 *  ================================
 *        
 *         .-------------------------------------------.
 *         |                                           |      
 *         |      main  --> sampling --> reconstruct   |
 *         |            |                              |
 *         |            .-> info                       |
 *         |                                           |      
 *         |            .-> coarseness (unused)        |
 *         |                                           |      
 *         .-------------------------------------------.      
 *
 *
 *          main        : UROPMainController
 *          info        : UROPFlipsideController
 *          sampling    : UROP3rdViewController
 *          reconstruct : UROPFinalViewController
 *          coarseness  : UROP2ndViewController
 *        
 *                                                  
 *                                                  
 *  The call tree 
 *  ============== 
 *      mainly, reconstruct --> UROPbrain --> UROPdwt
 *    
 *      UROPbrain contains the functions that actually matter. Here, the fast
 *      iterative soft thresholding algorithm (FISTA) is performed. UROPdwt
 *      contains helper functions for UROPbrain; simple things that are
 *      included in Python/Matlab/high level languages (eg, getColumn) and more
 *      complex like wavelet functions (eg, dwt2_full).
 *
 *      There are some more functions in UROPbrain that are called from other
 *      places, mainly to init for viewing the coarseness/sampling rate
 *
 *
 * --Scott Sievert, sieve121 at umn.edu, 2013-9-18
 */

#import "UROPMainViewController.h"
#import "UROPInfo.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)




@interface UROPMainViewController ()

@end

@implementation UROPMainViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    UIImage * info = [UIImage imageNamed:@"info.png"];
    [self.infoButton setTitle:@" " forState:UIControlStateNormal];
    [self.infoButton setBackgroundImage:info forState:UIControlStateNormal];

	// Do any additional setup after loading the view, typically from a nib.
    self.text.text = [NSString stringWithFormat:@"Currently, images are sampled at every pixel then information is lost when compressed into a JPG. Why not build a camera that only takes in the information it needs? \n\nThis application will simulate that. It will take an image from your camera roll  and delete some data without modifing your camera roll. From only the pixels shown, an approximation of the original image will be reconstructed. \n\nThe applications of this are broad. It goes from consumer electronics to medical imaging to discovering planets, and that doesn't even touch an incredible number of fields."];
    
    self.text.textColor = [UIColor blackColor];
    
    self.button.titleLabel.font = [UIFont boldSystemFontOfSize:16];

    
    [self.button setBackgroundImage:[UIImage imageNamed:@"wait.png"] forState:UIControlStateHighlighted];
    
    // making the font actually fit on the screen without scrolling, depending on iOS version.
    // setting the proper text size
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        // if it's running iOS 7, don't change the story board
        NSLog(@"iOS 7 (or newer)");
        if ([[UIScreen mainScreen] bounds].size.height == 568){
            NSLog(@"Running on iPhone 5 (large screen size");
            self.text.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
            
        } else if ([[UIScreen mainScreen] bounds].size.height < 568){
            NSLog(@"Running on < iPhone 4S");
            self.text.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.2];
        }
    }
    else {
        NSLog(@"iOS 6 (or less)");
        if ([[UIScreen mainScreen] bounds].size.height == 568){
            NSLog(@"Running on iPhone 5 (large screen size");
            self.text.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.8];
            
        } else if ([[UIScreen mainScreen] bounds].size.height < 568){
            NSLog(@"Running on < iPhone 4S");
            self.text.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.9];

        }
    }
    
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 10.0f;
    self.button.layer.borderWidth = 1.0f;

    UIColor * titleColor = [UIColor colorWithRed:155/255.0 green:141/255.0 blue:80/255.0 alpha:1.0];
    UIColor * bgColor = [UIColor colorWithRed:255/255.0 green:89/255.0 blue:109/255.0 alpha:1.0];
    
    [self.button setBackgroundColor:bgColor];
    [self.button setTitleColor:titleColor forState:UIControlStateHighlighted];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"In prepareForSegue -- UROPMainViewController");
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        //self.button.backg
        [[segue destinationViewController] setDelegate:self];

    }
}

@end
