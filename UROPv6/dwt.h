
void * dwt(float * x, int N, float * y);
float * dwt2(float * x, float * y, int width, int height);
float * dwt2_full(float * x, int width, int height);
float * idwt(float * x, int N, float * y);
float * idwt2(float * x, float * y, int width, int height);
float * idwt2_full(float * x, int width, int height);
void copy(float * source, float * dest, int N);
float *vec(float * x, int width, int height);