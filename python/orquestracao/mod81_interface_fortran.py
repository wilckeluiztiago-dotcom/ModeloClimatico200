"""
Módulo 81: Interface Fortran
Autor: Luiz Tiago Wilcke
Descrição: Interface Python-Fortran via ctypes/f2py.
"""

import numpy as np
import ctypes
import os

class InterfaceFortran:
    """Interface para chamar rotinas Fortran do modelo climático."""
    
    def __init__(self, caminho_biblioteca=None):
        self.biblioteca_carregada = False
        self.lib = None
        
        if caminho_biblioteca and os.path.exists(caminho_biblioteca):
            try:
                self.lib = ctypes.CDLL(caminho_biblioteca)
                self.biblioteca_carregada = True
            except Exception as e:
                print(f"Aviso: Não foi possível carregar biblioteca Fortran: {e}")
    
    def array_para_fortran(self, array_numpy):
        """Converte array NumPy para ordem Fortran."""
        return np.asfortranarray(array_numpy, dtype=np.float64)
    
    def array_de_fortran(self, array_fortran):
        """Converte array de ordem Fortran para C."""
        return np.ascontiguousarray(array_fortran)
    
    def chamar_subrotina(self, nome, *args):
        """Chama uma subrotina Fortran pelo nome."""
        if not self.biblioteca_carregada:
            raise RuntimeError("Biblioteca Fortran não carregada")
        
        func = getattr(self.lib, nome)
        return func(*args)
    
    def inicializar_grade(self, num_lat, num_lon, num_niveis):
        """Inicializa a grade espacial."""
        latitude = np.linspace(-90, 90, num_lat)
        longitude = np.linspace(-180, 180, num_lon)
        niveis = np.logspace(5, 0, num_niveis)
        
        return {
            'latitude': latitude,
            'longitude': longitude,
            'niveis_pressao': niveis,
            'num_lat': num_lat,
            'num_lon': num_lon,
            'num_niveis': num_niveis
        }
    
    def criar_estado_inicial(self, grade):
        """Cria estado inicial para o modelo."""
        nl = grade['num_lat']
        nlon = grade['num_lon']
        nk = grade['num_niveis']
        
        lat = grade['latitude']
        
        temperatura = np.zeros((nl, nlon, nk))
        for i, l in enumerate(lat):
            T_base = 300 - 50 * (l / 90) ** 2
            for k in range(nk):
                temperatura[i, :, k] = T_base - 6.5 * k * 1000 / nk
        
        umidade = 0.01 * np.exp(-np.arange(nk) / 5).reshape(1, 1, -1) * np.ones((nl, nlon, 1))
        pressao = 101325.0 * np.ones((nl, nlon))
        vento_u = np.zeros((nl, nlon, nk))
        vento_v = np.zeros((nl, nlon, nk))
        
        return {
            'temperatura': self.array_para_fortran(temperatura),
            'umidade': self.array_para_fortran(umidade),
            'pressao': self.array_para_fortran(pressao),
            'vento_u': self.array_para_fortran(vento_u),
            'vento_v': self.array_para_fortran(vento_v)
        }


def criar_interface(caminho_lib=None):
    """Função factory para criar interface."""
    return InterfaceFortran(caminho_lib)
