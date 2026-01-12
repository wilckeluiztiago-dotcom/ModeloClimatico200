"""
Módulo 98: Diagramas de Fase
Autor: Luiz Tiago Wilcke
Descrição: Diagramas de fase e scatter plots.
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

class DiagramasFase:
    """Gera diagramas de fase e correlações."""
    
    @staticmethod
    def scatter_2d(x, y, xlabel, ylabel, titulo, arquivo_saida=None):
        """Scatter plot 2D."""
        fig, ax = plt.subplots(figsize=(8, 8))
        ax.scatter(x, y, alpha=0.5, s=10)
        
        # Linha de regressão
        slope, intercept, r, p, se = stats.linregress(x.flatten(), y.flatten())
        x_line = np.linspace(np.min(x), np.max(x), 100)
        ax.plot(x_line, slope * x_line + intercept, 'r-', 
                label=f'r² = {r**2:.3f}')
        
        ax.set_xlabel(xlabel, fontsize=12)
        ax.set_ylabel(ylabel, fontsize=12)
        ax.set_title(titulo, fontsize=14)
        ax.legend()
        ax.grid(True, alpha=0.3)
        
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150)
            plt.close()
        return fig
    
    @staticmethod
    def diagrama_taylor(ref, modelos_dict, titulo='Diagrama de Taylor', arquivo_saida=None):
        """Diagrama de Taylor simplificado."""
        fig, ax = plt.subplots(figsize=(10, 10), subplot_kw={'projection': 'polar'})
        
        ref_std = np.std(ref)
        
        for nome, modelo in modelos_dict.items():
            corr = np.corrcoef(ref.flatten(), modelo.flatten())[0, 1]
            std = np.std(modelo) / ref_std
            theta = np.arccos(corr)
            ax.scatter(theta, std, s=100, label=nome)
        
        ax.scatter(0, 1, s=200, marker='*', color='black', label='Referência')
        ax.set_thetamin(0)
        ax.set_thetamax(90)
        ax.legend(loc='upper right', bbox_to_anchor=(1.3, 1))
        ax.set_title(titulo)
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
    
    @staticmethod
    def histograma_2d(x, y, xlabel, ylabel, titulo, bins=50, arquivo_saida=None):
        """Histograma 2D (joint distribution)."""
        fig, ax = plt.subplots(figsize=(8, 8))
        
        h = ax.hist2d(x.flatten(), y.flatten(), bins=bins, cmap='Blues')
        plt.colorbar(h[3], ax=ax, label='Contagem')
        
        ax.set_xlabel(xlabel, fontsize=12)
        ax.set_ylabel(ylabel, fontsize=12)
        ax.set_title(titulo, fontsize=14)
        
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150)
            plt.close()
        return fig
