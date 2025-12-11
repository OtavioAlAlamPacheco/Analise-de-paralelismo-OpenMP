RESULTADOS – Tarefa C: SAXPY com OpenMP
1. Introdução

Nesta tarefa, avaliamos três versões do kernel SAXPY:

V1: Sequencial
V2: SIMD usando #pragma omp simd
V3: Paralelo + SIMD usando #pragma omp parallel for simd

Foram testados os tamanhos N = 100000, 500000 e 1000000.
Na versão V3 também variamos o número de threads em {1, 2, 4, 8, 16}.
Cada ponto foi executado 5 vezes para cálculo de média e desvio padrão.

Os testes foram realizados em um Ryzen 5 3400G, um processador com 4 núcleos e 8 threads, o que teve impacto direto na interpretação dos resultados, especialmente acima de 4 threads.

2. Tabelas de Resultados Atualizadas
2.1 V1 – Sequencial
N	Média (s)	Desvio Padrão (s)
100000	0.000299	0.000040
500000	0.001605	0.000305
1000000	0.003336	0.000467
2.2 V2 – SIMD
N	Média (s)	Desvio Padrão (s)
100000	0.000255	0.000002
500000	0.001560	0.000295
1000000	0.003377	0.000515
2.3 V3 – Parallel + SIMD
N	Threads	Média (s)	Desvio Padrão (s)
100000	1	0.000313	0.000056
100000	2	0.000274	0.000022
100000	4	0.000444	0.000078
100000	8	0.004360	0.004654
100000	16	0.002020	0.000147
500000	1	0.001525	0.000171
500000	2	0.001091	0.000177
500000	4	0.001011	0.000251
500000	8	0.007669	0.004464
500000	16	0.002269	0.000127
1000000	1	0.002865	0.000259
1000000	2	0.001874	0.000172
1000000	4	0.001983	0.000330
1000000	8	0.005802	0.004636
1000000	16	0.002694	0.000174

Observação importante: os valores com 8 threads apresentam variação extremamente alta, o que será discutido na análise.

3. Análise de Desempenho
V1 vs V2

A versão V2, usando SIMD, tende a apresentar tempos levemente melhores que a V1. Isso confirma que o compilador consegue vetorizar o laço do SAXPY, mas como o kernel é muito simples, o ganho só se torna relevante para valores maiores de N. Foram inclusive utilizados valores maiores de N (até 100M) para evidênciar que a melhora continuaria para valores ainda maiores, mas como eles fogem do escopo de dados requisitados, não foram utilizados neste relatório.

Comportamento da V3 (Parallel + SIMD)

O comportamento mais didático desta tarefa está aqui. A combinação de paralelismo com vetorizações funciona bem até certo ponto, mas passa a prejudicar o desempenho conforme o número de threads cresce além das capacidades do processador.

Até 2 threads

Os tempos caem e o desempenho melhora como esperado. A sobrecarga do paralelismo ainda é pequena e o tamanho do problema permite ganhos.

Em 4 threads

Como o processador possui exatamente 4 núcleos físicos, este deveria ser o melhor ponto. De fato, os resultados apresentam bons tempos, mas o ganho não escala de maneira significativa porque o SAXPY é fortemente limitado por memória. O custo de dividir o trabalho entre as threads começa a ficar próximo do próprio custo do cálculo.

Em 8 threads

Aqui ocorre o comportamento mais curioso. O tempo médio aumenta bastante e o desvio padrão cresce de forma muito significativa. Acreditamos que isso acontece por dois motivos principais:

O processador possui 4 núcleos físicos e 8 threads lógicas. Ao usar 8 threads, não há oito unidades físicas executando o trabalho, apenas 4 núcleos alternando entre 8 threads. Isso causa troca de contexto constante, disputa por cache e maior competição pelos recursos internos do processador.

O kernel SAXPY é muito simples e não tem trabalho computacional suficiente para justificar o uso de tantas threads. O peso da sincronização e da divisão do trabalho se torna maior que o próprio cálculo.

Como resultado, o desempenho piora bastante em 8 threads e se torna altamente instável, dependendo do agendador do sistema operacional.

Em 16 threads

Mesmo com ainda mais threads, o desempenho continua inferior ao observado com 4 threads, mas pelo menos os tempos ficam mais estáveis. Acreditamos que isso ocorre porque, embora haja excesso de threads, o sistema operacional distribui a carga de forma mais uniforme, reduzindo o impacto do ruído extremo observado em 8 threads.

4. Conclusão

Os resultados demonstram claramente que a melhor configuração é aquela que utiliza no máximo o número de núcleos físicos do processador, que no caso do Ryzen 5 3400G significa até 4 threads. A SIMD sozinha oferece ganhos moderados, enquanto a combinação com paralelismo traz benefícios apenas quando usada de forma equilibrada.

O principal aprendizado desta tarefa é que aumentar o número de threads além da capacidade real do hardware não só deixa de trazer melhorias como pode piorar drasticamente o desempenho devido ao overhead de gerenciamento das threads, à disputa por recursos e às limitações da arquitetura do processador.

Esses resultados servem como base importante para entender que a escolha do número de threads deve sempre considerar o perfil do hardware e o tipo de tarefa sendo executada.

Um adendo interessante é que esses testes foram feitos, inicialmente, em um dia muito quente e com um cooler fraco (CPU), e os resultados tiveram grandes desvios padrão. Após isso, um cooler melhor foi instalado e os testes foram realizados em um dia mais frio, trazendo uma estabilidade significativa aos resultados. Isso se mostrou um grande aprendizado de que fatores externos também tem um papel importante na variabilidade dos resultados.

------------------------------------------------------------------------------------------------X-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------X-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------X-------------------------------------------------------------------------------------------------------------------

RESULTADOS – Tarefa D: Overhead de Criação de Threads no OpenMP
1. Introdução

Nesta tarefa, avaliamos o impacto do overhead de criação e gerenciamento de threads no OpenMP. Para isso, comparamos:

seq – Versão sequencial (baseline)

naive – Versão paralela simples, onde cada thread acessa seu pedaço sem organização

organized – Versão com reorganização de acesso para melhorar locality e reduzir disputas

Foram testados três tamanhos de entrada: N = 100000, 500000 e 1000000, e para as versões paralelas, utilizamos threads em {2, 4, 8, 16}. Assim como na tarefa C, cada ponto foi repetido 5 vezes, com cálculo de média e desvio padrão.

Como o Ryzen 5 3400G possui 4 núcleos físicos e 8 lógicos, o comportamento dos tempos nas versões paralelas também reflete o impacto dessa arquitetura — especialmente para 8 e 16 threads.

2. Tabelas de Resultados
2.1 Versão Sequencial (seq)
N	Média (s)	Desvio Padrão (s)
100000	0.000459	0.000010
500000	0.002479	0.000046
1000000	0.005150	0.000236
2.2 Versão Naive
N	Threads	Média (s)	Desvio Padrão (s)
100000	2	0.000281	0.000058
100000	4	0.000132	0.000009
100000	8	0.015936	0.000055
100000	16	0.001131	0.000049
500000	2	0.001290	0.000060
500000	4	0.000758	0.000149
500000	8	0.013020	0.006514
500000	16	0.001503	0.000187
1000000	2	0.002569	0.000104
1000000	4	0.001691	0.000426
1000000	8	0.010937	0.008317
1000000	16	0.002181	0.000202
2.3 Versão Organized
N	Threads	Média (s)	Desvio Padrão (s)
100000	2	0.000280	0.000046
100000	4	0.000142	0.000014
100000	8	0.000107	0.000050
100000	16	0.000888	0.000061
500000	2	0.001315	0.000040
500000	4	0.000724	0.000144
500000	8	0.002077	0.002937
500000	16	0.001282	0.000370
1000000	2	0.002656	0.000145
1000000	4	0.001757	0.000193
1000000	8	0.004840	0.003330
1000000	16	0.001821	0.000178
3. Análise de Desempenho
Comparando seq, naive e organized

A versão sequencial serve como referência — ela representa o tempo sem qualquer overhead de criação de threads. A partir dela, avaliamos como o paralelismo afeta o desempenho. Os resultados destacam três pontos principais:

3.1 Ganhos iniciais com poucas threads

Para 2 e 4 threads, tanto a versão naive quanto a organized apresentam tempos menores que o sequencial, indicando que o paralelismo inicial compensa o overhead. Entretanto:

A versão organized é sempre um pouco mais rápida, como esperado.

Em N pequenos (100k), o ganho é limitado pelo custo fixo de criar threads.

Isso reforça que o paralelismo vale a pena, mas apenas quando o tamanho da entrada é suficiente para amortizar o custo.

3.2 Comportamento para 8 threads: o caso mais crítico

Assim como na Tarefa C, 8 threads produzem instabilidade extrema, mas na Tarefa D isso é ainda mais evidente.

Na versão naive:

Os tempos pulam para ~16 ms, quase 40× mais lentos que com 4 threads.

A variação é muito grande, chegando a diferenças de vários milissegundos entre execuções.

Isso acontece porque:

O processador só possui 4 núcleos físicos — os 8 threads competem entre si.

A versão naive gera pior locality de memória e mais conflitos de cache.

O overhead de criação e sincronização domina o tempo total.

Já a versão organized também sofre, mas cai muito menos:

Os tempos ficam entre 0.00007 e 0.008 s, dependendo do N.

Ainda é ruim, mas bem mais estável.

Isso mostra que melhorar o acesso à memória diminui o ruído, mesmo quando há excesso de threads.

3.3 16 threads: melhora em relação a 8, mas sem vantagem real

Curiosamente, 16 threads apresentam desempenho melhor que 8 threads, mesmo sendo quase “duas vezes mais absurdo” do ponto de vista lógico.

Por quê?

O sistema operacional distribui as threads de maneira mais uniforme.

Elas passam mais tempo esperando, e menos tempo brigando por cache como acontece com exatamente 8.

Mesmo assim:

Os tempos ainda são piores que com 4 threads.

E não há nenhum ganho real em relação ao sequencial.

Esse comportamento reforça a conclusão de que criar threads demais é altamente prejudicial.

4. Conclusão

Os resultados da Tarefa D deixam claro que:

O overhead de criação e gerenciamento de threads é significativo, e domina o tempo quando o trabalho é pequeno.

O melhor desempenho ocorre quando utilizamos até o número de núcleos físicos, ou seja, 4 threads.

A versão organized sempre supera a naive, especialmente quando o número de threads aumenta.

Para 8 threads, o desempenho despenca devido à intensa disputa interna do processador.

Para 16 threads, a situação melhora em estabilidade, mas não em velocidade.

Em tamanhos pequenos de N, o custo fixo do paralelismo tende a superar qualquer benefício.

Assim como observado na Tarefa C, os resultados demonstram que mais threads não significa mais desempenho — muito pelo contrário. A escolha do número de threads deve sempre considerar:

arquitetura do hardware,

tamanho do problema,

quantidade de trabalho que cada thread realmente precisa executar.

Dessa forma, a Tarefa D complementa a Tarefa C mostrando não apenas o impacto do paralelismo no cálculo, mas também o custo real de criar, sincronizar e organizar threads em um ambiente de execução.