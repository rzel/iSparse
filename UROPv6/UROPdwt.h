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
-(COMPLEX_SPLIT)IFFTon:(COMPLEX_SPLIT )signal andLength:(int)N;
-(COMPLEX_SPLIT)FFTon:(COMPLEX_SPLIT )signal andLength:(int)N;
-(NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(long)count;
-(float *)UIImageToRawArray:(UIImage *)image;
-(UIImage *)UIImageFromRawArray:(float *)array image:(UIImage *)image forwardInverseOrNull:(NSString *)way;
-(float *)getColorPlane:(float *)array ofArea:(int)area startingIndex:(int)start into:(float *)colorPlane;
-(float *)putColorPlaneBackIn:(float *)colorPlane into:(float *)array ofArea:(long)area startingIndex:(int)start;
-(void)imageToRawArray:(UIImage*)image into:(float *)array pix:(long)count;





@end
