#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <N>\n", argv[0]);
        return 1;
    }

    long N = atol(argv[1]);
    const float a = 2.0f;

    float *x = (float*) malloc(N * sizeof(float));
    float *y = (float*) malloc(N * sizeof(float));
    if (!x || !y) {
        fprintf(stderr, "Erro ao alocar memória!\n");
        return 1;
    }

    for (long i = 0; i < N; i++) {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    double start = omp_get_wtime();

    #pragma omp parallel for simd
    for (long i = 0; i < N; i++) {
        y[i] = a * x[i] + y[i];
    }

    double end = omp_get_wtime();
    printf("%f\n", end - start);

    free(x);
    free(y);
    return 0;
}
