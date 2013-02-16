//
//  UROPFlipsideViewController.h
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UROPFlipsideViewController;

@protocol UROPFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(UROPFlipsideViewController *)controller;
@end

@interface UROPFlipsideViewController : UIViewController

@property (weak, nonatomic) id <UROPFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
