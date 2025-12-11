# ======================================================================
# Compilador e Flags
# ======================================================================
CC = gcc
CFLAGS = -Wall -Wextra -O3
OPENMP_FLAG = -fopenmp

# ======================================================================
# Arquivos Fonte (Tarefa C e Tarefa D)
# ======================================================================
SRC_C_SEQ = src/seq/saxpy_seq.c
SRC_C_OMP_SIMD = src/omp/saxpy_omp_simd.c
SRC_C_SIMD = src/omp/saxpy_simd.c
SRC_D = src/omp/tarefa_d.c	

# ======================================================================
# Executáveis Gerados (mesmo diretório dos fontes)
# ======================================================================
EXEC_C_SEQ = src/seq/saxpy_seq
EXEC_C_OMP_SIMD = src/omp/saxpy_omp_simd
EXEC_C_SIMD = src/omp/saxpy_simd
EXEC_D = src/omp/tarefa_d

# ======================================================================
# Alvo padrão
# ======================================================================
.PHONY: all seq omp run plot clean

all: $(EXEC_C_SEQ) $(EXEC_C_OMP_SIMD) $(EXEC_C_SIMD) $(EXEC_D)

# ======================================================================
# Compilações
# ======================================================================

# Tarefa C — versão sequencial (PRECISA de -fopenmp por causa do omp_get_wtime)
$(EXEC_C_SEQ): $(SRC_C_SEQ)
	$(CC) $(CFLAGS) $(OPENMP_FLAG) $< -o $@

# Tarefa C — versão omp simd
$(EXEC_C_OMP_SIMD): $(SRC_C_OMP_SIMD)
	$(CC) $(CFLAGS) $(OPENMP_FLAG) $< -o $@

# Tarefa C — versão simd pura
$(EXEC_C_SIMD): $(SRC_C_SIMD)
	$(CC) $(CFLAGS) $(OPENMP_FLAG) $< -o $@

# Tarefa D — overhead
$(EXEC_D): $(SRC_D)
	$(CC) $(CFLAGS) $(OPENMP_FLAG) $< -o $@

# ======================================================================
# Agrupamentos
# ======================================================================
seq: $(EXEC_C_SEQ)
omp: $(EXEC_C_OMP_SIMD) $(EXEC_C_SIMD) $(EXEC_D)

# ======================================================================
# Execução (corrige permissão automaticamente)
# ======================================================================
run: all
	@echo "Verificando permissão de run.sh..."
	@if [ ! -x run.sh ]; then chmod +x run.sh; echo "Permissão corrigida."; fi
	@echo "Executando run.sh..."
	./run.sh

# ======================================================================
# Plot — APENAS para Linux
# ======================================================================
#plot:
#	@if [ ! -d "venv" ]; then \
#		echo "Criando venv pela primeira vez..."; \
#		python3 -m venv venv; \
#		. venv/bin/activate && pip install pandas matplotlib numpy; \
#	fi
#	@echo "Ativando venv e gerando gráficos..."
#	. venv/bin/activate && python3 plot.py

# ======================================================================
# Plot — APENAS para Windows/Git Bash
# ======================================================================
plot:
	@if [ ! -d "venv" ]; then \
		echo "Criando venv pela primeira vez..."; \
		\
		python -m venv venv 2>/dev/null || python3 -m venv venv || { \
			echo "ERRO: O comando 'python' ou 'python3' não foi encontrado."; \
			exit 1; \
		}; \
		\
		echo "Instalando dependências..."; \
		./venv/Scripts/pip install pandas matplotlib numpy; \
	fi;
	
	@echo "Ativando venv e gerando gráficos..."
	sh -c ". venv/Scripts/activate && python plot.py"

# ======================================================================
# Limpeza
# ======================================================================
clean:
	rm -f $(EXEC_C_SEQ) $(EXEC_C_OMP_SIMD) $(EXEC_C_SIMD) $(EXEC_D)
	rm -f resultados.csv grafico_*.png
	rm -rf venv
