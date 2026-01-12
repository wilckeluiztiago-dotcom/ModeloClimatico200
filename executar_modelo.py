"""
Script de Execução e Geração de Gráficos - Modelo Climático
Autor: Luiz Tiago Wilcke
"""

import numpy as np
import matplotlib.pyplot as plt
import os
from datetime import datetime

# Configurar diretório de saída
DIRETORIO_SAIDA = "/home/luiztiagowilcke188/Área de trabalho/NovoModeloClimatico/src/data/saida"
os.makedirs(DIRETORIO_SAIDA, exist_ok=True)

print("=" * 70)
print("   MODELO CLIMÁTICO TERRESTRE COMPLETO")
print("   Autor: Luiz Tiago Wilcke")
print("=" * 70)
print()

# =============================================================================
# CONFIGURAÇÃO DA GRADE
# =============================================================================
NUM_LAT = 90
NUM_LON = 180
NUM_NIVEIS = 20

latitude = np.linspace(-90, 90, NUM_LAT)
longitude = np.linspace(-180, 180, NUM_LON)
niveis_pressao = np.logspace(5, 2, NUM_NIVEIS)  # 100000 Pa a 100 Pa

print(f"Grade configurada: {NUM_LAT} x {NUM_LON} x {NUM_NIVEIS}")
print(f"Latitude: {latitude[0]:.1f}° a {latitude[-1]:.1f}°")
print(f"Longitude: {longitude[0]:.1f}° a {longitude[-1]:.1f}°")
print()

# =============================================================================
# CONSTANTES FÍSICAS
# =============================================================================
CONSTANTE_SOLAR = 1361.0  # W/m²
CONSTANTE_STEFAN_BOLTZMANN = 5.67e-8  # W/(m²·K⁴)
CP_AR = 1005.0  # J/(kg·K)
RAIO_TERRA = 6.371e6  # m
OMEGA_TERRA = 7.292e-5  # rad/s

# =============================================================================
# CONDIÇÕES INICIAIS
# =============================================================================
print("Inicializando condições iniciais...")

# Temperatura inicial (padrão latitudinal)
temperatura = np.zeros((NUM_LAT, NUM_LON, NUM_NIVEIS))
for i, lat in enumerate(latitude):
    T_superficie = 288 - 40 * (lat / 90)**2  # Mais quente no equador
    for k in range(NUM_NIVEIS):
        lapse_rate = 6.5e-3  # K/m
        altitude = (1000 - niveis_pressao[k]/100) * 100  # Altitude aproximada
        temperatura[i, :, k] = T_superficie - lapse_rate * max(0, altitude)

# Umidade específica
umidade = np.zeros((NUM_LAT, NUM_LON, NUM_NIVEIS))
for k in range(NUM_NIVEIS):
    q_base = 0.01 * np.exp(-k / 5)
    umidade[:, :, k] = q_base * (1 + 0.3 * np.cos(np.radians(latitude))[:, np.newaxis])

# Pressão de superfície
pressao_superficie = 101325.0 * np.ones((NUM_LAT, NUM_LON))

# Ventos iniciais (corrente de jato simplificada)
vento_u = np.zeros((NUM_LAT, NUM_LON, NUM_NIVEIS))
vento_v = np.zeros((NUM_LAT, NUM_LON, NUM_NIVEIS))

for k in range(NUM_NIVEIS):
    for i, lat in enumerate(latitude):
        # Corrente de jato subtropical
        vento_u[i, :, k] = 30 * np.exp(-((lat - 30)**2 + (lat + 30)**2) / 400) * (k / NUM_NIVEIS)

print("Condições iniciais configuradas!")
print()

# =============================================================================
# SIMULAÇÃO
# =============================================================================
print("Executando simulação...")

NUM_PASSOS = 365  # Um ano de simulação diária
DT = 86400  # Passo de tempo: 1 dia em segundos

# Arrays para armazenar resultados
tempo_simulacao = np.arange(NUM_PASSOS)
temperatura_global = np.zeros(NUM_PASSOS)
temperatura_hemisferio_norte = np.zeros(NUM_PASSOS)
temperatura_hemisferio_sul = np.zeros(NUM_PASSOS)
precipitacao_global = np.zeros(NUM_PASSOS)
energia_cinetica = np.zeros(NUM_PASSOS)

# Pesos por latitude (área)
pesos_lat = np.cos(np.radians(latitude))
pesos_lat /= np.sum(pesos_lat)

for passo in range(NUM_PASSOS):
    dia_ano = passo % 365
    
    # Ciclo sazonal (declinação solar)
    declinacao = 23.45 * np.sin(2 * np.pi * (dia_ano - 80) / 365)
    
    # Radiação solar por latitude
    for i, lat in enumerate(latitude):
        cos_zenith = np.sin(np.radians(lat)) * np.sin(np.radians(declinacao)) + \
                     np.cos(np.radians(lat)) * np.cos(np.radians(declinacao))
        cos_zenith = max(0, cos_zenith)
        
        # Forçamento radiativo
        S_entrada = CONSTANTE_SOLAR * cos_zenith / 4
        albedo = 0.3 + 0.2 * (abs(lat) / 90)  # Maior nos polos
        
        # Emissão de onda longa
        T_sup = temperatura[i, :, 0]
        OLR = 0.6 * CONSTANTE_STEFAN_BOLTZMANN * T_sup**4
        
        # Balanço energético
        Q_net = S_entrada * (1 - albedo) - OLR
        
        # Tendência de temperatura
        dT = Q_net / (CP_AR * 100) * DT / 1000
        temperatura[i, :, 0] += dT
    
    # Difusão meridional de calor
    for j in range(NUM_LON):
        T_lat = temperatura[:, j, 0]
        dT_diff = 0.5 * (np.roll(T_lat, 1) + np.roll(T_lat, -1) - 2 * T_lat)
        dT_diff[0] = 0
        dT_diff[-1] = 0
        temperatura[:, j, 0] += dT_diff * 0.1
    
    # Precipitação simples (proporcional à umidade e temperatura)
    precipitacao = np.zeros((NUM_LAT, NUM_LON))
    for i, lat in enumerate(latitude):
        # ITCZ e zonas de convergência
        precip_base = 5 * np.exp(-((lat - declinacao/2)**2) / 100)
        precipitacao[i, :] = precip_base * (1 + 0.2 * np.random.randn(NUM_LON))
    
    # Cálculo de diagnósticos
    T_sup = temperatura[:, :, 0]
    temperatura_global[passo] = np.average(np.mean(T_sup, axis=1), weights=pesos_lat)
    
    mask_norte = latitude >= 0
    mask_sul = latitude < 0
    temperatura_hemisferio_norte[passo] = np.average(
        np.mean(T_sup[mask_norte, :], axis=1), 
        weights=pesos_lat[mask_norte] / np.sum(pesos_lat[mask_norte])
    )
    temperatura_hemisferio_sul[passo] = np.average(
        np.mean(T_sup[mask_sul, :], axis=1), 
        weights=pesos_lat[mask_sul] / np.sum(pesos_lat[mask_sul])
    )
    
    precipitacao_global[passo] = np.average(np.mean(precipitacao, axis=1), weights=pesos_lat)
    energia_cinetica[passo] = np.mean(vento_u**2 + vento_v**2)
    
    # Progresso
    if passo % 50 == 0:
        print(f"  Passo {passo:4d}/{NUM_PASSOS} | T_global = {temperatura_global[passo]:.2f} K")

print()
print("Simulação concluída!")
print()

# =============================================================================
# RESULTADOS NUMÉRICOS
# =============================================================================
print("=" * 70)
print("   RESULTADOS NUMÉRICOS")
print("=" * 70)
print()
print(f"Temperatura Global Média: {np.mean(temperatura_global):.2f} K ({np.mean(temperatura_global) - 273.15:.2f} °C)")
print(f"Temperatura Mínima Global: {np.min(temperatura_global):.2f} K")
print(f"Temperatura Máxima Global: {np.max(temperatura_global):.2f} K")
print(f"Amplitude Anual: {np.max(temperatura_global) - np.min(temperatura_global):.2f} K")
print()
print(f"Hemisfério Norte - Média: {np.mean(temperatura_hemisferio_norte):.2f} K")
print(f"Hemisfério Sul - Média: {np.mean(temperatura_hemisferio_sul):.2f} K")
print(f"Diferença NH - SH: {np.mean(temperatura_hemisferio_norte) - np.mean(temperatura_hemisferio_sul):.2f} K")
print()
print(f"Precipitação Global Média: {np.mean(precipitacao_global):.2f} mm/dia")
print()

# =============================================================================
# GERAÇÃO DE GRÁFICOS
# =============================================================================
print("Gerando gráficos...")

plt.style.use('default')
plt.rcParams['figure.facecolor'] = 'white'
plt.rcParams['axes.facecolor'] = 'white'
plt.rcParams['font.size'] = 10

# -----------------------------------------------------------------------------
# GRÁFICO 1: Série Temporal de Temperatura Global
# -----------------------------------------------------------------------------
fig1, ax1 = plt.subplots(figsize=(12, 5))
ax1.plot(tempo_simulacao, temperatura_global - 273.15, 'b-', linewidth=1.5, label='Global')
ax1.plot(tempo_simulacao, temperatura_hemisferio_norte - 273.15, 'r--', linewidth=1, label='Hemisfério Norte')
ax1.plot(tempo_simulacao, temperatura_hemisferio_sul - 273.15, 'g--', linewidth=1, label='Hemisfério Sul')
ax1.axhline(np.mean(temperatura_global) - 273.15, color='gray', linestyle=':', alpha=0.7, label='Média')
ax1.set_xlabel('Dia do Ano', fontsize=12)
ax1.set_ylabel('Temperatura (°C)', fontsize=12)
ax1.set_title('Evolução da Temperatura Global\nAutor: Luiz Tiago Wilcke', fontsize=14, fontweight='bold')
ax1.legend(loc='best')
ax1.grid(True, alpha=0.3)
ax1.set_xlim(0, NUM_PASSOS)
fig1.tight_layout()
fig1.savefig(os.path.join(DIRETORIO_SAIDA, 'temperatura_global_serie.png'), dpi=150, bbox_inches='tight')
print("  ✓ temperatura_global_serie.png")

# -----------------------------------------------------------------------------
# GRÁFICO 2: Mapa de Temperatura da Superfície
# -----------------------------------------------------------------------------
fig2, ax2 = plt.subplots(figsize=(14, 7))
lon_grid, lat_grid = np.meshgrid(longitude, latitude)
T_sup_celsius = temperatura[:, :, 0] - 273.15
cs2 = ax2.pcolormesh(lon_grid, lat_grid, T_sup_celsius, cmap='RdYlBu_r', shading='auto', vmin=-30, vmax=35)
cbar2 = plt.colorbar(cs2, ax=ax2, shrink=0.7, pad=0.02)
cbar2.set_label('Temperatura (°C)', fontsize=12)
ax2.set_xlabel('Longitude (°)', fontsize=12)
ax2.set_ylabel('Latitude (°)', fontsize=12)
ax2.set_title('Temperatura da Superfície (Final da Simulação)\nAutor: Luiz Tiago Wilcke', fontsize=14, fontweight='bold')
ax2.axhline(0, color='black', linestyle='--', alpha=0.3)
ax2.set_xlim(-180, 180)
ax2.set_ylim(-90, 90)
fig2.tight_layout()
fig2.savefig(os.path.join(DIRETORIO_SAIDA, 'mapa_temperatura.png'), dpi=150, bbox_inches='tight')
print("  ✓ mapa_temperatura.png")

# -----------------------------------------------------------------------------
# GRÁFICO 3: Perfil Zonal de Temperatura
# -----------------------------------------------------------------------------
fig3, ax3 = plt.subplots(figsize=(10, 6))
T_zonal = np.mean(temperatura[:, :, 0], axis=1) - 273.15
ax3.plot(latitude, T_zonal, 'b-', linewidth=2)
ax3.fill_between(latitude, T_zonal, alpha=0.3)
ax3.axhline(0, color='gray', linestyle='--', alpha=0.5)
ax3.axvline(0, color='gray', linestyle='--', alpha=0.5)
ax3.set_xlabel('Latitude (°)', fontsize=12)
ax3.set_ylabel('Temperatura (°C)', fontsize=12)
ax3.set_title('Perfil Zonal de Temperatura\nAutor: Luiz Tiago Wilcke', fontsize=14, fontweight='bold')
ax3.grid(True, alpha=0.3)
ax3.set_xlim(-90, 90)
fig3.tight_layout()
fig3.savefig(os.path.join(DIRETORIO_SAIDA, 'perfil_zonal_temperatura.png'), dpi=150, bbox_inches='tight')
print("  ✓ perfil_zonal_temperatura.png")

# -----------------------------------------------------------------------------
# GRÁFICO 4: Mapa de Precipitação
# -----------------------------------------------------------------------------
fig4, ax4 = plt.subplots(figsize=(14, 7))
cs4 = ax4.pcolormesh(lon_grid, lat_grid, precipitacao, cmap='Blues', shading='auto', vmin=0, vmax=10)
cbar4 = plt.colorbar(cs4, ax=ax4, shrink=0.7, pad=0.02)
cbar4.set_label('Precipitação (mm/dia)', fontsize=12)
ax4.set_xlabel('Longitude (°)', fontsize=12)
ax4.set_ylabel('Latitude (°)', fontsize=12)
ax4.set_title('Distribuição de Precipitação\nAutor: Luiz Tiago Wilcke', fontsize=14, fontweight='bold')
ax4.axhline(0, color='black', linestyle='--', alpha=0.3)
ax4.set_xlim(-180, 180)
ax4.set_ylim(-90, 90)
fig4.tight_layout()
fig4.savefig(os.path.join(DIRETORIO_SAIDA, 'mapa_precipitacao.png'), dpi=150, bbox_inches='tight')
print("  ✓ mapa_precipitacao.png")

# -----------------------------------------------------------------------------
# GRÁFICO 5: Corte Vertical de Temperatura
# -----------------------------------------------------------------------------
fig5, ax5 = plt.subplots(figsize=(12, 6))
T_zonal_vert = np.mean(temperatura, axis=1) - 273.15
lat_grid_v, p_grid = np.meshgrid(latitude, niveis_pressao / 100)
cs5 = ax5.contourf(lat_grid_v.T, p_grid.T, T_zonal_vert, 20, cmap='RdYlBu_r')
cbar5 = plt.colorbar(cs5, ax=ax5, shrink=0.8)
cbar5.set_label('Temperatura (°C)', fontsize=12)
ax5.set_xlabel('Latitude (°)', fontsize=12)
ax5.set_ylabel('Pressão (hPa)', fontsize=12)
ax5.set_title('Corte Vertical: Temperatura Média Zonal\nAutor: Luiz Tiago Wilcke', fontsize=14, fontweight='bold')
ax5.invert_yaxis()
ax5.set_yscale('log')
fig5.tight_layout()
fig5.savefig(os.path.join(DIRETORIO_SAIDA, 'corte_vertical_temperatura.png'), dpi=150, bbox_inches='tight')
print("  ✓ corte_vertical_temperatura.png")

# -----------------------------------------------------------------------------
# GRÁFICO 6: Ciclo Anual
# -----------------------------------------------------------------------------
fig6, axes6 = plt.subplots(2, 1, figsize=(12, 8), sharex=True)

# Temperatura
axes6[0].plot(tempo_simulacao, temperatura_global - 273.15, 'b-', linewidth=1.5)
axes6[0].fill_between(tempo_simulacao, 
                       np.min(temperatura_global) - 273.15, 
                       temperatura_global - 273.15, alpha=0.3)
axes6[0].set_ylabel('Temperatura Global (°C)', fontsize=12)
axes6[0].set_title('Ciclo Anual: Temperatura e Precipitação\nAutor: Luiz Tiago Wilcke', fontsize=14, fontweight='bold')
axes6[0].grid(True, alpha=0.3)

# Precipitação
axes6[1].plot(tempo_simulacao, precipitacao_global, 'g-', linewidth=1.5)
axes6[1].fill_between(tempo_simulacao, 0, precipitacao_global, alpha=0.3, color='green')
axes6[1].set_xlabel('Dia do Ano', fontsize=12)
axes6[1].set_ylabel('Precipitação (mm/dia)', fontsize=12)
axes6[1].grid(True, alpha=0.3)

fig6.tight_layout()
fig6.savefig(os.path.join(DIRETORIO_SAIDA, 'ciclo_anual.png'), dpi=150, bbox_inches='tight')
print("  ✓ ciclo_anual.png")

# -----------------------------------------------------------------------------
# GRÁFICO 7: Dashboard Resumo
# -----------------------------------------------------------------------------
fig7 = plt.figure(figsize=(16, 12))

# Subplot 1: Mapa de temperatura
ax7_1 = fig7.add_subplot(2, 2, 1)
cs7_1 = ax7_1.pcolormesh(lon_grid, lat_grid, T_sup_celsius, cmap='RdYlBu_r', shading='auto', vmin=-30, vmax=35)
plt.colorbar(cs7_1, ax=ax7_1, shrink=0.7)
ax7_1.set_title('Temperatura da Superfície (°C)')
ax7_1.set_xlabel('Longitude'); ax7_1.set_ylabel('Latitude')

# Subplot 2: Série temporal
ax7_2 = fig7.add_subplot(2, 2, 2)
ax7_2.plot(tempo_simulacao, temperatura_global - 273.15, 'b-', linewidth=1.5)
ax7_2.set_title('Evolução Temporal')
ax7_2.set_xlabel('Dia'); ax7_2.set_ylabel('T Global (°C)')
ax7_2.grid(True, alpha=0.3)

# Subplot 3: Perfil zonal
ax7_3 = fig7.add_subplot(2, 2, 3)
ax7_3.plot(latitude, T_zonal, 'r-', linewidth=2)
ax7_3.set_title('Perfil Zonal de Temperatura')
ax7_3.set_xlabel('Latitude (°)'); ax7_3.set_ylabel('T (°C)')
ax7_3.grid(True, alpha=0.3)

# Subplot 4: Estatísticas
ax7_4 = fig7.add_subplot(2, 2, 4)
stats_text = f"""
ESTATÍSTICAS DA SIMULAÇÃO
================================

Duração: {NUM_PASSOS} dias

TEMPERATURA
  Global Média: {np.mean(temperatura_global):.2f} K
  Global Mínima: {np.min(temperatura_global):.2f} K
  Global Máxima: {np.max(temperatura_global):.2f} K
  Amplitude: {np.max(temperatura_global) - np.min(temperatura_global):.2f} K
  
  Hemisfério Norte: {np.mean(temperatura_hemisferio_norte):.2f} K
  Hemisfério Sul: {np.mean(temperatura_hemisferio_sul):.2f} K
  
PRECIPITAÇÃO
  Média Global: {np.mean(precipitacao_global):.2f} mm/dia

================================
Autor: Luiz Tiago Wilcke
"""
ax7_4.text(0.1, 0.5, stats_text, fontsize=11, family='monospace',
           transform=ax7_4.transAxes, verticalalignment='center')
ax7_4.axis('off')

fig7.suptitle('MODELO CLIMÁTICO TERRESTRE - DASHBOARD\nAutor: Luiz Tiago Wilcke', 
              fontsize=16, fontweight='bold', y=0.98)
fig7.tight_layout(rect=[0, 0, 1, 0.95])
fig7.savefig(os.path.join(DIRETORIO_SAIDA, 'dashboard_resumo.png'), dpi=150, bbox_inches='tight')
print("  ✓ dashboard_resumo.png")

# Fechar todas as figuras
plt.close('all')

print()
print("=" * 70)
print("   GERAÇÃO CONCLUÍDA!")
print("=" * 70)
print()
print(f"Arquivos salvos em: {DIRETORIO_SAIDA}")
print()
print("Gráficos gerados:")
print("  1. temperatura_global_serie.png")
print("  2. mapa_temperatura.png")
print("  3. perfil_zonal_temperatura.png")
print("  4. mapa_precipitacao.png")
print("  5. corte_vertical_temperatura.png")
print("  6. ciclo_anual.png")
print("  7. dashboard_resumo.png")
print()
