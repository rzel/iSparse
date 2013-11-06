//
//  UROPbrain.h
//  UROPv1
//
//  Created by Scott Sievert on 1/13/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Accelerate/Accelerate.h"

// the libschitz constant
#define LIP 2.0f

// how many levels are we going to throw away?
//#define LEVELS 5.0f

// sampling rate
#define P 0.55

// everything below this is set to 0.
#define LAMBDA 18



@interface UROPbrain : NSObject


-(UIImage *)sampleImage:(UIImage *)image atRate:(float)rate;
-(UIImage *)doWaveletKeepingLargestKTerms:(UIImage *)image
                                   coarse:(float)coarse;
-(void)makeIDX:(NSMutableArray *)idx ofLength:(int)pix;
-(void)makeMeasurements:(UIImage *)image atRate:(float)rate
                    red:(float *)y_r green:(float *)y_b
                   blue:(float *)y_g
               ofLength:(int)length
                    idx:(NSMutableArray *)idx;
-(void)makeMeasurements2:(UIImage *)image atRate:(float)rate
                     red:(float *)y_r green:(float *)y_b blue:(float *)y_g
                ofLength:(int)length idx:(int *)idx;
-(UIImage *)reconstructWithIST:(UIImage *)image
                        coarse:(float)coarse
                           idx:(NSMutableArray *)idx
                           y_r:(float *)y_r y_g:(float *)y_g y_b:(float *)y_b
                          rate:(float)rate
                        xold_r:(float *)xold_r xold1_r:(float *)xold1_r
                        xold_g:(float *)xold_g xold1_g:(float *)xold1_g
                        xold_b:(float *)xold_b xold1_b:(float *)xold1_b
                    iterations:(int)its pastIterations:(int)pastIts tn:(float *)tn;

-(UIImage *)reconstructWithFISTA:(UIImage *)image
                          Xhat_r:(float *)Xhat_r Xhat_g:(float *)Xhat_g Xhat_b:(float *)Xhat_b
                         samples:(int *)samples
                             y_r:(float *)y_r y_g:(float *)y_g y_b:(float *)y_b
                            y2_r:(float *)y2_r y2_g:(float *)y2_g y2_b:(float *)y2_b
                             x_r:(float *)x_r x_g:(float *)x_g x_b:(float *)x_b
                           b_t_r:(float *)b_t_r  b_t_g:(float *)b_t_g  b_t_b:(float *)b_t_b
                             t_r:(float *)t_r t_g:(float *)t_g t_b:(float *)t_b
                               M:(int)M N:(int)N k:(int)k m:(int)m levels:(int)levels;
@end
