#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <string.h>

// N é definido via argumento, mas mantemos o #define para funções internas.
#define N_MAX 1000000 

void zera_vetores(int *A, int *B, int N_size);
void loop_sequencial(int *A, int *B, int N_size);
void loop_ingenuo(int *A, int *B, int N_size);
void loop_arrumado(int *A, int *B, int N_size);


int main(int argc, char *argv[]) {
    
    if (argc < 3) {
        fprintf(stderr, "Uso: %s <N> <variante>\n", argv[0]);
        fprintf(stderr, "Variantes: seq, naive, organized\n");
        return 1;
    }
    
    // Lê N e a variante da linha de comando
    int current_N = atoi(argv[1]);
    char* variante = argv[2];
    
    int *A, *B;
    A = (int*)malloc(current_N * sizeof(int));
    B = (int*)malloc(current_N * sizeof(int));
    
    if (!A || !B) {
        fprintf(stderr, "Erro ao alocar memória.\n");
        return 1;
    }

    double start_time, end_time;
    
    zera_vetores(A, B, current_N); 

    start_time = omp_get_wtime();
    
    // Seleção da variante a ser executada
    if (strcmp(variante, "seq") == 0) {
        loop_sequencial(A, B, current_N);
    } else if (strcmp(variante, "naive") == 0) {
        loop_ingenuo(A, B, current_N);
    } else if (strcmp(variante, "organized") == 0) {
        loop_arrumado(A, B, current_N);
    } else {
        fprintf(stderr, "Erro: Variante desconhecida '%s'\n", variante);
        free(A); free(B);
        return 1;
    }
    
    end_time = omp_get_wtime();
    
    printf("%.8f", end_time - start_time); 
    
    free(A);
    free(B);

    return 0;
}


void zera_vetores(int *A, int *B, int N_size) {
    #pragma omp parallel
    {
        #pragma omp for
        for (int i = 0; i < N_size; i++) {
            A[i] = 0;
        }
    
        #pragma omp for
        for (int i = 0; i < N_size; i++) {
            B[i] = 0;
        }
    }
}


void loop_sequencial(int *A, int *B, int N_size) {
    for (int i = 0; i < N_size; i++) {
        A[i] = i * 2;
    }

    for (int i = 0; i < N_size; i++) {
        B[i] = i * 3;
    }
}


void loop_ingenuo(int* A, int* B, int N_size) {
    #pragma omp parallel for
    for (int i = 0; i < N_size; i++) {
        A[i] = i * 2;
    }

    #pragma omp parallel for
    for (int i = 0; i < N_size; i++) {
        B[i] = i * 3;
    }
}


void loop_arrumado(int* A, int* B, int N_size) {
    #pragma omp parallel
    {
        #pragma omp for
        for (int i = 0; i < N_size; i++) {
            A[i] = i * 2;
        }

        #pragma omp for
        for (int i = 0; i < N_size; i++) {
            B[i] = i * 3;
        }
    }
}