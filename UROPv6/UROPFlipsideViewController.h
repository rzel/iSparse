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
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)done:(id)sender;

@end
