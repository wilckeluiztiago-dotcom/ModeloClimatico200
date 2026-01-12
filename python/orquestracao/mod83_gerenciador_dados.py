"""
Módulo 83: Gerenciador de Dados
Autor: Luiz Tiago Wilcke
Descrição: Gerenciamento de dados do modelo.
"""

import numpy as np
from dataclasses import dataclass
from typing import Dict, Any, Optional

@dataclass
class EstadoModelo:
    """Estado completo do modelo climático."""
    temperatura: np.ndarray
    umidade: np.ndarray
    pressao_superficie: np.ndarray
    vento_u: np.ndarray
    vento_v: np.ndarray
    vento_w: Optional[np.ndarray] = None
    temperatura_oceano: Optional[np.ndarray] = None
    salinidade: Optional[np.ndarray] = None
    cobertura_neve: Optional[np.ndarray] = None
    cobertura_gelo: Optional[np.ndarray] = None


class GerenciadorDados:
    """Gerencia os dados do modelo durante a simulação."""
    
    def __init__(self, grade):
        self.grade = grade
        self.estado_atual = None
        self.historico = []
        self.diagnosticos = {}
    
    def inicializar_estado(self, condicoes_iniciais: Dict[str, np.ndarray]):
        """Inicializa o estado do modelo."""
        self.estado_atual = EstadoModelo(
            temperatura=condicoes_iniciais.get('temperatura'),
            umidade=condicoes_iniciais.get('umidade'),
            pressao_superficie=condicoes_iniciais.get('pressao'),
            vento_u=condicoes_iniciais.get('vento_u'),
            vento_v=condicoes_iniciais.get('vento_v')
        )
    
    def atualizar_estado(self, novos_valores: Dict[str, np.ndarray]):
        """Atualiza o estado com novos valores."""
        for campo, valor in novos_valores.items():
            if hasattr(self.estado_atual, campo):
                setattr(self.estado_atual, campo, valor)
    
    def salvar_snapshot(self, passo: int):
        """Salva um snapshot do estado atual."""
        snapshot = {
            'passo': passo,
            'temperatura_media': np.mean(self.estado_atual.temperatura),
            'temperatura_max': np.max(self.estado_atual.temperatura),
            'temperatura_min': np.min(self.estado_atual.temperatura),
            'umidade_media': np.mean(self.estado_atual.umidade),
            'energia_cinetica': 0.5 * np.mean(
                self.estado_atual.vento_u**2 + self.estado_atual.vento_v**2
            )
        }
        self.historico.append(snapshot)
    
    def obter_estatisticas(self):
        """Calcula estatísticas do estado atual."""
        return {
            'T_media_global': np.mean(self.estado_atual.temperatura[:, :, 0]),
            'T_max': np.max(self.estado_atual.temperatura),
            'T_min': np.min(self.estado_atual.temperatura),
            'vento_max': np.max(np.sqrt(
                self.estado_atual.vento_u**2 + self.estado_atual.vento_v**2
            ))
        }
    
    def calcular_medias_zonais(self, campo: np.ndarray):
        """Calcula médias zonais (por latitude)."""
        return np.mean(campo, axis=1)
    
    def calcular_media_global(self, campo_2d: np.ndarray, pesos_lat: np.ndarray):
        """Calcula média global ponderada por latitude."""
        return np.average(np.mean(campo_2d, axis=1), weights=pesos_lat)
