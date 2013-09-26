//
//  UROPMainViewController.h
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import "UROPFlipsideViewController.h"

@interface UROPMainViewController : UIViewController <UROPFlipsideViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end
