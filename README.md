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

> **(Preencher antes da entrega)**

* Nome do integrante 1 — implementação Tarefa C, análise de resultados
* Nome do integrante 2 — implementação Tarefa D, scripts e automação

**Tarefas desenvolvidas:**

* ✅ Tarefa C — Vetorização com SIMD
* ✅ Tarefa D — Organização da região paralela

---

## 🧪 Tarefas Implementadas

### 🔹 Tarefa C — Vetorização com SIMD (SAXPY)

Kernel avaliado:

```
y[i] = a * x[i] + y[i]
```

Variantes implementadas:

* **V1 — Sequencial:** laço simples, sem paralelismo
* **V2 — SIMD:** uso de `#pragma omp simd`
* **V3 — Paralelo + SIMD:** uso de `#pragma omp parallel for simd`

O objetivo é analisar os ganhos, limitações e overheads da vetorização explícita e da combinação entre SIMD e paralelismo por threads.

---

### 🔹 Tarefa D — Organização da Região Paralela

Comparação entre duas abordagens para laços consecutivos:

* **Variante Ingênua:** dois `#pragma omp parallel for` consecutivos
* **Variante Arrumada:** uma única região `#pragma omp parallel` contendo dois `for`

O foco é medir o impacto do overhead de criação de regiões paralelas e demonstrar boas práticas de organização do código OpenMP.

---

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

## 🛠️ Compilação

Para compilar todos os executáveis:

```bash
make
```

Ou, alternativamente:

```bash
make all
```

Os binários serão gerados nos mesmos diretórios dos arquivos fonte.

---

## ▶️ Execução dos Experimentos

A execução completa da matriz de experimentos é feita automaticamente pelo script `run.sh`.

```bash
make run
```

Esse comando:

* Compila o projeto (se necessário)
* Ajusta permissões de execução do script
* Executa todos os testes definidos no enunciado
* Gera o arquivo `resultados.csv`

Parâmetros utilizados:

* **N:** {100000, 500000, 1000000}
* **Threads:** {1, 2, 4, 8, 16}
* **Repetições:** 5 por ponto experimental

---

## 📊 Geração de Gráficos

Para gerar os gráficos automaticamente a partir do CSV:

```bash
make plot
```

O Makefile cria automaticamente um ambiente virtual Python (`venv`) e instala as dependências necessárias (`pandas`, `numpy`, `matplotlib`).

Os gráficos são salvos no diretório raiz do projeto.

---

## 📈 Resultados e Análise

A análise detalhada dos resultados, incluindo:

* tabelas
* gráficos
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

> *“Compare versões com dados, não por fé.”*

---

## 📚 Referências

* OpenMP Application Programming Interface — Version 5.x
* Documentação do GCC
* Material da disciplina de Programação Paralela
