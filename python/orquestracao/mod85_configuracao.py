"""
Módulo 85: Configuração
Autor: Luiz Tiago Wilcke
Descrição: Leitura e gerenciamento de configurações.
"""

import json
import os
from dataclasses import dataclass, asdict
from typing import Optional

@dataclass
class ConfiguracaoGrade:
    """Configuração da grade espacial."""
    num_lat: int = 90
    num_lon: int = 180
    num_niveis_atm: int = 30
    num_niveis_oceano: int = 20

@dataclass
class ConfiguracaoTempo:
    """Configuração temporal."""
    passo_tempo_segundos: float = 3600.0
    duracao_dias: int = 365
    intervalo_saida_horas: int = 24

@dataclass
class ConfiguracaoFisica:
    """Configuração dos parâmetros físicos."""
    co2_ppm: float = 420.0
    constante_solar: float = 1361.0
    usar_oceano_dinamico: bool = True
    usar_ciclo_carbono: bool = True

@dataclass
class ConfiguracaoModelo:
    """Configuração completa do modelo."""
    grade: ConfiguracaoGrade = None
    tempo: ConfiguracaoTempo = None
    fisica: ConfiguracaoFisica = None
    nome_experimento: str = "experimento_padrao"
    
    def __post_init__(self):
        if self.grade is None:
            self.grade = ConfiguracaoGrade()
        if self.tempo is None:
            self.tempo = ConfiguracaoTempo()
        if self.fisica is None:
            self.fisica = ConfiguracaoFisica()


class GerenciadorConfiguracao:
    """Gerencia configurações do modelo."""
    
    def __init__(self, arquivo_config: Optional[str] = None):
        self.config = ConfiguracaoModelo()
        if arquivo_config and os.path.exists(arquivo_config):
            self.carregar(arquivo_config)
    
    def carregar(self, arquivo: str):
        """Carrega configuração de arquivo JSON."""
        with open(arquivo, 'r') as f:
            dados = json.load(f)
        
        if 'grade' in dados:
            self.config.grade = ConfiguracaoGrade(**dados['grade'])
        if 'tempo' in dados:
            self.config.tempo = ConfiguracaoTempo(**dados['tempo'])
        if 'fisica' in dados:
            self.config.fisica = ConfiguracaoFisica(**dados['fisica'])
        if 'nome_experimento' in dados:
            self.config.nome_experimento = dados['nome_experimento']
    
    def salvar(self, arquivo: str):
        """Salva configuração em arquivo JSON."""
        dados = {
            'nome_experimento': self.config.nome_experimento,
            'grade': asdict(self.config.grade),
            'tempo': asdict(self.config.tempo),
            'fisica': asdict(self.config.fisica)
        }
        with open(arquivo, 'w') as f:
            json.dump(dados, f, indent=2)
    
    def obter(self):
        """Retorna configuração atual."""
        return self.config
