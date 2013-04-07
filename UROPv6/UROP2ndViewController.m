//
//  UROP2ndViewController.m
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//


#import "UROP2ndViewController.h"
#import "UROP3rdViewController.h"
#import "UROPMainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UROPbrain.h"
@interface UROP2ndViewController ()
@property (nonatomic, strong) UROPbrain *brain;

@end

@implementation UROP2ndViewController
@synthesize imageView = _imageView;
@synthesize brain = _brain;

-(UROPbrain *)brain
{
    if (!_brain) _brain = [[UROPbrain alloc] init];
    return _brain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImage * image = [self imageWithImage:[UIImage imageNamed:@"mountain.jpg"] scaledToSize:CGSizeMake(256, 256)];
    image = [self.brain doWaveletKeepingLargestKTerms:image coarse:1.5*(1-0.5)];
    self.imageView.image = image;
    self.imageStay = image;
    self.slider.continuous = NO;
    NSLog(@"At 2ndViewController");
    self.coarse = 1.5*(1 - 0.45);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// the code I changed:
    // image = [self imageWithImage:image scaledToSize:CGSizeMake(256, 256)];
    //self.imageView.image = image;
    //self.imageStay = image;

- (IBAction)useCameraRoll{
    NSLog(@"here");
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
//        [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
//        [self.navigationController pushViewController:(UIViewController *)imagePicker animated:YES];
        newMedia = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"qualityToSampling"]) {
        
        UROP3rdViewController *destViewController = segue.destinationViewController;
        destViewController.imageStay = self.imageStay;
        destViewController.coarse = self.coarse;
        destViewController.rate = -1;
    }
}

- (IBAction)coarsenessSliderChanged:(id)sender {
    float rate = 10*(self.slider.value - 0.5);
    
    self.imageView.image = [self.brain doWaveletKeepingLargestKTerms:self.imageStay coarse:rate];
    NSLog(@"%@", self.slider.continuous);
    self.coarse = self.rate;
}

// from the web

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
