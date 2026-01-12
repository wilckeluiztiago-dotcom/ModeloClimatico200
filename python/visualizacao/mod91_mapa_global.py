"""
Módulo 91: Mapa Global
Autor: Luiz Tiago Wilcke
Descrição: Visualização de mapas globais.
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors

class MapaGlobal:
    """Gera mapas globais de variáveis climáticas."""
    
    def __init__(self, latitude, longitude, figsize=(14, 8)):
        self.latitude = latitude
        self.longitude = longitude
        self.figsize = figsize
        plt.style.use('default')
    
    def plotar_campo(self, campo, titulo, unidade, cmap='RdYlBu_r', 
                     vmin=None, vmax=None, arquivo_saida=None):
        """Plota um campo 2D no mapa global."""
        fig, ax = plt.subplots(figsize=self.figsize)
        
        lon, lat = np.meshgrid(self.longitude, self.latitude)
        
        if vmin is None:
            vmin = np.nanmin(campo)
        if vmax is None:
            vmax = np.nanmax(campo)
        
        cs = ax.pcolormesh(lon, lat, campo, cmap=cmap, vmin=vmin, vmax=vmax, shading='auto')
        
        cbar = plt.colorbar(cs, ax=ax, shrink=0.6, pad=0.02)
        cbar.set_label(unidade, fontsize=12)
        
        ax.set_xlabel('Longitude (°)', fontsize=12)
        ax.set_ylabel('Latitude (°)', fontsize=12)
        ax.set_title(titulo, fontsize=14, fontweight='bold')
        ax.set_xlim(-180, 180)
        ax.set_ylim(-90, 90)
        
        # Grid
        ax.axhline(0, color='gray', linestyle='--', alpha=0.5)
        ax.axvline(0, color='gray', linestyle='--', alpha=0.5)
        
        plt.tight_layout()
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        else:
            plt.show()
        
        return fig
    
    def plotar_temperatura(self, T, arquivo_saida=None):
        """Plota mapa de temperatura."""
        T_celsius = T - 273.15 if np.mean(T) > 200 else T
        return self.plotar_campo(
            T_celsius, 
            'Temperatura da Superfície',
            '°C',
            cmap='RdYlBu_r',
            vmin=-40,
            vmax=40,
            arquivo_saida=arquivo_saida
        )
    
    def plotar_precipitacao(self, P, arquivo_saida=None):
        """Plota mapa de precipitação."""
        return self.plotar_campo(
            P * 86400,  # mm/dia
            'Precipitação',
            'mm/dia',
            cmap='Blues',
            vmin=0,
            vmax=20,
            arquivo_saida=arquivo_saida
        )


def criar_mapa_global(lat, lon):
    """Factory para criar mapa global."""
    return MapaGlobal(lat, lon)
