//
//  UROPFinalViewController.h
//  UROPv6
//
//  Created by Scott Sievert on 2/18/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UROPFinalViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImage *imageStay;
@property  float rate;
@property  float coarse;
@property  int pastIts;


// making these global
@property NSMutableArray *idx;
@property float * y_r;
@property float * y_g;
@property float * y_b;

@property float * xold_r;
@property float * xold_g;
@property float * xold_b;




@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
