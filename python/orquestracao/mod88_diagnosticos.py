"""
Módulo 88: Diagnósticos
Autor: Luiz Tiago Wilcke
Descrição: Cálculos diagnósticos do modelo.
"""

import numpy as np

class Diagnosticos:
    """Calcula diagnósticos do modelo climático."""
    
    def __init__(self, grade):
        self.grade = grade
        self.pesos_lat = np.cos(np.radians(grade['latitude']))
        self.pesos_lat /= np.sum(self.pesos_lat)
    
    def temperatura_media_global(self, T_superficie):
        """Calcula temperatura média global da superfície."""
        T_zonal = np.mean(T_superficie, axis=1)
        return np.sum(T_zonal * self.pesos_lat)
    
    def balanco_radiativo_toa(self, sw_in, sw_out, lw_out):
        """Calcula balanço radiativo no TOA."""
        return sw_in - sw_out - lw_out
    
    def energia_cinetica_total(self, u, v, rho, dV):
        """Calcula energia cinética total."""
        return 0.5 * np.sum(rho * (u**2 + v**2) * dV)
    
    def vorticidade_relativa(self, u, v, dx, dy):
        """Calcula vorticidade relativa."""
        dudy = np.gradient(u, dy, axis=0)
        dvdx = np.gradient(v, dx, axis=1)
        return dvdx - dudy
    
    def divergencia_horizontal(self, u, v, dx, dy):
        """Calcula divergência horizontal."""
        dudx = np.gradient(u, dx, axis=1)
        dvdy = np.gradient(v, dy, axis=0)
        return dudx + dvdy
    
    def transporte_calor_meridional(self, v, T, cp=1005.0):
        """Calcula transporte de calor meridional."""
        vT = v * T
        return cp * np.mean(vT, axis=(1, 2))
    
    def indice_nino34(self, sst, lat, lon):
        """Calcula índice Niño 3.4."""
        lat_mask = (lat >= -5) & (lat <= 5)
        lon_mask = (lon >= -170) & (lon <= -120)
        sst_nino = sst[np.ix_(lat_mask, lon_mask)]
        return np.mean(sst_nino)
    
    def precipitacao_total(self, precip, area_celula):
        """Calcula precipitação total."""
        return np.sum(precip * area_celula)


def calcular_climatologia(dados_diarios, eixo_tempo=0):
    """Calcula climatologia média."""
    return np.mean(dados_diarios, axis=eixo_tempo)

def calcular_anomalia(dados, climatologia):
    """Calcula anomalia em relação à climatologia."""
    return dados - climatologia
