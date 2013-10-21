




#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include "Accelerate/Accelerate.h"

// the nice stuff python has
void getCol(float * in, int col, float * out, int width, int height);
void getRow(float * in, int row, float * out, int width, int height);
void putColIn(float * col, float colNumber, float * arr, int width, int height);
void putRowIn(float * row, float rowNumber, float * arr, int width, int height);
void copyPartsOfArray(float * in, float * out, int maxX, int maxY, int width, int height);
void copyPartsOfArrayInverse(float * in, float * out, int maxX, int maxY, int width, int height);
void copyArray(float * in, float * out, int len);
void swap(int * one, int * two);
void shuffle(int * in, int len);
void copySelectedInstances(float * in, float * out, int * indicies, int len);
float S2sign(float x);
float std(float * array, int N);
void copy(float * source, float * dest, int N);

// the actual dwt/idwt
float * dwt2(float * x, float * y, int width, int height);
void * dwt(float * x, int N, float * y);
float * dwt2_full(float * x,  int width, int height);
float * idwt(float * x, int N, float * y);
float * idwt2(float * x, float * y, int width, int height);
float * idwt2_full(float * x, int width, int height);
float *vec(float * x, int width, int height);

void * dwt(float * x, int N, float * y){
    // N must be a factor of two
    float * one = (float *)malloc(sizeof(float) * N/2);
    float * two = (float *)malloc(sizeof(float) * N/2);
    float * low = (float *)malloc(sizeof(float) * N/2);
    float * high = (float *)malloc(sizeof(float) * N/2);
    float * w = (float *)malloc(sizeof(float) * N/1);
    
    // getting every other elemeNt
    cblas_scopy(N/2, x, 2, one, 1);
    cblas_scopy(N/2, x+1, 2, two, 1);
    
    // adding those elemeNts
    cblas_scopy(N/2, two, 1, low, 1);
    cblas_scopy(N/2, two, 1, high, 1);
    catlas_saxpby(N/2, 1, one, 1, 1, low, 1);
    catlas_saxpby(N/2, 1, one, 1, -1, high, 1);
    
    cblas_scopy(N/2, low, 1, w, 1);
    cblas_scopy(N/2, high, 1, w+N/2, 1);
    cblas_sscal(N, 1.0f/sqrt(2), w, 1);
    cblas_scopy(N, w, 1, y, 1);
    
    free(one);
    free(two);
    free(low);
    free(high);
    free(w);
    
    return (void*)0xbad;

}
float * dwt2(float * x, float * y, int width, int height){
    // x is our input
    // y is our output
    int i;

    // our row
    float * k  = (float *)malloc(sizeof(float) * width);
    float * k1 = (float *)malloc(sizeof(float) * width);

    for (i=0; i<height; i++){
        getRow(x, i, k, width, height);
        dwt(k, width, k1);
        putRowIn(k1, i, y, width, height);
    }
    for (i=0; i<width; i++){
        getCol(y, i, k, width, height);
        dwt(k, height, k1);
        putColIn(k1, i, y, width, height);
    }
    free(k);
    free(k1);
    // return value just to get rid of error
    return k;
}
float * dwt2_full(float * x, int width, int height){
    // overwrites x
    int k;
    int order = log2(width);
    float * wavelet = (float *)malloc(sizeof(float) * height * width);
    float * waveletF = (float *)malloc(sizeof(float) * width * height);
    for (k=0; k<order; k++){
        // copy the array over 
        copyPartsOfArray(x, wavelet, width>>k, height>>k, width, height);
        
        // perform the dwt
        dwt2(wavelet, waveletF, width>>k, height>>k);

        // copy the array back
        copyPartsOfArrayInverse(waveletF, x, width>>k, height>>k, width, height);
    }
    free(wavelet);
    free(waveletF);
}
float * idwt(float * x, int N, float * y){
    float * one = (float *)malloc(sizeof(float) * N/2);
    float * two = (float *)malloc(sizeof(float) * N/2);
    float * low = (float *)malloc(sizeof(float) * N/2);
    float * high = (float *)malloc(sizeof(float) * N/2);
    float * w = (float *)malloc(sizeof(float) * N/1);
    
    // one and two are the first halfs of the signal
    cblas_scopy(N/2, x, 1, one, 1);
    cblas_scopy(N/2, x+N/2, 1, two, 1);
    
    // the additions
    cblas_scopy(N/2, two, 1, low, 1);
    catlas_saxpby(N/2, 1, one, 1, 1, low, 1);
    
    // the subtractions
    cblas_scopy(N/2, two, 1, high, 1);
    catlas_saxpby(N/2, 1, one, 1, -1, high, 1);
    
    // now, the arrays are split up: the first and third elements are in one
    // array, the second and fourth elements in the other.
    
    cblas_scopy(N/2, low, 1, w, 2);
    cblas_scopy(N/2, high, 1, w+1, 2);
    // and scaling properly
    cblas_sscal(N, 1/sqrt(2), w, 1);
    cblas_scopy(N, w, 1, y, 1);
    free(one);
    free(two);
    free(low);
    free(high);
    free(w);
    return (void*)0xbad;
}
float * idwt2(float * x, float * y, int width, int height){
    int i;
    float * wavelet = (float *)malloc(sizeof(float) * width);
    float * wavelet1 = (float *)malloc(sizeof(float) * width);
    for (i=0; i<width; i++){
        getRow(x, i, wavelet, width, height);
        idwt(wavelet, height, wavelet1);
        putRowIn(wavelet1, i, y, width, height);
    }
    for (i=0; i<height; i++){
        getCol(y, i, wavelet, width, height);
        idwt(wavelet, width, wavelet1);
        putColIn(wavelet1, i, y, width, height);
    }
    free(wavelet);
    free(wavelet1);
}
float * idwt2_full(float * x, int width, int height){
    // overwrites x
    int k;
    int order = (int)log2(width);
    float * wavelet  = (float *)malloc(sizeof(float) * width * height);
    float * waveletF = (float *)malloc(sizeof(float) * width * height);
    for (k=order; k>0; k--){
        // copy parts of array
        copyPartsOfArray(x, wavelet, width>>k-1, height>>k-1, width, height);
        // idwt2
        idwt2(wavelet, waveletF, width>>k-1, height>>k-1);
        // copy parts of array back in
        copyPartsOfArrayInverse(waveletF, x, width>>k-1, height>>k-1, width, height);
    }
    free(wavelet);
    free(waveletF);
}

void copyPartsOfArray(float * in, float * out, int maxX, int maxY, int width, int height){
    int x, y;
    int i=0;
    for (y=0; y<maxY; y++){
        for (x=0; x<maxX; x++){
            out[i] = in[y*width + x];
            i++;
        }
    }
}
void copyPartsOfArrayInverse(float * in, float * out, int maxX, int maxY, int width, int height){
    int x, y;
    int i=0;
    for (y=0; y<maxY; y++){
        for (x=0; x<maxX; x++){
            out[y*width + x] = in[i];
            i++;
        }
    }
}

void putRowIn(float * row, float rowNumber, float * arr, int width, int height){
    int i=0;
    int x, y;
    y = rowNumber;
    for (x=0; x<width; x++){
        arr[y*width+x] = row[x];
    }
}
void putColIn(float * col, float colNumber, float * arr, int width, int height){
    int i=0;
    int x, y;
    x = colNumber;
    for (y=0; y<height; y++){
        arr[y*width+x] = col[y];
    }
}
void getRow(float * in, int row, float * out, int width, int height){
    int i=0;
    int x, y;
    y = row;

    for(x=0; x<width; x++){
        out[x] = in[y*width + x];
    }
}
void getCol(float * in, int col, float * out, int width, int height){
    int i=0;
    int x, y;
    x = col;

    for(y=0; y<height; y++){
        out[y] = in[y*width + x];
    }
}



// C should really have this function built in.
float std(float * array, int N){
    float mean = 0;
    int i;

    // find the mean
    for (i=0; i<N; i++) mean += array[i];
    mean = mean / N;
    // find the standard deviation
    float st = 0;
    for (i=0; i<N; i++) st += (array[i] - mean) * (array[i] - mean);
    st = sqrt(st / N);
    return st;
}
void randperm(int n,int perm[]){
	int i, j, t;

	for(i=0; i<n; i++)
		perm[i] = i;
	for(i=0; i<n; i++) {
		j = rand()%(n-i)+i;
		t = perm[j];
		perm[j] = perm[i];
		perm[i] = t;
	}
}
// functions I couldn't find in BLAS/accelerate
float *vec(float * x, int width, int height){
    // creates the vec() of a matrix. the same as trans, but renamed for clarity
    // overwrites x
    float * y = (float *)malloc(sizeof(float) * width * height);
    vDSP_mtrans(x, 1, y, 1, width, height);
    cblas_scopy(width*height, y, 1, x, 1);
    
    // don't listen to the return!
    free(y);
    return y;
}



float S2sign(float x){
    printf("Calling\n");
    float ret;
    if (x<0)  ret = -1;
    else if (x>0)  ret = 1;
    else ret = 0;
    return ret;
}


//void copy(float * source, float * dest, int N){
//    int i;
//    for (i=0; i<N; i++){
//        dest[i] = source[i];
//    }
//    
//}