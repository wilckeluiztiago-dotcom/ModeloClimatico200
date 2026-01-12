"""
Módulo 93: Cortes Verticais
Autor: Luiz Tiago Wilcke
Descrição: Seções verticais da atmosfera e oceano.
"""

import numpy as np
import matplotlib.pyplot as plt

class CortesVerticais:
    """Gera seções verticais de variáveis."""
    
    def __init__(self, latitude, niveis):
        self.latitude = latitude
        self.niveis = niveis
    
    def corte_zonal(self, campo_3d, lon_idx, titulo, unidade, 
                    cmap='RdYlBu_r', arquivo_saida=None):
        """Corte zonal (latitude-altitude) para longitude fixa."""
        fig, ax = plt.subplots(figsize=(12, 6))
        
        campo = campo_3d[:, lon_idx, :]
        lat_grid, niv_grid = np.meshgrid(self.latitude, self.niveis)
        
        cs = ax.contourf(lat_grid.T, niv_grid.T, campo, 20, cmap=cmap)
        cbar = plt.colorbar(cs, ax=ax)
        cbar.set_label(unidade)
        
        ax.set_xlabel('Latitude (°)')
        ax.set_ylabel('Pressão (hPa)')
        ax.set_title(titulo)
        ax.invert_yaxis()
        ax.set_yscale('log')
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
    
    def corte_meridional(self, campo_3d, lat_idx, longitude, titulo, unidade,
                         cmap='RdYlBu_r', arquivo_saida=None):
        """Corte meridional (longitude-altitude) para latitude fixa."""
        fig, ax = plt.subplots(figsize=(12, 6))
        
        campo = campo_3d[lat_idx, :, :]
        lon_grid, niv_grid = np.meshgrid(longitude, self.niveis)
        
        cs = ax.contourf(lon_grid.T, niv_grid.T, campo, 20, cmap=cmap)
        cbar = plt.colorbar(cs, ax=ax)
        cbar.set_label(unidade)
        
        ax.set_xlabel('Longitude (°)')
        ax.set_ylabel('Pressão (hPa)')
        ax.set_title(titulo)
        ax.invert_yaxis()
        ax.set_yscale('log')
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
    
    def media_zonal_altura(self, campo_3d, titulo, unidade, cmap='RdYlBu_r', arquivo_saida=None):
        """Média zonal em função de latitude e altitude."""
        fig, ax = plt.subplots(figsize=(12, 6))
        
        media_zonal = np.mean(campo_3d, axis=1)
        lat_grid, niv_grid = np.meshgrid(self.latitude, self.niveis)
        
        cs = ax.contourf(lat_grid.T, niv_grid.T, media_zonal, 20, cmap=cmap)
        cbar = plt.colorbar(cs, ax=ax)
        cbar.set_label(unidade)
        
        ax.set_xlabel('Latitude (°)')
        ax.set_ylabel('Pressão (hPa)')
        ax.set_title(titulo)
        ax.invert_yaxis()
        ax.set_yscale('log')
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
