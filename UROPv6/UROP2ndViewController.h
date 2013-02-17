//
//  UROP2ndViewController.h
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//


#import "UROP2ndViewController.h"
#import "UROPMainViewController.h"

@interface UROP2ndViewController : UIViewController
    <UIImagePickerControllerDelegate,
    UINavigationControllerDelegate>
{
    UIImageView *imageView;
    BOOL newMedia;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)useCameraRoll;

@end
