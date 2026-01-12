"""
Módulo 95: Anomalias
Autor: Luiz Tiago Wilcke
Descrição: Mapas de anomalias climáticas.
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors

class MapasAnomalias:
    """Gera mapas de anomalias climáticas."""
    
    def __init__(self, latitude, longitude):
        self.latitude = latitude
        self.longitude = longitude
    
    def plotar_anomalia(self, anomalia, titulo, unidade, vmax=None, arquivo_saida=None):
        """Plota mapa de anomalias com escala divergente."""
        fig, ax = plt.subplots(figsize=(14, 7))
        
        lon_grid, lat_grid = np.meshgrid(self.longitude, self.latitude)
        
        if vmax is None:
            vmax = max(abs(np.nanmin(anomalia)), abs(np.nanmax(anomalia)))
        
        # Colormap divergente
        cmap = plt.cm.RdBu_r
        norm = mcolors.TwoSlopeNorm(vmin=-vmax, vcenter=0, vmax=vmax)
        
        cs = ax.pcolormesh(lon_grid, lat_grid, anomalia, cmap=cmap, norm=norm, shading='auto')
        cbar = plt.colorbar(cs, ax=ax, shrink=0.6, pad=0.02)
        cbar.set_label(unidade, fontsize=12)
        
        ax.set_xlabel('Longitude (°)')
        ax.set_ylabel('Latitude (°)')
        ax.set_title(titulo, fontsize=14, fontweight='bold')
        ax.set_xlim(-180, 180)
        ax.set_ylim(-90, 90)
        
        # Contornos de zero
        ax.contour(lon_grid, lat_grid, anomalia, levels=[0], colors='black', linewidths=0.5)
        
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
    
    def plotar_tendencia(self, tendencia, titulo, unidade_por_decada, arquivo_saida=None):
        """Plota mapa de tendências."""
        return self.plotar_anomalia(
            tendencia * 10,  # Por década
            titulo,
            unidade_por_decada,
            arquivo_saida=arquivo_saida
        )
    
    def significancia_estatistica(self, campo, p_valores, nivel_sig=0.05, arquivo_saida=None):
        """Plota campo com hachuras onde estatisticamente significativo."""
        fig, ax = plt.subplots(figsize=(14, 7))
        
        lon_grid, lat_grid = np.meshgrid(self.longitude, self.latitude)
        
        vmax = max(abs(np.nanmin(campo)), abs(np.nanmax(campo)))
        cs = ax.pcolormesh(lon_grid, lat_grid, campo, cmap='RdBu_r', 
                          vmin=-vmax, vmax=vmax, shading='auto')
        
        # Hachuras para significância
        significativo = p_valores < nivel_sig
        ax.contourf(lon_grid, lat_grid, significativo.astype(float), 
                   levels=[0.5, 1.5], hatches=['...'], alpha=0)
        
        plt.colorbar(cs, ax=ax, shrink=0.6)
        ax.set_title('Anomalia (hachuras = p < 0.05)')
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
