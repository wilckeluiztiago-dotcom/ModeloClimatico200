"""
Módulo 100: Dashboard Interativo
Autor: Luiz Tiago Wilcke
Descrição: Dashboard para visualização interativa.
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, Button

class DashboardClimatico:
    """Dashboard interativo para análise climática."""
    
    def __init__(self, latitude, longitude):
        self.latitude = latitude
        self.longitude = longitude
    
    def dashboard_completo(self, T_sup, T_serie, precipitacao, arquivo_saida=None):
        """Cria dashboard com múltiplos painéis."""
        fig = plt.figure(figsize=(16, 10))
        
        # Layout
        gs = fig.add_gridspec(2, 3, hspace=0.3, wspace=0.3)
        
        # Mapa de temperatura
        ax1 = fig.add_subplot(gs[0, :2])
        lon_grid, lat_grid = np.meshgrid(self.longitude, self.latitude)
        cs1 = ax1.pcolormesh(lon_grid, lat_grid, T_sup - 273.15, cmap='RdYlBu_r', shading='auto')
        plt.colorbar(cs1, ax=ax1, shrink=0.8, label='°C')
        ax1.set_title('Temperatura da Superfície', fontsize=12)
        ax1.set_xlabel('Longitude')
        ax1.set_ylabel('Latitude')
        
        # Série temporal
        ax2 = fig.add_subplot(gs[0, 2])
        ax2.plot(T_serie, 'b-', linewidth=1)
        ax2.set_title('Temperatura Global', fontsize=12)
        ax2.set_xlabel('Passo de Tempo')
        ax2.set_ylabel('T (K)')
        ax2.grid(True, alpha=0.3)
        
        # Precipitação
        ax3 = fig.add_subplot(gs[1, :2])
        cs3 = ax3.pcolormesh(lon_grid, lat_grid, precipitacao * 86400, 
                            cmap='Blues', vmin=0, shading='auto')
        plt.colorbar(cs3, ax=ax3, shrink=0.8, label='mm/dia')
        ax3.set_title('Precipitação', fontsize=12)
        ax3.set_xlabel('Longitude')
        ax3.set_ylabel('Latitude')
        
        # Médias zonais
        ax4 = fig.add_subplot(gs[1, 2])
        T_zonal = np.mean(T_sup, axis=1) - 273.15
        ax4.plot(T_zonal, self.latitude, 'r-', linewidth=2)
        ax4.set_xlabel('Temperatura (°C)')
        ax4.set_ylabel('Latitude')
        ax4.set_title('Média Zonal', fontsize=12)
        ax4.grid(True, alpha=0.3)
        ax4.axhline(0, color='gray', linestyle='--', alpha=0.5)
        
        plt.suptitle('DASHBOARD DO MODELO CLIMÁTICO\nAutor: Luiz Tiago Wilcke', 
                     fontsize=14, fontweight='bold')
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
    
    def resumo_simulacao(self, resultados, arquivo_saida=None):
        """Gera resumo visual da simulação."""
        fig, axes = plt.subplots(2, 2, figsize=(12, 10))
        
        passos = [r['passo'] for r in resultados]
        T_media = [r['T_media'] for r in resultados]
        
        # Evolução temporal
        axes[0, 0].plot(passos, T_media, 'b-', linewidth=1.5)
        axes[0, 0].set_xlabel('Passo')
        axes[0, 0].set_ylabel('Temperatura (K)')
        axes[0, 0].set_title('Evolução da Temperatura Global')
        axes[0, 0].grid(True, alpha=0.3)
        
        # Histograma
        axes[0, 1].hist(T_media, bins=30, color='steelblue', edgecolor='white')
        axes[0, 1].set_xlabel('Temperatura (K)')
        axes[0, 1].set_ylabel('Frequência')
        axes[0, 1].set_title('Distribuição de Temperatura')
        
        # Estatísticas
        stats_text = f"""
        ESTATÍSTICAS DA SIMULAÇÃO
        
        Passos: {len(resultados)}
        T média: {np.mean(T_media):.2f} K
        T mínima: {np.min(T_media):.2f} K
        T máxima: {np.max(T_media):.2f} K
        Desvio: {np.std(T_media):.3f} K
        """
        axes[1, 0].text(0.1, 0.5, stats_text, fontsize=12, family='monospace',
                        transform=axes[1, 0].transAxes, verticalalignment='center')
        axes[1, 0].axis('off')
        axes[1, 0].set_title('Estatísticas')
        
        # Tendência
        z = np.polyfit(passos, T_media, 1)
        p = np.poly1d(z)
        axes[1, 1].plot(passos, T_media, 'b.', alpha=0.5)
        axes[1, 1].plot(passos, p(passos), 'r-', linewidth=2)
        axes[1, 1].set_xlabel('Passo')
        axes[1, 1].set_ylabel('Temperatura (K)')
        axes[1, 1].set_title(f'Tendência: {z[0]*1000:.4f} K/1000 passos')
        axes[1, 1].grid(True, alpha=0.3)
        
        plt.suptitle('RESUMO DA SIMULAÇÃO - Autor: Luiz Tiago Wilcke', 
                     fontsize=14, fontweight='bold')
        plt.tight_layout()
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
