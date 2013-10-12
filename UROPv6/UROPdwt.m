/*
 * made by    : SparKEL Lab
 * at the     : University of Minnesota
 * advisor    : Jarvis Haupt
 * programmer : Scott Sievert
 *
 * Copyright (c) 2013 by Scott Sievert.
 *
 *
 * This file includes functions that will be helpful in the actual
 * reconstruction. This means there are heavy math functions here (Haar wavelet
 * transforms) and easier functions (putColorPlaneIn). I would have to seperate
 * files for this, but didn't want to go through the pain of making two files
 * and the related Objective-C-ickyness that goes with all of that.
 *
 * In the future, we'll have Daubachies (spelling) wavelet in here.
 *
 * --Scott Sievert, sieve121 at umn.edu
 *      2013-09-18
 *
 */

#import "UROPdwt.h"

@interface UROPdwt ()
@end

@implementation UROPdwt

// functions I couldn't find in BLAS/accelerate
-(float *)vec:(float *)x width:(int)width height:(int)height{
    // creates the vec() of a matrix. the same as trans, but renamed for clarity
    float * y = (float *)malloc(sizeof(float) * width * height);
    vDSP_mtrans(x, 1, y, 1, width, height);
    return y;
}
-(float *)trans:(float *)x width:(int)width height:(int)height{
    // creates the transpose of a 2D matrix
    float * y = (float *)malloc(sizeof(float) * width * height);
    vDSP_mtrans(x, 1, y, 1, width, height);
    return y;
}
-(int)sign:(float)x{
    if (x>=0) return 1;
    else return -1;
}

// functions to perform 1D wavelets/FFTs
-(void *)waveletOn:(float *)array ofLength:(int)N
{
    // works.
    int i;
    int length;
    float output[N];
    int length_stay = N;
    
    
    // sample code from wikipedia
    
    length = N;
    //   length = 2; // with this, function does nothing. without, does something.
    int j = 0;
    
    
    for (length = length >> 1;  ; length >>= 1){
        for (i=0; i<length; ++i) {
            float sum = (array[2*i] + array[i*2+1])/sqrt(2);
            float difference = (array[2*i] - array[i*2+1])/sqrt(2);
            output[i] = sum;
            output[length+i] = difference;
            //NSLog(@"sum: %d, difference: %d. output[][]: %f", sum, difference, output[i][m]);
        }
        
        for (i=0; i<length_stay; i++) {
            // NSLog(@"iteration: %d. array[%d] = %f", j, i, output[i]);
        }
        
        if (length == 1) {
            // perform wavelet on next color channel
            break;
        }
        j += 1;
        // swap arrays to do next iteration
        for (i=0; i<= length<<1; i++) {
            array[i] = output[i];
        }
    }
    
    
    for (i=0; i<N; i++) {
        array[i] = output[i];
    }
    
    return 0;
}
-(float *)waveletOn2DArray:(float *)array ofWidth:(long)width andHeight:(long)height
{
    // perform wavelet on 2D array
    int x = 0;
    int y = 0;
    //    float * transpose = (float *)malloc(sizeof(float) * width * height);
    float * wavelet = (float *)malloc(sizeof(float) * height);
    
    // do wavelet on each row
    for (y=0; y<height; y++) {
        for (x=0; x<width; x++) {
            wavelet[x] = array[y*width + x];
        }
        wavelet = [self singleLevelWaveletOn:wavelet ofLength:width];
        for (x=0; x<width; x++) {
            array[y*width + x] = wavelet[x];
            
        }
    }
    
    y=0;
    for (x=0; x<width; x++) {
        for (y=0; y<height; y++) {
            wavelet[y] = array[x + y*width];
        }
        
        wavelet = [self singleLevelWaveletOn:wavelet ofLength:height];
        
        for (y=0; y<height; y++) {
            array[x + y*width] = wavelet[y];
        }
    }
    free(wavelet);
    
    return array;
}
-(COMPLEX_SPLIT)IFFTon:(COMPLEX_SPLIT )signal andLength:(int)N
{
    // changelog:
    // changed signal.realp to signal->realp
    // removed & in front of signal in function calls
    
    
    // perform IFFT.
    // input = complex split vector. as in A.realp and A.imagp
    // output = complex split again, same deal.
    
    // basically, it's the sample code with A.imagp[i[ != 0
    
    
    
    
    FFTSetup        setupReal;
    uint32_t        log2n;
    uint32_t        n, nOver2;
    int32_t         stride;
    uint32_t        i;
    //    float          *originalReal, *obtainedReal;
    float           scale;
    
    // The signal is the correct signal. We are not passing memory addresses in.
    
    /* Set the size of FFT. */
    
    for (i=0; i<N; i++) {
        // NSLog(@"before any fn call: %u, %f, %f", i, signal.realp[i], signal.imagp[i]);
    }
    
    log2n = log2f(N);
    n = 1 << log2n;
    
    stride = 1;
    nOver2 = n / 2;
    nOver2 = N / 2;    // added.
    
    // signal is all set up
    signal.imagp[0] = signal.realp[nOver2];
    for (i=nOver2+1; i<N; i++) {
        signal.realp[i] = 0;
        signal.imagp[i] = 0;
    }
    signal.imagp[0] = signal.realp[nOver2];
    
    for (i=0; i<N; i++) {
        signal.realp[i] = signal.realp[i]*2;
        signal.imagp[i] = signal.imagp[i]*2;
    }
    signal.realp[nOver2] = 0;
    
    
    for (i=0; i<N; i++) {
        //NSLog(@"after setting signal up: %u, %f, %f", i, signal.realp[i], signal.imagp[i]);
    }
    
    
    if (/*originalReal == NULL || */signal.realp == NULL || signal.imagp == NULL) {
        printf("\nmalloc failed to allocate memory for  the real FFT"
               "section of the sample.\n");
        exit(0);
    }
    /* Generate an input signal in the real domain. */
    /* Look at the real signal as an interleaved complex vector  by
     * casting it.  Then call the transformation function vDSP_ctoz to
     * get a split complex vector, which for a real signal, divides into
     * an even-odd configuration. */
    
    
    
    
    /* Set up the required memory for the FFT routines and check  its
     * availability. */
    setupReal = vDSP_create_fftsetup(log2n, FFT_RADIX2);
    if (setupReal == NULL) {
        printf("\nFFT_Setup failed to allocate enough memory  for"
               "the real FFT.\n");
        exit(0);
    }
    
    
    /* Carry out a Forward and Inverse FFT transform. */
    vDSP_fft_zrip(setupReal, &signal, stride, log2n, FFT_INVERSE);
    
    
    /* Verify correctness of the results, but first scale it by  2n. */
    scale = (float) 1.0 / (2 * N );
    
    vDSP_vsmul(signal.realp, 1, &scale, signal.realp, 1, nOver2);
    
    vDSP_vsmul(signal.imagp, 1, &scale, signal.imagp, 1, nOver2);
    
    
    /* The output signal is now in a split real form.  Use the  function
     * vDSP_ztoc to get a split real vector. */
    
    COMPLEX_SPLIT copy;
    copy.realp = malloc(N*sizeof(float));
    copy.imagp = malloc(N*sizeof(float));
    
    for (i=0; i<nOver2; i++) {
        copy.realp[2*i] = signal.realp[i];
        copy.realp[2*i + 1] = signal.imagp[i];
    }
    for (i=0; i<N; i++) {
        signal.realp[i] = copy.realp[i];
        signal.imagp[i] = 0;
    }
    
    
    
    return signal;
    
    
}
-(COMPLEX_SPLIT)FFTon:(COMPLEX_SPLIT )signal andLength:(int)N
{
    // copy and pasted from "performFFTforwardWithFlow"
    // performs FFT in place, only first half of signal any good.
    
    
    uint32_t log2n = log2f(N);
    FFTSetup        setupReal;
    int32_t         stride = 1;
    uint32_t        n, nOver2;
    //   COMPLEX_SPLIT   A;
    float           scale;
    int i;
    
    
    
    //    log2n = log2f(N);
    n = 1 << log2n;
    
    stride = 1;
    nOver2 = N / 2;
    
    
    setupReal = vDSP_create_fftsetup(log2n, FFT_RADIX2);
    n = 1 << log2n;
    
    
    for (i=0; i<nOver2; i++) {
        signal.imagp[i] = signal.realp[2*i+1];
    }
    for (i=0; i<nOver2; i++) {
        signal.realp[i] = signal.realp[2*i];
    }
    for (i=nOver2; i<N; i++) {
        signal.realp[i] = 0;
        signal.imagp[i] = 0;
    }
    
    
    setupReal = vDSP_create_fftsetup(log2n, FFT_RADIX2);
    
    for (i=0; i<N; i++) {
        //NSLog(@"signal before FFT in _debug3: %d, %f, %f", i, signal.realp[i], signal.imagp[i]);
    }
    
    // performs actual fft
    
    vDSP_fft_zrip(setupReal, &signal, stride, log2n, FFT_FORWARD);
    
    
    scale = (float) 1.0 / (2 * 1);  // was n instead of 1 before; fixed with 1
    
    vDSP_vsmul(signal.realp, 1, &scale, signal.realp, 1, nOver2);
    vDSP_vsmul(signal.imagp, 1, &scale, signal.imagp, 1, nOver2);
    
    for (i=1; i<nOver2; i++) {
        // finally, the [nOver2-1-i] works
        // is there a bug the [...] business?
        signal.realp[nOver2+i] = signal.realp[nOver2-i];
        signal.imagp[nOver2+i] = -1*signal.imagp[nOver2-i];
        //                  ^ changed from A @10:25, 10.6.12
        
    }
    
    signal.realp[nOver2] = signal.imagp[0];
    signal.imagp[0] = 0;
    
    
    
    
    
    //    free(A.imagp);
    //    free(A.realp);
    
    for (i=0; i<N; i++) {
        //NSLog(@"in FFT_debug3: %d, %f, %f", i, signal.realp[i], signal.imagp[i]);
    }
    
    return signal;
}
// end of functions helpful for wavelets/FFTs

// functions to manipulate images/python stuff
-(NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(long)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ii++)    // changed from ++ii to ii++
    {
        // error here. byteIndex = 794304, 787584
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    return result;
}
-(float *)UIImageToRawArray:(UIImage *)image
{
    int length = image.size.height;
    int width  = image.size.width;
    int i;
    int area = length * width;
    float * array = (float *)malloc(sizeof(float) * 4 * area);
    float red, green, blue, alpha;
    NSArray * data = [self getRGBAsFromImage:image atX:0 andY:0 count:area];
    //   NSLog(@"----------------------");
    for (i=0; i<10; i++) {
        // NSLog(@"%@", [data objectAtIndex:i]);
        
    }
    // move data from NSArray to raw array
    int j=0;
    for (i=0; i<area; i++) {
        [[data objectAtIndex:i] getRed:&red green:&green blue:&blue alpha:&alpha];
        array[j + 0] = 255*red;
        array[j + 1] = 255*green;
        array[j + 2] = 255*blue;
        array[j + 3] = 255*alpha;
        j=j+4;
    }
    return array;
}
-(UIImage *)UIImageFromRawArray:(float *)array image:(UIImage *)image forwardInverseOrNull:(NSString *)way
{
    const size_t Width = image.size.width;
    const size_t Height = image.size.height;
    const size_t Area = Width * Height;
    const size_t ComponentsPerPixel = 4; // rgba
    
    //  uint8_t pixelData[Area * ComponentsPerPixel];
    uint8_t * pixelData = (uint8_t *) malloc(sizeof(uint8_t) * Area * ComponentsPerPixel);
    // fill the pixels with a lovely opaque blue gradient:
    //    for (size_t i=0; i < Area; ++i) {
    //        const size_t offset = i * ComponentsPerPixel;
    //        pixelData[offset] = i;
    //        pixelData[offset+1] = i;
    //        pixelData[offset+2] = i + i; // enhance blue
    //        pixelData[offset+3] = UINT8_MAX; // opaque
    //    }
    float factor;
    if ([way isEqualToString:@"forward"]) {
        factor = 0.5;
    }
    else if ([way isEqualToString:@"inverse"]) {
        factor = 2 * 1;
    }
    else {
        factor = 1;
    }
    
    
    // WARNING: added because am seeing if normalizing works
    //factor = 1;
    
    
    for (long i=0; i < Area; ++i) {
        const size_t offset = i * ComponentsPerPixel;
        pixelData[offset + 0] = array[offset + 0] *factor;
        pixelData[offset + 1] = array[offset + 1] *factor;
        pixelData[offset + 2] = array[offset + 2] *factor;
        pixelData[offset + 3] = array[offset + 3] *1;
        
    }
    
    // create the bitmap context:
    const size_t BitsPerComponent = 8;
    const size_t BytesPerRow=((BitsPerComponent * Width) / 8) * ComponentsPerPixel;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef gtx = CGBitmapContextCreate(&pixelData[0], Width, Height, BitsPerComponent, BytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    // create the image:
    CGImageRef toCGImage = CGBitmapContextCreateImage(gtx);
    UIImage * uiimage = [[UIImage alloc] initWithCGImage:toCGImage];
    
    
    
    //    image = uiimage;
    
    free(pixelData);
    
    return uiimage;
    
    // remember to cleanup your resources! :)
}
-(float *)copyArray:(float *)source intoDest:(float *)dest ofLength:(int)N
{
    for (int i=0; i<N; i++) {
        dest[i] = source[i];
    }
    
    return dest;
    
}
-(float *)getColorPlane:(float *)array ofArea:(int)area startingIndex:(int)start into:(float *)colorPlane
{
    //float * colorPlane = (float *)malloc(sizeof(float) * area);
    int j=0, i=0;
    for (i=start; i<4*area; i=i+4) {
        colorPlane[j] = array[i];
        j++;
    }
    return colorPlane;
}
-(float *)putColorPlaneBackIn:(float *)colorPlane into:(float *)array ofArea:(long)area startingIndex:(int)start
{
    int j=0, i=0;
    for (i=start; i<4*area; i=i+4) {
        array[i] = colorPlane[j];
        j++;
    }
    return array;
}

// various functions to do wavelets.
-(void *)singleLevelWaveletOn:(float *)array ofLength:(int)N
{
    // works.
    int i;
    int length;
    float * output = (float *) malloc(sizeof(float) * N);
    //    int length_stay = N;
    if (output == NULL) {
        NSLog(@"\nmalloc failed to allocate memory for  the real FFT"
              "section of the sample.\n");
        exit(0);
    }
    
    // sample code from wikipedia
    
    length = N;
    //   length = 2; // with this, function does nothing. without, does something.
    int j = 0;
    
    length = length>>1;
    //    for (length = length >> 1;  ; length >>= 1){
    for (i=0; i<length; ++i) {
        float sum = (array[2*i] + array[i*2+1])/sqrt(2);
        float difference = (array[2*i] - array[i*2+1])/sqrt(2);
        output[i] = sum;
        output[length+i] = difference;
        //NSLog(@"sum: %d, difference: %d. output[][]: %f", sum, difference, output[i][m]);
    }
    
    
    j += 1;
    // swap arrays to do next iteration
    for (i=0; i</*=*/ length<<1; i++) {
        array[i] = output[i];
    }
    //    }
    
    
    for (i=0; i<N; i++) {
        array[i] = output[i];
    }
    free(output);
    return array;
}
-(float *)waveletOn2DArray:(float *)array ofWidth:(long)width andHeight:(long)height ofOrder:(int)order divide:(NSString *)div
{
    // perform wavelet on 2D array
    float factor = 1;
    if ([div isEqualToString:@"image"]) {
        factor = 0.5;
    }
    int x = 0;
    int y = 0;
    //    float * transpose = (float *)malloc(sizeof(float) * width * height);
    float * wavelet = (float *)malloc(sizeof(float) * height * width);
    int i=0;
    int k;
    for (k=0;  k<order; k++) {
        // copy array over
        i=0;
        for (x=0; x< width>>k; x++) {
            for (y=0; y< height>>k; y++) {
                wavelet[i] = array[y*width + x];
                i++;
            }
        }
        // end copy
        // perform wavelet
        wavelet = [self waveletOn2DArray:wavelet ofWidth:width>>k andHeight:height>>k];
        for (i=0; i<width*height; i++) {
            wavelet[i] = wavelet[i] * factor;
        }
        
        // copy array over (wavelet into array)
        i=0;
        for (x=0; x< width>>k; x++) {
            for (y=0; y< height>>k; y++) {
                array[y*width + x] = wavelet[i];
                i++;
            }
        }
        
    }
    
    
    free(wavelet);
    return array;
}
-(UIImage *)waveletOnImage:(UIImage *)image ofOrder:(int)order
{
    int height  = image.size.height;
    int width   = image.size.width;
    int area    = height * width;
    //    int i
    int n;
    //    float red, green, blue, alpha;
    float * array = (float *)malloc(sizeof(float) * area * 4);
    float * colorPlane = (float *)malloc(sizeof(float) * area);
    
    if (array == NULL || colorPlane == NULL) {
        NSLog(@"\n error in malloc! array and colorPlane failed. \n");
    }
    
    
    // get data
    array = [self UIImageToRawArray:image];
    //    int j;
    //float max, min;
    // end making raw array
    // begin the wavelet part
    
    // perform wavelet, 2D on image
    // using color planes, all of that
    for (n=0; n<4; n++) {
        /* there is probably a bug in here in converting to an image: it's converting 0xffff to 0x00ff.
         So, I should normalize the image beforehand, storing the max and min then unnormalize later.
         */
        colorPlane = [self getColorPlane:array ofArea:area startingIndex:n into:colorPlane];
        
        colorPlane = [self waveletOn2DArray:colorPlane ofWidth:width andHeight:height ofOrder:order divide:@"image"]; // change from null to image if want /2
        //colorPlane = [self inverseOn2DArray:colorPlane ofWidth:width andHeight:height ofOrder:order multiply:@"null"];
        //colorPlane = [self normalize:colorPlane ofLength:area max:max min:min];
        array      = [self putColorPlaneBackIn:colorPlane into:array ofArea:area startingIndex:n];
    }
    for (int i=0; i<4*area; i++){
        //array[i] = array[i]/powf(2, order);
    }
    
    //array = [self normalize:array ofLength:4*area];
    
    
    for (long i=3; i<4*area; i=i+4)
    {
        array[i] = 255;
    }
    
    for (int i=0; i<4*area; i=i+4) {
        //NSLog(@"%d %f %f %f %f", i, array[i], array[i+1], array[i+2], array[i+3]) ;
    }
    
    
    
    // end wavelet part
    // return image
    image = [self UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
    
    free(array);
    free(colorPlane);
    
    //    data = [self getRGBAsFromImage:image atX:0 andY:0 count:area];
    //    for (long x=0; x<width; x++)
    //    {
    //        for (long y=0; y<height; y++) {
    //            //NSLog(@"x: %d. y: %d. color = %@", x, y, [data objectAtIndex:y*width + x]);
    //        }
    //    }
    
    
    
    return image;
}
-(float *)inverseWaveletOn:(float *)array ofLength:(int)N
{
    // works!
    /*
     we have an array like so:
     [(0)  (1)  (2)  (3)  (4)  (5)  (6)  (7)]
     the wavelet on this is:
     [0+1  2+3  4+5  6+7  0-1  2-3  4-5  6-7]
     [ a    b    c    d    e    f    g    h ]
     indicies:
     0   1     2    3    4    5    6   7
     
     a + e = 0+1+0-1   = _2*0
     a - e = 0+1-0+1   = _2*1
     b + f = 2+3 + 2-3 = _2*2
     b - f = 2+3 - 2+3 = _2*3
     
     so this is index 0 and 4
     1 and 5
     2 and 6
     which is just index + 4
     shift = N>>2 = len(signal)/2 = shift
     
     */
    int i, j, shift;
    
    for (i=0; i<N; i++) {
        //NSLog(@"array[%d] = %f", i, array[i]);
    }
    
    float sum, difference;
    float * output = (float *)malloc(sizeof(float) * N);
    shift = N >> 1;
    /*
     signal of length 8
     need the following:
     i = 0; 0 and 4
     i = 1; 1 and 5
     i = 2; 2 and 6
     
     this is i and i+4
     
     */
    j=0;
    for (i=0; i< (N>>1); i++) {
        sum = (array[i] + array[i+shift]) /sqrt(2);
        difference = (array[i] - array[i+shift]) /sqrt(2);
        output[j] = sum;
        output[j+1] = difference;
        j += 2;
        
    }
    //NSLog(@"\n\n");
    for (i=0; i<N; i++) {
        array[i] = output[i];
    }
    free(output);
    
    return array;
    
}
-(float *)inverseOn2DArray:(float *)array ofWidth:(int)width andHeight:(int)height
{
    /* assumes the array is ordered like so:
     0 1 2 3 4
     5 6 7 8 9
     ...
     by rows then columns
     */
    int x, y;
    
    
    float * wavelet = (float *)malloc(sizeof(float) * width);
    for (y=0; y<height; y++) {
        for (x=0; x<width; x++) {
            wavelet[x] = array[y*width + x];
        }
        wavelet = [self inverseWaveletOn:wavelet ofLength:width];
        for (x=0; x<width; x++) {
            array[y*width + x] = wavelet[x];
        }
    }
    
    for (x=0; x<width; x++)
    {
        for (y=0; y<height; y++) {
            wavelet[y] = array[y*width + x];
        }
        wavelet = [self inverseWaveletOn:wavelet ofLength:width];
        for (y=0; y<height; y++) {
            array[y*width + x] = wavelet[y];
        }
    }
    free(wavelet);
    return array;
}
-(UIImage *)inverseWaveletOnImage:(UIImage *)image ofOrder:(int)order
{
    int height  = image.size.height;
    int width   = image.size.width;
    int area    = height * width;
    int i, n;
    //    float red, green, blue, alpha;
    float * array = (float *)malloc(sizeof(float) * area * 4);
    float * colorPlane = (float *)malloc(sizeof(float) * area);
    
    if (array == NULL || colorPlane == NULL) {
        NSLog(@"\n error in malloc! array and colorPlane failed. \n");
    }
    array = [self UIImageToRawArray:image];
    for (n=0; n<4; n++) {
        colorPlane = [self getColorPlane:array ofArea:area startingIndex:n into:colorPlane];
        // colorPlane = [self unNormalize:colorPlane ofLength:area max:*max min:*min];
        colorPlane = [self inverseOn2DArray:colorPlane ofWidth:width andHeight:height ofOrder:order multiply:@"image"]; // change from null to image if want *2
        array      = [self putColorPlaneBackIn:colorPlane into:array ofArea:area startingIndex:n];
    }
    
    
    for (int i=0; i<4*area; i++){
        //array[i] = array[i]*4;
        //NSLog(@"%d, %f")
    }
    if (order == -1) {
        for (i=0; i<4*area; i++) {
            array[i] = array[i]/2;
        }
    }
    for (long i=3; i<4*area; i=i+4)
    {
        array[i] = 255;
    }
    
    
    
    
    
    // end wavelet part
    // return image
    // inverse
    image = [self UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
    
    free(array);
    free(colorPlane);
    
    //        data = [self getRGBAsFromImage:image atX:0 andY:0 count:area];
    //        for (long x=0; x<width; x++)
    //        {
    //            for (long y=0; y<height; y++) {
    //                //NSLog(@"x: %d. y: %d. color = %@", x, y, [data objectAtIndex:y*width + x]);
    //            }
    //        }
    
    
    
    return image;
}
-(float *)inverseOn2DArray:(float *)array ofWidth:(int)width andHeight:(int)height ofOrder:(int)order multiply:(NSString *)mul
{
    /* assumes the array is ordered like so:
     0 1 2 3 4
     5 6 7 8 9
     ...
     by rows then columns
     */
    
    // work on this function Thursday 11.8.12
    float factor = 1;
    if ([mul isEqualToString:@"image"]) {
        factor = 2;
    }
    
    int x, y;
    float * wavelet = (float *)malloc(sizeof(float) * height * width);
    int k, i;
    for (k=order; k>0; k--) {                       // check
        // copy array over
        i=0;
        for (y=0; y< height>>(k-1); y++) {
            for (x=0; x< width>>(k-1); x++) {
                wavelet[i] = array[y*width + x];
                i++;
            }
        }
        int max=i;
        
        // end copy
        // perform wavelet
        wavelet = [self inverseOn2DArray:wavelet ofWidth:width>>(k-1) andHeight:height>>(k-1)];
        for (i=0; i<width*height; i++) {
            wavelet[i] = wavelet[i] * factor;
        }
        // copy array over (wavelet into array)
        i=0;
        for (y=0; y< height>>(k-1); y++) {
            for (x=0; x< width>>(k-1); x++) {
                array[y*width + x] = wavelet[i];
                i++;
            }
        }
        max = x;
        float maxy = y;
        //NSLog(@"------ start -------. k = %d", k);
        for (y=0; y<maxy; y++) {
            for (x=0; x<max; x++) {
                //NSLog(@"array[%d*width + %d] = %f", y, x, array[y*width + x]);
            }
        }
        
        //NSLog(@"------ end -------");
        
    }
    
    
    
    free(wavelet);
    
    return array;
}
// end of various functions for wavelets

// functions that came prepackaged in XCode, do nothing, and weren't edited.
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
