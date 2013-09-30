//
//  UROPInfo.m
//  Reconstruct
//
//  Created by Scott Sievert on 9/26/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import "UROPInfo.h"

#define IS_WIDESCREEN ( fabs( (double)[[UIScreen mainScreen] bounds].size.height - (double)568 ) < DBL_EPSILON )

#define SCOTT  @"<a href=\"http://scottsievert.github.io\"    >Scott Sievert</a>"
#define JARVIS @"<a href=\"http://www.ece.umn.edu/~jdhaupt\"  >Prof. Jarvis Haupt</a>"
#define PAPER  @"<a href=\"http://scholar.google.com\"            >academic paper</a>"

@interface UROPInfo ()

@end

@implementation UROPInfo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *body = [NSString stringWithFormat:@"The app uses a technique to reconstruct the image that relies on large areas of the image being largely the same. If the image were completely random, this reconstruction would fail utterly.  <br><br>\
                      \
                      \
                      <i>Experts:</i> we group the high frequency terms with the noise then use the fast iterative soft thresholding algorithm (FISTA) to reconstruct the image. There's an %@ that covers this in detail. In our view, this is compressed sensing, though other experts can still have an in depth debate about it.<br><br>\
                      \
                      This app was made by %@ with %@ at the University of Minnesota under the Undergraduate Research Opportunities program.", PAPER, SCOTT, JARVIS];
    
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
    
    
    self.textView.text = @"The views and opinions expressed in this app are strictly those of the app author. The contents of this app have not been reviewed or approved by the University of Minnesota.";
     [self.textView setFont:[UIFont systemFontOfSize:10]];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.editable = NO;
    self.textView.scrollEnabled = NO;
    self.webView.scrollView.scrollEnabled = NO;

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

@end
