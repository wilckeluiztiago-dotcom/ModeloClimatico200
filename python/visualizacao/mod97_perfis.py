"""
Módulo 97: Perfis Verticais
Autor: Luiz Tiago Wilcke
Descrição: Visualização de perfis verticais.
"""

import numpy as np
import matplotlib.pyplot as plt

class PerfisVerticais:
    """Gera gráficos de perfis verticais."""
    
    @staticmethod
    def perfil_temperatura(T, z, titulo='Perfil de Temperatura', arquivo_saida=None):
        """Plota perfil vertical de temperatura."""
        fig, ax = plt.subplots(figsize=(6, 8))
        ax.plot(T, z/1000, 'b-', linewidth=2)
        ax.set_xlabel('Temperatura (K)', fontsize=12)
        ax.set_ylabel('Altitude (km)', fontsize=12)
        ax.set_title(titulo, fontsize=14)
        ax.grid(True, alpha=0.3)
        ax.axvline(273.15, color='gray', linestyle='--', alpha=0.5, label='0°C')
        ax.legend()
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150)
            plt.close()
        return fig
    
    @staticmethod
    def perfil_multiplo(dados_dict, z, titulo, xlabel, arquivo_saida=None):
        """Plota múltiplos perfis verticais."""
        fig, ax = plt.subplots(figsize=(8, 8))
        
        cores = plt.cm.tab10(np.linspace(0, 1, len(dados_dict)))
        
        for (nome, dados), cor in zip(dados_dict.items(), cores):
            ax.plot(dados, z/1000, label=nome, color=cor, linewidth=2)
        
        ax.set_xlabel(xlabel, fontsize=12)
        ax.set_ylabel('Altitude (km)', fontsize=12)
        ax.set_title(titulo, fontsize=14)
        ax.legend(loc='best')
        ax.grid(True, alpha=0.3)
        
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150)
            plt.close()
        return fig
    
    @staticmethod
    def perfil_oceano(T, z_oceano, titulo='Perfil de Temperatura Oceânico', arquivo_saida=None):
        """Plota perfil vertical oceânico."""
        fig, ax = plt.subplots(figsize=(6, 8))
        ax.plot(T, -z_oceano, 'r-', linewidth=2)
        ax.set_xlabel('Temperatura (°C)', fontsize=12)
        ax.set_ylabel('Profundidade (m)', fontsize=12)
        ax.set_title(titulo, fontsize=14)
        ax.grid(True, alpha=0.3)
        ax.invert_yaxis()
        plt.tight_layout()
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150)
            plt.close()
        return fig
    
    @staticmethod
    def diagrama_skew_t(T, p, Td=None, arquivo_saida=None):
        """Diagrama Skew-T simplificado."""
        fig, ax = plt.subplots(figsize=(8, 10))
        
        ax.semilogy(T - 273.15, p/100, 'r-', linewidth=2, label='Temperatura')
        if Td is not None:
            ax.semilogy(Td - 273.15, p/100, 'g--', linewidth=2, label='Ponto de Orvalho')
        
        ax.set_xlabel('Temperatura (°C)', fontsize=12)
        ax.set_ylabel('Pressão (hPa)', fontsize=12)
        ax.set_title('Diagrama Skew-T Simplificado', fontsize=14)
        ax.invert_yaxis()
        ax.set_ylim(1000, 100)
        ax.legend()
        ax.grid(True, alpha=0.3)
        
        if arquivo_saida:
            plt.savefig(arquivo_saida, dpi=150)
            plt.close()
        return fig
