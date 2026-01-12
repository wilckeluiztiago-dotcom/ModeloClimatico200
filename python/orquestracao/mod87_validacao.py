"""
Módulo 87: Validação
Autor: Luiz Tiago Wilcke
Descrição: Validação de dados e parâmetros.
"""

import numpy as np
from typing import Tuple, Optional

class ValidadorDados:
    """Valida dados do modelo climático."""
    
    def __init__(self):
        self.limites = {
            'temperatura': (150.0, 350.0),  # K
            'pressao': (100.0, 110000.0),   # Pa
            'umidade': (0.0, 0.05),         # kg/kg
            'vento': (-200.0, 200.0),       # m/s
            'radiacao': (0.0, 1500.0)       # W/m²
        }
    
    def validar_campo(self, campo: np.ndarray, nome: str) -> Tuple[bool, str]:
        """Valida um campo numérico."""
        if np.any(np.isnan(campo)):
            return False, f"Campo {nome} contém NaN"
        
        if np.any(np.isinf(campo)):
            return False, f"Campo {nome} contém Inf"
        
        if nome in self.limites:
            vmin, vmax = self.limites[nome]
            if np.any(campo < vmin) or np.any(campo > vmax):
                return False, f"Campo {nome} fora dos limites [{vmin}, {vmax}]"
        
        return True, "OK"
    
    def validar_conservacao_massa(self, massa_anterior: float, massa_atual: float, 
                                   tolerancia: float = 1e-6) -> bool:
        """Verifica conservação de massa."""
        erro_relativo = abs(massa_atual - massa_anterior) / massa_anterior
        return erro_relativo < tolerancia
    
    def validar_conservacao_energia(self, energia_anterior: float, energia_atual: float,
                                     fonte: float, tolerancia: float = 1e-4) -> bool:
        """Verifica conservação de energia."""
        erro = abs(energia_atual - energia_anterior - fonte)
        return erro < tolerancia * abs(energia_anterior)
    
    def validar_estado_completo(self, estado) -> Tuple[bool, list]:
        """Valida o estado completo do modelo."""
        erros = []
        
        campos = [
            ('temperatura', estado.temperatura),
            ('umidade', estado.umidade),
            ('pressao', estado.pressao_superficie),
            ('vento', estado.vento_u),
            ('vento', estado.vento_v)
        ]
        
        for nome, campo in campos:
            if campo is not None:
                valido, msg = self.validar_campo(campo, nome)
                if not valido:
                    erros.append(msg)
        
        return len(erros) == 0, erros
    
    def verificar_cfl(self, u_max: float, dx: float, dt: float) -> Tuple[bool, float]:
        """Verifica condição CFL."""
        cfl = u_max * dt / dx
        return cfl < 1.0, cfl


def criar_validador():
    """Cria validador padrão."""
    return ValidadorDados()
