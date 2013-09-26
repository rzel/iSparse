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

#define SPARKEL www.google.com

@interface UROPFlipsideViewController ()

@end

@implementation UROPFlipsideViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.text.dataDetectorTypes = UIDataDetectorTypeLink;

    self.text.text = [NSString stringWithFormat:@"The app uses a technique to reconstruct the image that relies on large areas of the image being largely the same. If the image were completely random, this reconstruction would fail utterly. \n\nFor experts, this app uses the fast iterative soft thresholding algorithm (FISTA).\n\nThis app was made by Scott Sievert with Prof. Jarvis Haupt at the University of Minnesota under the Undergraduate Research Opportunities program."];
    self.text.textColor = [UIColor blackColor];
    
    NSString *body = @"The app uses a technique to reconstruct the image that relies on large areas of the image being largely the same. If the image were completely random, this reconstruction would fail utterly.  <br><br>\
    \
    This app was made by <a href=\"http://scottsievert.github.io\">Scott Sievert</a> with <a href=\"http://www.ece.umn.edu/~jdhaupt/\">Prof. Jarvis Haupt</a> at the University of Minnesota under the Undergraduate Research Opportunities program.<br><br>\
    \
    For experts, this app uses the fast iterative soft thresholding algorithm (FISTA). There is an academic paper on arXiv that accompanies this app and details the theory.";
    
    NSString *htmlString = [NSString stringWithFormat:@"<font face='HelveticaNeue-Light' size='3'>%@", body];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    self.webView.delegate = (id)self;
    self.webView.dataDetectorTypes = UIDataDetectorTypeLink;
//    [self.webView loadHTMLString:@"Work! <a href=\"http://www.github.com\">Work2!!!</a> " baseURL:[NSURL URLWithString:@"http://www.google.com"]];

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
