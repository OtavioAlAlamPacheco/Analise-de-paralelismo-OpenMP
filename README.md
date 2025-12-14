# Trabalho Prático 1 — OpenMP (2025/2)

**Disciplina:** Introdução a Programação ParalelaDistribuída
---

## 📌 Visão Geral

Este repositório contém a implementação e a análise experimental das **Tarefas C e D** do *Trabalho Prático 1 de OpenMP*, cujo objetivo é aplicar conceitos fundamentais de programação paralela em C utilizando **OpenMP 5.x**, com foco em:

* Vetorização explícita com `#pragma omp simd`
* Combinação de paralelismo por threads e SIMD
* Organização correta de regiões paralelas para redução de overhead
* Medição e análise crítica de desempenho

Todas as implementações seguem rigorosamente as especificações do enunciado da disciplina.

---

## 👥 Integrantes do Grupo

* Theo Viebrantz Cassuriaga — implementação Tarefa C, geração do run, makefile e plot.py
* Otávio Al Alam Pacheco — implementação Tarefa D, do resultados, reproducibilidade e repositório

**Tarefas desenvolvidas:**

* ✅ Tarefa C — Vetorização com SIMD
* ✅ Tarefa D — Organização da região paralela

---

## 🧪 Tarefas Implementadas

### 🔹 Tarefa C — Vetorização com SIMD (SAXPY)
### 🔹 Tarefa D — Organização da Região Paralela

## 🗂️ Estrutura do Repositório

```
.
├── src/
│   ├── seq/
│   │   └── saxpy_seq.c
│   └── omp/
│       ├── saxpy_simd.c
│       ├── saxpy_omp_simd.c
│       └── tarefa_d.c
├── run.sh
├── plot.py
├── Makefile
├── resultados.csv
├── README.md
├── RESULTADOS.md
└── REPRODUCIBILIDADE.md
```

---

## ⚙️ Requisitos do Ambiente

* Sistema Operacional: **Linux** (testado em Ubuntu 24.04)
* Compilador: **GCC 13.x** com suporte a OpenMP 5.x
* Ferramentas adicionais:

  * `make`
  * `python3` (apenas para geração de gráficos)

---

## 🛠️ Compilação, Execução dos Experimentos E Geração de Gráficos

A execução completa da matriz de experimentos é feita automaticamente pelo script `run.sh`.

```bash
make
```

```bash
make run
```

```bash
make plot
```

Estes comandos:

* Compilam o projeto (se necessário)
* Ajustam permissões de execução do script
* Executam todos os testes definidos no enunciado
* Geram o arquivo `resultados.csv`
* O Makefile cria automaticamente um ambiente virtual Python (`venv`) e instala as dependências necessárias (`pandas`, `numpy`, `matplotlib`).
* Os gráficos são salvos no diretório raiz do projeto.

Caso deseje recompilar e gerar os gráficos e resultados, é possível remover tudo gerado pelo make utilizando o comando:

```bash
make clean
```

Parâmetros utilizados:

* **N:** {100000, 500000, 1000000}
* **Threads:** {1, 2, 4, 8, 16}
* **Repetições:** 5 por ponto experimental
  
---

## 📈 Resultados e Análise

A análise detalhada dos resultados, incluindo:

* tabelas
* comparação entre variantes
* discussão sobre overhead, escalabilidade e limitações

está disponível no arquivo:

📄 **RESULTADOS.md**

---

## 🔁 Reprodutibilidade

Todas as informações necessárias para reproduzir os experimentos — incluindo:

* hardware
* software
* versões de compilador
* flags de compilação
* ambiente de execução

estão documentadas em:

📄 **REPRODUCIBILIDADE.md**

---

## 📝 Observações Finais

* Os resultados devem ser interpretados considerando o ambiente de execução (máquina virtual).
* Para valores pequenos de N, o overhead do OpenMP pode superar os ganhos do paralelismo.
* A análise foi baseada em dados experimentais, conforme exigido no enunciado.
