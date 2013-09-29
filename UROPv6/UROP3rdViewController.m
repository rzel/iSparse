/*
 * made by    : SparKEL Lab
 * at the     : University of Minnesota
 * advisor    : Dr. Jarvis Haupt
 * programmer : Scott Sievert
 *
 * Copyright (c) 2013 by Scott Sievert. All rights reserved.
 *
 * This screen lets you select the sampling rate.
 *
 * It presents...
 *      1. a slider for the sampling rate (self.samplingSlider)
 *      2. a button for the camera roll (self.choose)
 *      3. a button to reconstruct (self.reconstructButton2)
 *      4. a sampling rate text box (self.label)
 *
 *  To show you the correct rate, we have a variable that stores the rate (self.rate)
 *
 *  --Scott Sievert, sieve121 at umn.edu, 2013-9-18
 *
 *
 */

#import <QuartzCore/QuartzCore.h>
#import "UROPInfo.h"
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
@synthesize reconstructButton = _reconstructButton;
@synthesize imageView = _imageView;

-(UROPbrain *)brain
{
    if (!_brain) _brain = [[UROPbrain alloc] init];
    return _brain;
}
-(IBAction)buttonPressed:(UIButton *)sender{
    NSLog(@"\n\n\nIn buttonPressed -- UROP3rdViewController\n\n\n");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    self.rate = 0.5;

    // making the sampling rate equal to 50% at first, resizing the image
    self.label.text = [NSString stringWithFormat:@"Sampling rate: %.0f%%", 50.0];
    UIImage * image = [self imageWithImage:[UIImage imageNamed:@"lenna.jpg"] scaledToSize:CGSizeMake(256, 256)];
    self.imageStay = image;
    self.imageView.image = [self.brain sampleImage:image atRate:self.rate];
    
    // so the slider doesn't jump/wait.
    self.samplingSlider.continuous = NO;
    
    // when you select the "Reconstruct" button, what color is the title?
    UIColor * selectedTitle = [UIColor grayColor];
    
    // making the buttons look nice.
    self.reconstructButton2.layer.masksToBounds = YES;
    self.reconstructButton2.layer.cornerRadius = 3.0f;
    self.reconstructButton2.layer.borderWidth = 1.0f;
    [self.reconstructButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // again, buttons looking nice.
    self.choose.layer.masksToBounds = YES;
    self.choose.layer.cornerRadius = 3;
    self.choose.layer.borderWidth = 1.0f;
    [self.choose setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]];
    
    // the orange/blue colors.
    [self.reconstructButton2 setBackgroundColor:[UIColor colorWithRed:100/255.0 green:191/255.0 blue:231/255.0 alpha:1]];
    [self.reconstructButton2 setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateHighlighted];
    [self.reconstructButton2 setTitleColor:selectedTitle forState:UIControlStateHighlighted];
    
    [self.infoButton addTarget:self action:@selector(infoPressed) forControlEvents:UIControlEventTouchUpInside];

}
-(void)infoPressed{
    NSLog(@"info pressed!");
    
}
- (IBAction)samplingSliderChanged:(id)sender {
    float rate = 0.6*self.samplingSlider.value + 0.2;
    self.imageView.image = [self.brain sampleImage:self.imageStay atRate:rate];
    self.label.text = [NSString stringWithFormat:@"Sampling rate: %.0f%%", 100*rate];
    self.rate = rate;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"samplingToFinal"]) {
        UROPFinalViewController *destViewController = segue.destinationViewController;
        // keeping the rate/idx/all that constant throughout screen changes.
        destViewController.imageStay = self.imageStay;
        destViewController.rate = self.rate;
        destViewController.coarse = self.coarse;
        destViewController.idx = self.idx;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// all from web... that is, stackoverflow
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
