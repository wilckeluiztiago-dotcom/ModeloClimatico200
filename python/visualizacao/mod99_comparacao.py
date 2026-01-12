"""
Módulo 99: Comparação com Observações
Autor: Luiz Tiago Wilcke
Descrição: Comparação de resultados com dados observacionais.
"""

import numpy as np
import matplotlib.pyplot as plt

class ComparacaoObservacoes:
    """Compara resultados do modelo com observações."""
    
    @staticmethod
    def bias_mapa(modelo, obs, latitude, longitude, titulo, unidade, arquivo_saida=None):
        """Plota mapa de viés (modelo - observação)."""
        fig, ax = plt.subplots(figsize=(14, 7))
        
        bias = modelo - obs
        lon_grid, lat_grid = np.meshgrid(longitude, latitude)
        
        vmax = np.max(np.abs(bias))
        cs = ax.pcolormesh(lon_grid, lat_grid, bias, cmap='RdBu_r',
                          vmin=-vmax, vmax=vmax, shading='auto')
        
        cbar = plt.colorbar(cs, ax=ax, shrink=0.6)
        cbar.set_label(f'Viés ({unidade})')
        
        ax.set_xlabel('Longitude (°)')
        ax.set_ylabel('Latitude (°)')
        ax.set_title(titulo)
        
        # Estatísticas
        bias_medio = np.mean(bias)
        rmse = np.sqrt(np.mean(bias**2))
        ax.text(0.02, 0.02, f'Viés médio: {bias_medio:.2f}\nRMSE: {rmse:.2f}',
                transform=ax.transAxes, fontsize=10, verticalalignment='bottom',
                bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))
        
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
    
    @staticmethod
    def comparacao_serie_temporal(tempo, modelo, obs, titulo, ylabel, arquivo_saida=None):
        """Compara séries temporais modelo x observação."""
        fig, axes = plt.subplots(2, 1, figsize=(12, 8), sharex=True)
        
        # Séries
        axes[0].plot(tempo, modelo, 'b-', label='Modelo', linewidth=1.5)
        axes[0].plot(tempo, obs, 'r--', label='Observação', linewidth=1.5)
        axes[0].set_ylabel(ylabel)
        axes[0].legend()
        axes[0].set_title(titulo)
        axes[0].grid(True, alpha=0.3)
        
        # Diferença
        diff = modelo - obs
        axes[1].plot(tempo, diff, 'g-', linewidth=1)
        axes[1].axhline(0, color='black', linewidth=0.5)
        axes[1].fill_between(tempo, 0, diff, alpha=0.3)
        axes[1].set_ylabel('Modelo - Obs')
        axes[1].set_xlabel('Tempo')
        axes[1].grid(True, alpha=0.3)
        
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
    
    @staticmethod
    def metricas_estatisticas(modelo, obs):
        """Calcula métricas de comparação."""
        diff = modelo - obs
        return {
            'vies': np.mean(diff),
            'rmse': np.sqrt(np.mean(diff**2)),
            'mae': np.mean(np.abs(diff)),
            'correlacao': np.corrcoef(modelo.flatten(), obs.flatten())[0, 1],
            'desvio_modelo': np.std(modelo),
            'desvio_obs': np.std(obs)
        }
