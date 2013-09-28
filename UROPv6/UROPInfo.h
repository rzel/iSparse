//
//  UROPInfo.h
//  Reconstruct
//
//  Created by Scott Sievert on 9/26/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IS_WIDESCREEN ( fabs( (double)[[UIScreen mainScreen] bounds].size.height - (double)568 ) < DBL_EPSILON )

#define SCOTT  @"<a href=\"http://scottsievert.github.io\"    >Scott Sievert</a>"
#define JARVIS @"<a href=\"http://www.ece.umn.edu/~jdhaupt\"  >Prof. Jarvis Haupt</a>"
#define PAPER  @"<a href=\"http://scholar.google.com\"            >academic paper</a>"

@interface UROPInfo : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
