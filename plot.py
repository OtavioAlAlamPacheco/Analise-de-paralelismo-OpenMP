import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Ler CSV
df = pd.read_csv('resultados.csv')

# Variável Epsilon (mínimo tempo positivo)
EPSILON = 1e-9 # Pode ser ajustado para 1e-7 se o 1e-9 for muito pequeno para o seu ambiente

# CORREÇÃO 1: Trata tempos negativos/zero diretamente na coluna 'tempo'
df['tempo'] = df['tempo'].apply(lambda x: max(x, EPSILON))

# CORREÇÃO 2: Remove linhas com valores NaN no tempo antes do resumo
df = df.dropna(subset=['tempo'])

# Função para calcular média e desvio padrão
def resumo(df, col_tempo='tempo'):
    return df.groupby(['tarefa', 'versao','N','threads'])[col_tempo].agg(['mean','std']).reset_index()

resumo_df = resumo(df)

# Garante que mean_safe e std_safe são no mínimo EPSILON
resumo_df['mean_safe'] = resumo_df['mean'].apply(lambda x: max(x, EPSILON))
resumo_df['std_safe'] = resumo_df['std'].apply(lambda x: max(x, EPSILON))

# Função auxiliar para criar barras de erro seguras (evita que o limite inferior seja <= 0)
def create_safe_yerr(data, mean_col, std_col, epsilon):
    limite_inferior = data[mean_col] - data[std_col]
    limite_inferior_seguro = np.maximum(limite_inferior, epsilon)
    y_error_inferior_relativo = data[mean_col] - limite_inferior_seguro
    y_error_superior_relativo = data[std_col]
    y_err = np.array([y_error_inferior_relativo, y_error_superior_relativo])
    return y_err


# ==============================================================================
# --- TAREFA C (SAXPY) ---
# ==============================================================================

# Gráfico 1 — Comparação V1, V2, V3 por N (threads=1)
plt.figure(figsize=(8,5))
for versao in ['seq','simd','parallel_simd']: 
    data = resumo_df[(resumo_df['tarefa'] == 'C') & (resumo_df['versao']==versao) & (resumo_df['threads']==1)]
    
    if data.empty:
        continue

    y_err = create_safe_yerr(data, 'mean_safe', 'std_safe', EPSILON)
    
    plt.errorbar(data['N'], data['mean_safe'], yerr=y_err, marker='o', capsize=4, label=versao)

plt.title('Comparação de versões SAXPY (threads=1)')
plt.xlabel('N')
plt.ylabel('Tempo (s)')
plt.xscale('log')
plt.yscale('log')
plt.ylim(bottom=EPSILON)
plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.legend()
plt.tight_layout()
plt.savefig('grafico_comparacao_C.png')
plt.close()

# Gráfico 2 — Escalabilidade V3 por número de threads
plt.figure(figsize=(8,5))
for N in sorted(df['N'].unique()):
    data = resumo_df[(resumo_df['tarefa'] == 'C') & (resumo_df['versao']=='parallel_simd') & (resumo_df['N']==N)]
    
    if data.empty:
        continue
    
    y_err = create_safe_yerr(data, 'mean_safe', 'std_safe', EPSILON)
    
    plt.errorbar(data['threads'], data['mean_safe'], yerr=y_err, marker='o', capsize=4, label=f'N={N}')

plt.title('Escalabilidade V3 (SAXPY)')
plt.xlabel('Número de Threads')
plt.ylabel('Tempo (s)')
plt.xscale('log', base=2)
plt.yscale('log')
plt.ylim(bottom=EPSILON)
plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.legend()
plt.tight_layout()
plt.savefig('grafico_escalabilidade_C.png')
plt.close()


# ==============================================================================
# --- TAREFA D (OVERHEAD) ---
# ==============================================================================

# Gera um gráfico para cada valor de N
N_plots = sorted(df['N'].unique())

for N in N_plots:
    plt.figure(figsize=(10,6))
    
    for versao in ['seq', 'naive', 'organized']:
        data = resumo_df[(resumo_df['tarefa'] == 'D') &
                         (resumo_df['versao'] == versao) &
                         (resumo_df['N'] == N)]
        
        if data.empty:
            continue
            
        y_err = create_safe_yerr(data, 'mean_safe', 'std_safe', EPSILON)
        
        label_text = f'{versao.capitalize()}'
        
        plt.errorbar(data['threads'], data['mean_safe'], yerr=y_err,
                     marker='o', capsize=4, label=label_text)

    plt.title(f'Tarefa D — Overhead (N={N}): Tempo vs Threads')
    plt.xlabel('Número de Threads')
    plt.ylabel('Tempo (s) [Escala Logarítmica]')
    plt.xscale('log', base=2)
    plt.yscale('log')
    plt.ylim(bottom=EPSILON)
    plt.xticks(data['threads'].unique(), data['threads'].unique())
    plt.grid(True, which='both', linestyle='--', linewidth=0.5)
    plt.legend()
    plt.tight_layout()
    
    plt.savefig(f'grafico_overhead_D_N{N}.png')
    plt.close()