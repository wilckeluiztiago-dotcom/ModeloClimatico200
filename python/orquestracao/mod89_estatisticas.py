"""
Módulo 89: Estatísticas Climáticas
Autor: Luiz Tiago Wilcke
Descrição: Análises estatísticas climáticas.
"""

import numpy as np
from scipy import stats

class EstatisticasClimaticas:
    """Análises estatísticas para dados climáticos."""
    
    @staticmethod
    def media_movel(dados, janela):
        """Calcula média móvel."""
        return np.convolve(dados, np.ones(janela)/janela, mode='valid')
    
    @staticmethod
    def tendencia_linear(tempo, dados):
        """Calcula tendência linear."""
        slope, intercept, r_value, p_value, std_err = stats.linregress(tempo, dados)
        return {
            'inclinacao': slope,
            'intercepto': intercept,
            'r_quadrado': r_value**2,
            'p_valor': p_value,
            'erro_padrao': std_err
        }
    
    @staticmethod
    def percentis(dados, percentis=[5, 25, 50, 75, 95]):
        """Calcula percentis."""
        return {p: np.percentile(dados, p) for p in percentis}
    
    @staticmethod
    def desvio_padrao_espacial(campo_2d):
        """Calcula desvio padrão espacial."""
        return np.std(campo_2d)
    
    @staticmethod
    def correlacao_espacial(campo1, campo2):
        """Calcula correlação entre dois campos."""
        return np.corrcoef(campo1.flatten(), campo2.flatten())[0, 1]
    
    @staticmethod
    def analise_espectral(serie_temporal, dt):
        """Análise espectral simples."""
        n = len(serie_temporal)
        freq = np.fft.fftfreq(n, dt)
        potencia = np.abs(np.fft.fft(serie_temporal))**2
        return freq[:n//2], potencia[:n//2]
    
    @staticmethod
    def ciclo_anual(dados_diarios):
        """Extrai ciclo anual médio."""
        dias_ano = 365
        ciclo = np.zeros(dias_ano)
        contagem = np.zeros(dias_ano)
        
        for i, valor in enumerate(dados_diarios):
            dia = i % dias_ano
            ciclo[dia] += valor
            contagem[dia] += 1
        
        return ciclo / np.maximum(contagem, 1)
    
    @staticmethod
    def anomalia_padronizada(dados, climatologia, desvio_padrao):
        """Calcula anomalia padronizada."""
        return (dados - climatologia) / desvio_padrao


def calcular_estatisticas_resumo(dados):
    """Calcula estatísticas resumidas."""
    return {
        'media': np.mean(dados),
        'mediana': np.median(dados),
        'desvio_padrao': np.std(dados),
        'minimo': np.min(dados),
        'maximo': np.max(dados),
        'amplitude': np.max(dados) - np.min(dados)
    }
