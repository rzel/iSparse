
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <Accelerate/Accelerate.h>

int writeImage(float * x, int width, int height);
int writeImage(float * x, int width, int height){
    char * filename = "filename.png";
    FILE * CSV_FILE = fopen("image.csv", "w");
    // write the csv
    int xx, yy;
    for (yy=0; yy<height; yy++){
        for (xx=0; xx<width; xx++){
            fprintf(CSV_FILE, "%f", x[yy*height + xx]);
            if (xx != width-1) fprintf(CSV_FILE, ",");
        }
        fprintf(CSV_FILE, "\n");
    }
    fclose(CSV_FILE);
    system("/Users/scott/anaconda/bin/python writeImage.py filename.png");

}
