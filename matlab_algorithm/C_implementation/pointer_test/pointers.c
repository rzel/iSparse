#include <stdlib.h>
#include <stdio.h>

void function(float * t_r);
float f2(float tf);
int main(){
    float t_r = 1;

    int i;
    for (i=0; i<10; i++){
        printf("%f\n", t_r);
        function(&t_r);
    }

}

void function(float * t_r){
    float trf_r;
    float tf;

    trf_r = *t_r;
    tf = trf_r;
    tf = f2(tf);
    printf("   %f\n", tf);

    // change from trf to trf_r
    trf_r = tf;

    // checked
    *t_r = trf_r;
}

float f2(float tf){
    return tf + 1;
}


