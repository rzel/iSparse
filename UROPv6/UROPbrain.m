/*
 *  Made by    : SparKEL Lab
 *  at the     : University of Minnesota
 *  advisor    : Jarvis Haupt
 *  programmer : Scott Sievert
 *  Copyright (c) 2013 by Scott Sievert. All rights reserved.
 *
 *  This file is best viewed when you fold all the functions; there are many
 *  many functions and the most important ones are at the bottom of the file.
 *  Additionally, there are comments starting with "the following
 *  functions...". Use your editors fold mode to get a grasp of the file before
 *  you make any edits.
 *
 *  The most important functions -- the purpose of this file, really --
 *  reconstructWithIST (the second to last function). It takes in a UIImage and
 *  converts to RGB then actually calls the reconstruction algorithm function,
 *  IST.
 *
 *  --Scott Sievert (sieve121 at umn.edu), 2013-09-17
 *
 */
#import "UROPbrain.h"

@implementation UROPbrain

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
-(COMPLEX_SPLIT *)IFFTon:(COMPLEX_SPLIT )signal andLength:(int)N
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

    
    
    return &signal;
    
    
}
-(COMPLEX_SPLIT *)FFTon:(COMPLEX_SPLIT )signal andLength:(int)N
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
    
    return &signal;
}

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
    CGContextRef gtx = CGBitmapContextCreate(&pixelData[0], Width, Height, BitsPerComponent, BytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
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
        for (y=0; y< height>>k-1; y++) {
            for (x=0; x< width>>k-1; x++) {
                wavelet[i] = array[y*width + x];
                i++;
            }
        }
        int max=i;
        
        // end copy
        // perform wavelet
        wavelet = [self inverseOn2DArray:wavelet ofWidth:width>>k-1 andHeight:height>>k-1];
        for (i=0; i<width*height; i++) {
            wavelet[i] = wavelet[i] * factor;
        }
        // copy array over (wavelet into array)
        i=0;
        for (y=0; y< height>>k-1; y++) {
            for (x=0; x< width>>k-1; x++) {
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

// functions to sample the image for the initial viewing.
-(float *)sample:(float *)array atRate:(float)rate ofLength:(int)n
{
    srandom(42);
    srand(42);

    for (int i=0; i<n; i++) {
        float ra = (float)(rand() % n)/n;
        if (ra > rate) {
            array[i] = 0;
        }
    }

    return array;
    
}
-(UIImage *)sampleImage:(UIImage *)image atRate:(float)rate
{
    float pix = image.size.width * image.size.height;
    int n, i;
    float * colorPlane = (float *)malloc(sizeof(float) * pix);
    float * array = (float *)malloc(sizeof(float) * pix * 4);
    array = [self UIImageToRawArray:image];
    srandom(42);
    for (n=0; n<3; n++) {

        colorPlane = [self getColorPlane:array ofArea:pix startingIndex:n into:colorPlane];

        
        colorPlane = [self sample:colorPlane atRate:rate ofLength:pix];
        for ( i=0; i<10; i++) {
        }

        //colorPlane = [self normalize:colorPlane ofLength:area max:&max min:&min];
        array      = [self putColorPlaneBackIn:colorPlane into:array ofArea:pix startingIndex:n];
    }
    image = [self UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
    free(array);
    free(colorPlane);
    return image;
}
-(void)makeIDX:(NSMutableArray *)idx ofLength:(int)pix
{
    srand(42);
    int i;
    for (i=0; i<pix; i++) {
        [idx addObject:[NSNumber numberWithInt:i]];
    }
    srandom(42); srand(42); // 'srand' works
    for (i=0; i<pix; i++) {
        int index = random() % pix;
        [idx exchangeObjectAtIndex:i withObjectAtIndex:index];
    }
   // NSLog(@"-----------");
    for (i=0; i<5; i++) {
       // NSLog(@"%@", [idx objectAtIndex:i]);

    }
    
}

// another init. actual take in what you view.
-(void)makeMeasurements:(UIImage *)image atRate:(float)rate
                   red:(float *)y_r green:(float *)y_b
                   blue:(float *)y_g
               ofLength:(int)length
                    idx:(NSMutableArray *)idx
{
    int pix = image.size.height * image.size.width;
    float * array = (float *)malloc(sizeof(float) * pix * 4);
    float * colorPlane = (float *)malloc(sizeof(float) * pix);
    // get data
    array = [self UIImageToRawArray:image];
    int j, n;
    //float max, min;
    // end making raw array
    // begin the wavelet part
    
    // perform wavelet, 2D on image
    // using color planes, all of that
    for (n=0; n<3; n++) {
        
        colorPlane = [self getColorPlane:array ofArea:pix startingIndex:n into:colorPlane];
        
        // the do-what-you-want code should go here.
        if (n == 0) {
            for (j=0; j<rate * pix; j++) {
                int index = [[idx objectAtIndex:j] intValue];
                y_r[j] = colorPlane[index];
            }
        }
        if (n == 1) {
            for (j=0; j<rate * pix; j++) {
                int index = [[idx objectAtIndex:j] intValue];
                y_b[j] = colorPlane[index];
            }
        }
        if (n == 2) {
            for (j=0; j<rate * pix; j++) {
                int index = [[idx objectAtIndex:j] intValue];
                y_g[j] = colorPlane[index];
            }
        }
        
        
        // end of do what you want
        
        array      = [self putColorPlaneBackIn:colorPlane into:array ofArea:pix startingIndex:n];
    }
    
    
    
    for (long i=3; i<4*pix; i=i+4)
    {array[i] = 255;}
    // return image
    image = [self UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
    free(array);
    free(colorPlane);
    
    
}


-(float)IST:(float *)signal ofLength:(int)N
    ofWidth:(int)width ofHeight:(int)height order:(int)order
  iteration:(int)iter
     atRate:(float)p
       xold:(float *)xold xold1:(float *)xold1
          y:(float *)y
        idx:(NSMutableArray *)idx coarse:(float)coarse numberOfPastIterations:(int)pastIts
         tn:(float)tn
{
    // the function performs the "fast iterative soft thresholding algorithm (FISTA)". This is the meat of the code -- this is where your actual algorithm implementation goes. The rest is just (complicated) wrapper for this.
    float * t1 = (float *)malloc(sizeof(float) * N);
    float * temp = (float *)malloc(sizeof(float) * N);
    float * temp2 = (float *)malloc(sizeof(float) * N);
    float * temp3 = (float *)malloc(sizeof(float) * N);
    float * temp4 = (float *)malloc(sizeof(float) * N);
    float * tt = (float *)malloc(sizeof(float) * N);
    // allocations for T(.)
    float tn1;
    int i, index;
    float l = 15;
    for (int its=0; its<iter; its++) {
        tn1 = (1+sqrt(1+4*tn*tn))/2;
        // tn1 = tn_{k+1}. computing the tn
        
        // xold1 = xold_{k-1}
        // "calling" T(.) with a new xold
        for (i=0; i<N; i++)
        {xold[i] = xold[i] + ((tn - 1.0)/tn1) * (xold[i] - xold1[i]);} // check
        
        // implementing T(.) (could be a function)
        for (i=0; i<N; i++) {t1[i] = xold[i];}
        
        t1 = [self inverseOn2DArray:t1 ofWidth:width andHeight:height ofOrder:order multiply:@"null"];
        
        //          temp = t1(rp(1:floor(p*n)));
        for (i=0; i<p*N; i++) {
            index = [[idx objectAtIndex:i] intValue];
            temp[i] = t1[index];}
        
        
        //         temp2 = y-temp;
        for (i=0; i<p*N; i++) {
            temp2[i] = y[i] - temp[i];}
        
        
        //          temp3 = zeros(size(I3));
        for (i=0; i<N; i++) {
            temp3[i] = 0;}
        //          temp3(rp(1:floor(p*n))) = temp2;
        for (i=0; i<p*N; i++) {
            index = [[idx objectAtIndex:i] intValue];
            temp3[index] = temp2[i];}
        
        
        //          temp3 = dwt2_full(temp3);
        temp3 = [self waveletOn2DArray:temp3 ofWidth:width andHeight:height ofOrder:order divide:@"null"];
        
        
        //          temp4 = xold + temp3;
        for (i=0; i<N; i++) {
            //temp4[i] = xold[i] + temp3[i];
            temp4[i] = xold[i] + temp3[i];
        }
        for (i=0; i<N; i++) {
            //temp4[i] = xold[i] + temp3[i];
            xold[i] = temp4[i]; // probably unnecassary
        }
        // the end of T(.)
        
        // use iterative soft thresholding
        // look at each value, and see if abs() is less than l
        for (i=0; i<N; i++) {
            if (abs(xold[i]) < l) {
                xold[i] = 0;
            } else xold[i] = xold[i] - copysignf(1, xold[i]) * l;
        }
        
        // updating the past iteration
        for (i=0; i<N; i++) {
            xold1[i] = xold[i];
            xold[i] = xold[i]; // not nesecarry...
            // updating xold_{n-1} = xold_n            
        }
        // updating the tn
        tn = tn1;
        // updating tn = tn_{n+1}
    }
    
    free(temp);
    free(temp2);
    free(temp4);
    free(temp3);
    free(tt);
    free(t1);
    return tn;
    
    
}

-(float *)T:(float *)xold width:(int)width height:(int)height order:(int)order
    // an unused, hence untested, function.
          y:(float *)y
        idx:(NSMutableArray *)idx
{
    int i=0;
    int index;
    int n=width*height;
    float * temp  = (float *)malloc(sizeof(float) * n);
    float * temp1 = (float *)malloc(sizeof(float) * n);
    float * temp2 = (float *)malloc(sizeof(float) * n);
    float * temp3 = (float *)malloc(sizeof(float) * n);
    float * temp4 = (float *)malloc(sizeof(float) * n);
    //float * xnew = (float *)malloc(sizeof(float) * n);
    temp1 = [self inverseOn2DArray:xold ofWidth:width andHeight:height ofOrder:order multiply:@"null"];
    for (i=0; i<[idx count]; i++) {
        index = [[idx objectAtIndex:i] intValue];
        temp[i] = temp1[index];
    }
    for (i=0; i<[idx count]; i++) {
        //index = [[idx objectAtIndex:i] intValue];
        temp2[i] = y[i] - temp[i];
    }
    for (i=0; i<n; i++) {
        temp3[i] = 0;
    }
    for (i=0; i<[idx count]; i++) {
        index = [[idx objectAtIndex:i] intValue];
        temp3[index] = temp2[i];
    }
    [self waveletOn2DArray:temp3 ofWidth:width andHeight:height ofOrder:order divide:@"null"];
    for (i=0; i<n; i++) {
        //index = [[idx objectAtIndex:i] intValue];
        temp4[i] = xold[i] + temp3[i];
    }
    for (i=0; i<n; i++) {
        //xnew[i] = temp4[i];
        xold[i] = temp4[i];
    }
    free(temp);
    free(temp1);
    free(temp2);
    free(temp3);
    free(temp4);
    //return xnew;
}


-(UIImage *)reconstructWithIST:(UIImage *)image
                  coarse:(float)coarse
                     idx:(NSMutableArray *)idx
                     y_r:(float *)y_r y_g:(float *)y_g y_b:(float *)y_b
                    rate:(float)rate
                  xold_r:(float *)xold_r xold1_r:(float *)xold1_r
                  xold_g:(float *)xold_g xold1_g:(float *)xold1_g
                  xold_b:(float *)xold_b xold1_b:(float *)xold1_b
              iterations:(int)its pastIterations:(int)pastIts tn:(float *)tn
{
    static int logPastIts=0;
    logPastIts++;
    NSLog(@"%d", logPastIts);
    // We need no image-to-array function, as the arrays are held in the view controller.
    int height = image.size.height;
    int width = image.size.width;
    int order = log2(width);
    int pix = height * width;
    
    
    // get data
    //    array = [self UIImageToRawArray:image];
    int i, n;
    //float max, min;
    // end making raw array
    // begin the wavelet part
    
    // perform wavelet, 2D on image
    // using color planes, all of that
    if (width < 256){
        //NSLog(@"returned a small image");
        image = [UIImage imageNamed:@"one.jpg"];
        //NSLog(@"%@", image);
        return image;
    } else{
        float * array = (float *)malloc(sizeof(float) * pix * 4);
        float * colorPlane = (float *)malloc(sizeof(float) * pix);
        float * xold = (float *)malloc(sizeof(float) * pix);
        float * xold1 = (float *)malloc(sizeof(float) * pix);
        float * y = (float *)malloc(sizeof(float) * pix);
        float tnf = *tn;
        
        for (n=0; n<3; n++) {
            
            
            // properly init
            if (n==0) {
                for (i=0; i<rate*pix; i++) {y[i]    = y_r[i];}
                for (i=0; i<pix;      i++) {xold[i] = xold_r[i];}
                for (i=0; i<pix;      i++) {xold1[i] = xold1_r[i];}
            } else  if (n==1) {
                for (i=0; i<rate*pix; i++) {y[i]    = y_g[i];}
                for (i=0; i<pix;      i++) {xold[i] = xold_g[i];}
                for (i=0; i<pix;      i++) {xold1[i] = xold1_g[i];}

            } else if (n==2) {
                for (i=0; i<rate*pix; i++) {y[i]    = y_b[i]; }
                for (i=0; i<pix;      i++) {xold[i] = xold_b[i];}
                for (i=0; i<pix;      i++) {xold1[i] = xold1_b[i];}

            }
            
            // the do-what-you-want code should go here. actually performing the algorithm.
            tnf = [self IST:xold ofLength:pix ofWidth:width ofHeight:height
                     order:order iteration:its atRate:rate
                      xold:xold xold1:xold1 y:y idx:idx
                    coarse:coarse numberOfPastIterations:0 tn:tnf];
            
            // and then update
            if (n==0) {
                for (i=0; i<rate*pix; i++) {y_r[i]    = y[i];}
                for (i=0; i<pix;      i++) {xold_r[i] = xold[i];}
                for (i=0; i<pix;      i++) {xold1_r[i] = xold1[i];}
            } else if (n==1) {
                for (i=0; i<rate*pix; i++) {y_g[i]    = y[i];}
                for (i=0; i<pix;      i++) {xold_g[i] = xold[i];}
                for (i=0; i<pix;      i++) {xold1_g[i] = xold1[i];}

            } else if (n==2) {
                for (i=0; i<rate*pix; i++) {y_b[i]    = y[i];}
                for (i=0; i<pix;      i++) {xold_b[i] = xold[i];}
                for (i=0; i<pix;      i++) {xold1_b[i] = xold1[i];}

            }
            
            // end of do what you want
            [self inverseOn2DArray:xold ofWidth:width andHeight:height ofOrder:order multiply:@"null"];
            
            array      = [self putColorPlaneBackIn:xold into:array ofArea:pix startingIndex:n];
        }
        *tn = tnf;
        
        image = [self UIImageFromRawArray:array image:image forwardInverseOrNull:@"null"];
        
        
        free(array);
        free(colorPlane);
        free(y);
        free(xold);
        free(xold1);
        return image;
    }
    
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
