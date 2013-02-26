//
//  UROP3rdViewController.h
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UROP3rdViewController : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    UIImageView *imageView;
    BOOL newMedia;
}
@property (strong, nonatomic) IBOutlet UIImage *imageStay;
@property  float rate;
@property  float coarse;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISlider *samplingSlider;

@end
