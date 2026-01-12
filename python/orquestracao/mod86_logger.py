"""
Módulo 86: Logger
Autor: Luiz Tiago Wilcke
Descrição: Sistema de logging para a simulação.
"""

import logging
import os
from datetime import datetime

class LoggerModelo:
    """Sistema de logging para o modelo climático."""
    
    def __init__(self, nome='modelo_climatico', nivel=logging.INFO, diretorio_logs='./logs'):
        self.nome = nome
        self.diretorio_logs = diretorio_logs
        os.makedirs(diretorio_logs, exist_ok=True)
        
        self.logger = logging.getLogger(nome)
        self.logger.setLevel(nivel)
        
        # Handler para arquivo
        arquivo_log = os.path.join(
            diretorio_logs, 
            f'modelo_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log'
        )
        handler_arquivo = logging.FileHandler(arquivo_log)
        handler_arquivo.setLevel(nivel)
        
        # Handler para console
        handler_console = logging.StreamHandler()
        handler_console.setLevel(nivel)
        
        # Formato
        formato = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        handler_arquivo.setFormatter(formato)
        handler_console.setFormatter(formato)
        
        self.logger.addHandler(handler_arquivo)
        self.logger.addHandler(handler_console)
    
    def info(self, mensagem):
        self.logger.info(mensagem)
    
    def debug(self, mensagem):
        self.logger.debug(mensagem)
    
    def warning(self, mensagem):
        self.logger.warning(mensagem)
    
    def error(self, mensagem):
        self.logger.error(mensagem)
    
    def critical(self, mensagem):
        self.logger.critical(mensagem)
    
    def log_passo(self, passo, tempo, temperatura_media):
        """Log padrão para um passo de tempo."""
        self.info(f"Passo {passo:6d} | Tempo: {tempo} | T_media: {temperatura_media:.2f} K")
    
    def log_inicio_simulacao(self, config):
        """Log de início da simulação."""
        self.info("=" * 60)
        self.info("INÍCIO DA SIMULAÇÃO DO MODELO CLIMÁTICO")
        self.info(f"Experimento: {config.nome_experimento}")
        self.info(f"Grade: {config.grade.num_lat}x{config.grade.num_lon}x{config.grade.num_niveis_atm}")
        self.info("=" * 60)
    
    def log_fim_simulacao(self, tempo_execucao):
        """Log de fim da simulação."""
        self.info("=" * 60)
        self.info(f"SIMULAÇÃO CONCLUÍDA em {tempo_execucao:.2f} segundos")
        self.info("=" * 60)


def criar_logger(nome='modelo_climatico'):
    """Cria e retorna um logger configurado."""
    return LoggerModelo(nome)
