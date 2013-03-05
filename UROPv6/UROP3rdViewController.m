//
//  UROP3rdViewController.m
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//


#import "UROP3rdViewController.h"
#import "UROPFinalViewController.h"
#import "UROPMainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UROPbrain.h"
@interface UROP3rdViewController ()
@property (nonatomic, strong) UROPbrain *brain;

@end

@implementation UROP3rdViewController
@synthesize brain = _brain;

-(UROPbrain *)brain
{
    if (!_brain) _brain = [[UROPbrain alloc] init];
    return _brain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.imageViewTest.image = [UIImage imageNamed:@"mountain.jpg"];
    
    
    self.rate = 0.5;

//    self.imageView.contentMode = UIViewContentModeScaleToFill;
//   self.imageView.clipsToBounds = YES;
    

    
    self.label.text = [NSString stringWithFormat:@"Sampling rate: %.0f%%", 50.0];
    UIImage * image = [self imageWithImage:[UIImage imageNamed:@"lenna.jpg"] scaledToSize:CGSizeMake(256, 256)];
//    UIImage * image = [UIImage imageNamed:@"mountain.jpg"];
    self.imageStay = image;
//    image =
    self.imageView.image = [self.brain sampleImage:image atRate:self.rate];//image;
    

    
    
    NSLog(@"%@", self.imageView.frame);

    
}
- (IBAction)samplingSliderChanged:(id)sender {
    float rate = 0.6*self.samplingSlider.value + 0.2;
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:rate];
    self.label.text = [NSString stringWithFormat:@"Sampling rate: %.0f%%", 100*(0.6*self.samplingSlider.value + 0.2)];
    self.rate = rate;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"samplingToFinal"]) {
        
        UROPFinalViewController *destViewController = segue.destinationViewController;
        destViewController.imageStay = self.imageStay;
        destViewController.rate = self.rate;
        destViewController.coarse = self.coarse;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// all from web
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (IBAction)useCameraRoll2:(id)sender {
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
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        // "self." added by SCOTT
        // IMAGE picks here. FINDME. change as needed.
        image = [self imageWithImage:image scaledToSize:CGSizeMake(256, 256)];
        self.imageView.image = [self.brain sampleImage:image atRate:self.rate];
        self.imageStay = image;
        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
}


@end
