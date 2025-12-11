#!/bin/bash

# Caminhos dos executáveis da tarefa C
SEQ="./src/seq/saxpy_seq"
SIMD="./src/omp/saxpy_simd"
OMP_SIMD="./src/omp/saxpy_omp_simd"

# Caminhos dos executáveis da tarefa D
EXEC_D="./src/omp/tarefa_d"


# Parâmetros
Ns=(100000 500000 1000000)
threads=(1 2 4 8 16)
reps=5

# Arquivo de saída único
OUT="resultados.csv"
echo "tarefa,versao,N,threads,rep,tempo" > $OUT


# ==============================================================================
# --- SEÇÃO DA TAREFA C (SAXPY) ---
# ==============================================================================
echo "--- Executando TAREFA C (SAXPY) ---"

# V1: Sequencial
for N in "${Ns[@]}"; do
    for ((r=1; r<=reps; r++)); do
        tempo=$($SEQ $N)
        echo "C,V1,$N,1,$r,$tempo" >> $OUT
    done
done

# V2: SIMD
for N in "${Ns[@]}"; do
    for ((r=1; r<=reps; r++)); do
        tempo=$($SIMD $N)
        echo "C,V2,$N,1,$r,$tempo" >> $OUT
    done
done

# V3: Parallel + SIMD
for N in "${Ns[@]}"; do
    for T in "${threads[@]}"; do
        export OMP_NUM_THREADS=$T
        for ((r=1; r<=reps; r++)); do
            tempo=$($OMP_SIMD $N)
            echo "C,V3,$N,$T,$r,$tempo" >> $OUT
        done
    done
done

# ==============================================================================
# --- SEÇÃO DA TAREFA D (OVERHEAD) ---
# ==============================================================================
echo "--- Executando TAREFA D (OVERHEAD) ---"

# Execução Sequencial (D,seq) isolada para baseline (threads=1)
export OMP_NUM_THREADS=1
for N in "${Ns[@]}"; do
    for ((r=1; r<=reps; r++)); do
        # Passando "seq" para o binário OMP_D. Threads é fixo em 1.
        tempo=$($EXEC_D $N "seq")
        echo "D,seq,$N,1,$r,$tempo" >> $OUT
    done
done


# Execução Paralela da Tarefa D (Ingênuo e Arrumado)
for N in "${Ns[@]}"; do
    for T in "${threads[@]}"; do
        if [ $T -eq 1 ]; then
            continue
        fi

        export OMP_NUM_THREADS=$T
        for ((r=1; r<=reps; r++)); do
            
            # V2 D: Ingênua (Alto Overhead)
            tempo=$($EXEC_D $N "naive")
            echo "D,naive,$N,$T,$r,$tempo" >> $OUT

            # V3 D: Arrumada (Baixo Overhead)
            tempo=$($EXEC_D $N "organized")
            echo "D,organized,$N,$T,$r,$tempo" >> $OUT
        done
    done
done


echo "Execução concluída. Resultados salvos em $OUT"
