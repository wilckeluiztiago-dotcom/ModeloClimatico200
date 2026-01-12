"""
Módulo 92: Projeções Cartográficas
Autor: Luiz Tiago Wilcke
Descrição: Diferentes projeções para visualização.
"""

import numpy as np
import matplotlib.pyplot as plt

class Projecoes:
    """Projeções cartográficas para mapas."""
    
    @staticmethod
    def projecao_cilindrica(lat, lon, campo, titulo, arquivo_saida=None):
        """Projeção cilíndrica equidistante."""
        fig, ax = plt.subplots(figsize=(14, 7))
        lon_grid, lat_grid = np.meshgrid(lon, lat)
        cs = ax.pcolormesh(lon_grid, lat_grid, campo, cmap='RdYlBu_r', shading='auto')
        plt.colorbar(cs, ax=ax, shrink=0.6)
        ax.set_title(titulo)
        ax.set_xlabel('Longitude')
        ax.set_ylabel('Latitude')
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150)
            plt.close()
        return fig
    
    @staticmethod
    def projecao_polar(lat, lon, campo, hemisferio='norte', titulo='', arquivo_saida=None):
        """Projeção polar estereográfica."""
        fig, ax = plt.subplots(figsize=(10, 10), subplot_kw={'projection': 'polar'})
        
        if hemisferio == 'norte':
            r = 90 - lat
            mask = lat >= 0
        else:
            r = 90 + lat
            mask = lat <= 0
        
        theta = np.radians(lon)
        theta_grid, r_grid = np.meshgrid(theta, r[mask])
        
        cs = ax.pcolormesh(theta_grid, r_grid, campo[mask, :], cmap='RdYlBu_r', shading='auto')
        plt.colorbar(cs, ax=ax, shrink=0.6)
        ax.set_title(titulo)
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150)
            plt.close()
        return fig
    
    @staticmethod
    def projecao_mollweide(lat, lon, campo, titulo='', arquivo_saida=None):
        """Projeção Mollweide (pseudocilíndrica)."""
        fig, ax = plt.subplots(figsize=(14, 7))
        
        # Transformação Mollweide simplificada
        lon_rad = np.radians(lon)
        lat_rad = np.radians(lat)
        
        x = np.outer(np.cos(lat_rad), lon_rad)
        y = np.outer(np.sin(lat_rad), np.ones_like(lon_rad))
        
        cs = ax.pcolormesh(x * 180/np.pi, y * 90, campo, cmap='RdYlBu_r', shading='auto')
        plt.colorbar(cs, ax=ax, shrink=0.6)
        ax.set_title(titulo)
        ax.set_aspect('equal')
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150)
            plt.close()
        return fig
