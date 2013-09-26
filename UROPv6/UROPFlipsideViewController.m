//
//  UROPFlipsideViewController.m
//  UROPv6
//
//  Created by Scott Sievert on 2/15/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

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
#import "UROPFinalViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define IS_WIDESCREEN ( fabs( (double)[[UIScreen mainScreen] bounds].size.height - (double)568 ) < DBL_EPSILON )

#define SCOTT  @"<a href=\"http://scottsievert.github.io\"    >Scott Sievert</a>"
#define JARVIS @"<a href=\"http://www.ece.umn.edu/~jdhaupt\"  >Prof. Jarvis Haupt</a>"
#define PAPER  @"<a href=\"http://www.google.com\"            >academic paper</a>"

@interface UROPFlipsideViewController ()

@end

@implementation UROPFlipsideViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *body = [NSString stringWithFormat:@"The app uses a technique to reconstruct the image that relies on large areas of the image being largely the same. If the image were completely random, this reconstruction would fail utterly.  <br><br>\
    \
    This app was made by %@ with %@ at the University of Minnesota under the Undergraduate Research Opportunities program.<br><br>\
    \
    For experts, this app uses the fast iterative soft thresholding algorithm (FISTA). There's an %@ that details the theory behind this app.", SCOTT, JARVIS, PAPER];
    
    NSString *htmlString;
    if (IS_WIDESCREEN) {
        NSLog(@"5>");
        htmlString = [NSString stringWithFormat:@"<font face='HelveticaNeue-Light' size='3'>%@", body];
    } else {
        NSLog(@"<5");
        htmlString = [NSString stringWithFormat:@"<font face='HelveticaNeue-Light' size='2'>%@", body];
    }
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    // set the delegate for opening links in Safari -- see webView:shouldStartLoadWithRequest....
    self.webView.delegate = (id)self;
    // make links clickable.
    self.webView.dataDetectorTypes = UIDataDetectorTypeLink;
    


}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    // loads a URL in a UIWebView in Safari. requires self.webView.delegate = self;
    // taken from http://stackoverflow.com/questions/12104198/need-to-open-link-in-safari-from-uiwebview
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions
-(IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
