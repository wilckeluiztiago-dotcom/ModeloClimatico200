"""
Módulo 82: Controle de Simulação
Autor: Luiz Tiago Wilcke
Descrição: Controle do loop temporal da simulação.
"""

import numpy as np
from datetime import datetime, timedelta

class ControleSimulacao:
    """Controla a execução temporal do modelo climático."""
    
    def __init__(self, data_inicio, data_fim, passo_tempo_segundos=3600):
        self.data_inicio = data_inicio
        self.data_fim = data_fim
        self.passo_tempo = timedelta(seconds=passo_tempo_segundos)
        self.tempo_atual = data_inicio
        self.passo_atual = 0
        self.tempo_total_segundos = (data_fim - data_inicio).total_seconds()
        self.passos_totais = int(self.tempo_total_segundos / passo_tempo_segundos)
    
    def avancar(self):
        """Avança um passo de tempo."""
        self.tempo_atual += self.passo_tempo
        self.passo_atual += 1
        return not self.simulacao_completa()
    
    def simulacao_completa(self):
        """Verifica se a simulação terminou."""
        return self.tempo_atual >= self.data_fim
    
    def progresso(self):
        """Retorna o progresso da simulação (0-100)."""
        return (self.passo_atual / self.passos_totais) * 100
    
    def dia_do_ano(self):
        """Retorna o dia do ano atual."""
        return self.tempo_atual.timetuple().tm_yday
    
    def hora_do_dia(self):
        """Retorna a hora do dia atual."""
        return self.tempo_atual.hour + self.tempo_atual.minute / 60.0
    
    def info_tempo(self):
        """Retorna informações sobre o tempo atual."""
        return {
            'data_atual': self.tempo_atual,
            'passo': self.passo_atual,
            'dia_ano': self.dia_do_ano(),
            'hora': self.hora_do_dia(),
            'progresso': self.progresso()
        }
    
    def resetar(self):
        """Reinicia a simulação."""
        self.tempo_atual = self.data_inicio
        self.passo_atual = 0


class GerenciadorEventos:
    """Gerencia eventos durante a simulação."""
    
    def __init__(self):
        self.eventos = []
        self.callbacks = {}
    
    def registrar_evento(self, nome, intervalo_passos, callback):
        """Registra um evento periódico."""
        self.eventos.append({
            'nome': nome,
            'intervalo': intervalo_passos,
            'callback': callback
        })
    
    def verificar_eventos(self, passo_atual):
        """Verifica e executa eventos agendados."""
        for evento in self.eventos:
            if passo_atual % evento['intervalo'] == 0:
                evento['callback'](passo_atual)


def criar_simulacao_anual(ano=2024):
    """Cria simulação para um ano completo."""
    inicio = datetime(ano, 1, 1)
    fim = datetime(ano, 12, 31, 23, 59)
    return ControleSimulacao(inicio, fim, passo_tempo_segundos=3600)
