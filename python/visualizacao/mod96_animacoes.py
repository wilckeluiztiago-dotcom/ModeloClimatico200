"""
Módulo 96: Animações
Autor: Luiz Tiago Wilcke
Descrição: Criação de animações temporais.
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import os

class AnimacoesClimaticas:
    """Gera animações de evolução temporal."""
    
    def __init__(self, latitude, longitude):
        self.latitude = latitude
        self.longitude = longitude
    
    def animar_campo_2d(self, campos, tempos, titulo_base, unidade,
                        vmin=None, vmax=None, arquivo_saida=None, fps=10):
        """Anima evolução de campo 2D no tempo."""
        fig, ax = plt.subplots(figsize=(12, 6))
        
        lon_grid, lat_grid = np.meshgrid(self.longitude, self.latitude)
        
        if vmin is None:
            vmin = np.nanmin(campos)
        if vmax is None:
            vmax = np.nanmax(campos)
        
        cs = ax.pcolormesh(lon_grid, lat_grid, campos[0], cmap='RdYlBu_r',
                          vmin=vmin, vmax=vmax, shading='auto')
        cbar = plt.colorbar(cs, ax=ax, shrink=0.6)
        cbar.set_label(unidade)
        
        titulo = ax.set_title(f'{titulo_base} - {tempos[0]}')
        
        def update(frame):
            cs.set_array(campos[frame].ravel())
            titulo.set_text(f'{titulo_base} - {tempos[frame]}')
            return [cs, titulo]
        
        anim = FuncAnimation(fig, update, frames=len(tempos), blit=False, interval=1000/fps)
        
        if arquivo_saida:
            anim.save(arquivo_saida, writer='pillow', fps=fps)
            plt.close()
        
        return anim
    
    def criar_gif_snapshots(self, lista_arquivos, arquivo_saida, fps=5):
        """Cria GIF a partir de lista de arquivos de imagem."""
        from PIL import Image
        
        imagens = [Image.open(f) for f in lista_arquivos]
        imagens[0].save(arquivo_saida, save_all=True, append_images=imagens[1:],
                        duration=1000//fps, loop=0)
    
    def plotar_sequencia(self, campos, tempos, titulo_base, nrows=2, ncols=3,
                         arquivo_saida=None):
        """Plota sequência de snapshots."""
        n_plots = min(len(campos), nrows * ncols)
        indices = np.linspace(0, len(campos)-1, n_plots).astype(int)
        
        fig, axes = plt.subplots(nrows, ncols, figsize=(5*ncols, 4*nrows))
        axes = axes.flatten()
        
        lon_grid, lat_grid = np.meshgrid(self.longitude, self.latitude)
        vmin, vmax = np.nanmin(campos), np.nanmax(campos)
        
        for i, (ax, idx) in enumerate(zip(axes, indices)):
            cs = ax.pcolormesh(lon_grid, lat_grid, campos[idx], cmap='RdYlBu_r',
                              vmin=vmin, vmax=vmax, shading='auto')
            ax.set_title(f'{tempos[idx]}', fontsize=10)
            ax.set_aspect('equal')
        
        plt.suptitle(titulo_base, fontsize=14)
        plt.tight_layout()
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150, bbox_inches='tight')
            plt.close()
        return fig
