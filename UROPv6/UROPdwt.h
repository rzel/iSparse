//
//  UROPdwt.h
//  Reconstruct
//
//  Created by Scott Sievert on 9/18/13.
//  Copyright (c) 2013 com.scott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Accelerate/Accelerate.h"

@interface UROPdwt : UIViewController

-(float *)vec:(float *)x width:(int)width height:(int)height;
-(float *)trans:(float *)x width:(int)width height:(int)height;
-(float *)vec:(float *)x toX:(int)xLimit toY:(int)yLimit width:(int)width height:(int)height;
-(int)sign:(float)x;
-(void)waveletOn:(float *)array ofLength:(int)N;
-(float *)waveletOn2DArray:(float *)array ofWidth:(long)width andHeight:(long)height;
-(COMPLEX_SPLIT)IFFTon:(COMPLEX_SPLIT )signal andLength:(int)N;
-(COMPLEX_SPLIT)FFTon:(COMPLEX_SPLIT )signal andLength:(int)N;
-(NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(long)count;
-(float *)UIImageToRawArray:(UIImage *)image;
-(UIImage *)UIImageFromRawArray:(float *)array image:(UIImage *)image forwardInverseOrNull:(NSString *)way;
-(float *)copyArray:(float *)source intoDest:(float *)dest ofLength:(int)N;
-(float *)getColorPlane:(float *)array ofArea:(int)area startingIndex:(int)start into:(float *)colorPlane;
-(float *)putColorPlaneBackIn:(float *)colorPlane into:(float *)array ofArea:(long)area startingIndex:(int)start;
-(void *)singleLevelWaveletOn:(float *)array ofLength:(int)N;
-(float *)waveletOn2DArray:(float *)array ofWidth:(long)width andHeight:(long)height ofOrder:(int)order divide:(NSString *)div;
-(UIImage *)waveletOnImage:(UIImage *)image ofOrder:(int)order;
-(float *)inverseWaveletOn:(float *)array ofLength:(int)N;
-(float *)inverseOn2DArray:(float *)array ofWidth:(int)width andHeight:(int)height;
-(UIImage *)inverseWaveletOnImage:(UIImage *)image ofOrder:(int)order;
-(float *)inverseOn2DArray:(float *)array ofWidth:(int)width andHeight:(int)height ofOrder:(int)order multiply:(NSString *)mul;





@end
