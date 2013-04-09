//
//  UROP3rdViewController.h
//  UROPv
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

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTest;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reconstructButton;
- (IBAction)buttonPressed:(id)sender;

@property (weak, nonatomic) NSMutableArray * idx;
@end
