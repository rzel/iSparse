//
//  UROPbrain.h
//  UROPv1
//
//  Created by Scott Sievert on 1/13/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Accelerate/Accelerate.h"


@interface UROPbrain : NSObject

-(UIImage *)recontructImage:(UIImage *)image iterations:(int)N atRate:(float)rate;
-(UIImage *)sampleImage:(UIImage *)image atRate:(float)rate;
-(float *)IHT2_v2:(float *)signal
         ofLength:(int)N
        iteration:(int)iter
          ofWidth:(int)width
         ofHeight:(int)height
            order:(int)order
           atRate:(float)p
 withMeasurements:(float *)y ofLength:(float)measurement_length
             xold:(float *)xold
              idx:(NSMutableArray *)idx;
-(UIImage *)recontructImage_v2:(UIImage *)image
                    iterations:(int)N
                        atRate:(float)rate
                withCoarseness:(float)coarse
              withMeasurements:(float *)y
                      ofLength:(int)measurement_length
                          xold:(float *)xold
                           idx:(NSMutableArray *)idx;
-(UIImage *)doWaveletKeepingLargestKTerms:(UIImage *)image
                                   coarse:(float)coarse;
-(float *)UIImageToRawArray:(UIImage *)image;
-(float *)makeMeasurementsOf:(UIImage *)image atRate:(float)p length:(int)length into:(NSMutableArray *)idx;
-(float *)IHT2_v3:(float *)signal ofLength:(int)N
        iteration:(int)iter
          ofWidth:(int)width ofHeight:(int)height order:(int)order
           atRate:(float)p
             xold:(float *)xold
                y:(float *)y measurementLength:(int)measurementLength
              idx:(NSMutableArray *)idx;
-(void)makeIDX:(NSMutableArray *)idx ofLength:(int)pix;
-(void)makeMeasurements:(UIImage *)image atRate:(float)rate
                   into:(float *)red_y into:(float *)blue_y
                   into:(float *)green_y
               ofLength:(int)length
                    idx:(NSMutableArray *)idx;
-(UIImage *)reconstruct:(UIImage *)image
                 coarse:(float)coarse
                    idx:(NSMutableArray *)idx
                  red_y:(float *)red_y green_y:(float *)green_y blue_y:(float *)blue_y
                   rate:(float)rate
                 xold_r:(float *)xold_r
                 xold_g:(float *)xold_g
                 xold_b:(float *)xold_b;
-(void)makeMeasurements:(UIImage *)image atRate:(float)rate
                   into:(float *)y
               ofLength:(int)length
                    idx:(NSMutableArray *)idx;
-(UIImage *)reconstruct:(UIImage *)image
                 coarse:(float)coarse
                    idx:(NSMutableArray *)idx
                      y:(float *)y
                   rate:(float)rate
                   xold:(float *)xold;
-(void)makeMeasurements:(UIImage *)image atRate:(float)rate
                    red:(float *)y_r green:(float *)y_b
                   blue:(float *)y_g
               ofLength:(int)length
                    idx:(NSMutableArray *)idx;
-(UIImage *)reconstruct2:(UIImage *)image
                 coarse:(float)coarse
                    idx:(NSMutableArray *)idx
                    y_r:(float *)y_r y_g:(float *)y_g y_b:(float *)y_b
                   rate:(float)rate
                 xold_r:(float *)xold_r
                 xold_g:(float *)xold_g
                  xold_b:(float *)xold_b
              iterations:(int)its pastIterations:(int)pastIts;
-(UIImage *)reconstructWithIST:(UIImage *)image
                        coarse:(float)coarse
                           idx:(NSMutableArray *)idx
                           y_r:(float *)y_r y_g:(float *)y_g y_b:(float *)y_b
                          rate:(float)rate
                        xold_r:(float *)xold_r xold1_r:(float *)xold1_r
                        xold_g:(float *)xold_g xold1_g:(float *)xold1_g
                        xold_b:(float *)xold_b xold1_b:(float *)xold1_b
                    iterations:(int)its pastIterations:(int)pastIts tn:(float *)tn;
@end
