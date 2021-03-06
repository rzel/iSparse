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
@property (strong, nonatomic) IBOutlet UIImage *imageStay;
@property float rate;
@property float coarse;

@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)useCameraRoll;

@end
