
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <Accelerate/Accelerate.h>

int writeImage(float * x, int width, int height);
void readImage(float * x, int width, int height);
void copy(float * source, float * dest, int N);

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
void readImage(float * x, int width, int height){
    // width and height must be pre-determined
    // takes in number of format "6.612244897959184131e-01"
    // takes in *exactly* that number of bytes.
    // overwrites x
    // we have to set nulls after we've read so many char's -- fread only modifies char's it reads
    int xx, yy, i;
    /*float * x = (float *)malloc(sizeof(float) * width * height);*/
    FILE * READ_CSV = fopen("input.csv", "r");
    char * buffer = (char *)malloc(sizeof(char) * 64);
    
    for (yy=0; yy<height; yy++){
        for (xx=0; xx<width; xx++){
            i = yy*width + xx;

            // the number
            fread(buffer, 20, 1, READ_CSV);
            buffer[20] = 0;
            float base = (float)atof(buffer);

            // the "e"
            fread(buffer, 1, 1, READ_CSV);
            buffer[1] = 0;

            // the exponent
            fread(buffer, 3, 1, READ_CSV);
            buffer[3] = 0;
            float exp = (float)atof(buffer);

            float number = base * powf(10, exp);
            x[i] = number;

            // the comma
            fread(buffer, 1, 1, READ_CSV);
        }
    }
}

void copy(float * source, float * dest, int N){
    int i;
    for (i=0; i<N; i++){
        dest[i] = source[i];
    }

}
