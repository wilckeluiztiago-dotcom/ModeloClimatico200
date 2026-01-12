"""
Módulo 94: Séries Temporais
Autor: Luiz Tiago Wilcke
Descrição: Visualização de séries temporais.
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.dates import DateFormatter, MonthLocator

class SeriesTemporais:
    """Gera gráficos de séries temporais."""
    
    @staticmethod
    def plotar_serie(tempos, valores, titulo, ylabel, xlabel='Tempo',
                     cor='blue', arquivo_saida=None):
        """Plota uma série temporal simples."""
        fig, ax = plt.subplots(figsize=(12, 5))
        ax.plot(tempos, valores, color=cor, linewidth=1.5)
        ax.set_xlabel(xlabel, fontsize=12)
        ax.set_ylabel(ylabel, fontsize=12)
        ax.set_title(titulo, fontsize=14, fontweight='bold')
        ax.grid(True, alpha=0.3)
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
    
    @staticmethod
    def plotar_multiplas_series(tempos, series_dict, titulo, ylabel,
                                 arquivo_saida=None):
        """Plota múltiplas séries no mesmo gráfico."""
        fig, ax = plt.subplots(figsize=(12, 5))
        
        cores = plt.cm.tab10(np.linspace(0, 1, len(series_dict)))
        
        for (nome, valores), cor in zip(series_dict.items(), cores):
            ax.plot(tempos, valores, label=nome, color=cor, linewidth=1.5)
        
        ax.set_xlabel('Tempo', fontsize=12)
        ax.set_ylabel(ylabel, fontsize=12)
        ax.set_title(titulo, fontsize=14, fontweight='bold')
        ax.legend(loc='best')
        ax.grid(True, alpha=0.3)
        
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
    
    @staticmethod
    def plotar_anomalia(tempos, valores, climatologia, titulo, ylabel,
                        arquivo_saida=None):
        """Plota série temporal com anomalia."""
        fig, axes = plt.subplots(2, 1, figsize=(12, 8), sharex=True)
        
        # Série original
        axes[0].plot(tempos, valores, 'b-', label='Observado')
        axes[0].axhline(climatologia, color='r', linestyle='--', label='Climatologia')
        axes[0].set_ylabel(ylabel)
        axes[0].set_title(titulo)
        axes[0].legend()
        axes[0].grid(True, alpha=0.3)
        
        # Anomalia
        anomalia = valores - climatologia
        cores = ['red' if a > 0 else 'blue' for a in anomalia]
        axes[1].bar(tempos, anomalia, color=cores, width=1)
        axes[1].axhline(0, color='black', linewidth=0.5)
        axes[1].set_ylabel('Anomalia')
        axes[1].set_xlabel('Tempo')
        axes[1].grid(True, alpha=0.3)
        
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
