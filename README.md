# 🌍 Modelo Climático Terrestre Completo

## Autor: Luiz Tiago Wilcke

---

## 📋 Descrição

Este é um **modelo climático global completo** do planeta Terra, implementado em **100 módulos**:

- **80 módulos Fortran90**: Núcleo físico e métodos numéricos
- **10 módulos Python/Orquestração**: Controle e gerenciamento da simulação
- **10 módulos Python/Visualização**: Gráficos e análise de dados

O modelo simula os principais processos físicos do sistema climático terrestre.

---

## 📐 Equações Diferenciais Principais

### Equações Primitivas da Atmosfera
```
∂v⃗/∂t + (v⃗ · ∇)v⃗ + f k̂ × v⃗ = -1/ρ ∇p + g⃗ + F⃗
```

### Equação de Clausius-Clapeyron
```
eₛ(T) = e₀ exp[Lᵥ/Rᵥ (1/T₀ - 1/T)]
```

### Forçamento Radiativo do CO₂
```
ΔF = 5.35 ln(C/C₀) [W/m²]
```

### Temperatura de Equilíbrio
```
T = [S₀(1-α)/(4εσ)]^(1/4)
```

---

## 📁 Estrutura do Projeto

```
NovoModeloClimatico/
├── README.md
├── executar_modelo.py
├── requirements.txt
└── src/
    ├── fortran/                    # 80 módulos Fortran
    │   ├── mod01-mod80.f90
    │   ├── programa_principal.f90
    │   ├── modelo_climatico        # Executável
    │   └── Makefile
    ├── python/
    │   ├── orquestracao/           # 10 módulos Python
    │   │   └── mod81-mod90.py
    │   └── visualizacao/           # 10 módulos Python
    │       └── mod91-mod100.py
    └── data/
        └── saida/                  # Resultados e gráficos
```

---

## 🔬 MÓDULOS FORTRAN (1-80)

### Categoria 1: Constantes e Configuração (Módulos 1-5)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **01** | `mod01_constantes_fisicas.f90` | Constantes físicas universais: G, k_B, σ, c, N_A. Constantes atmosféricas: R_d, R_v, c_p, c_v. Constantes oceânicas e radiativas. |
| **02** | `mod02_parametros_planeta.f90` | Parâmetros da Terra: raio, massa, Ω. Funções: distância solar, declinação, irradiância TOA, parâmetro Coriolis, ângulo zenital. |
| **03** | `mod03_grade_espacial.f90` | Grade 3D: latitude, longitude, níveis verticais. Funções: área de célula, atmosfera padrão, máscara de continentes, média global ponderada. |
| **04** | `mod04_condicoes_iniciais.f90` | Inicialização: temperatura, umidade, pressão, ventos. Perfis atmosféricos e oceânicos iniciais. |
| **05** | `mod05_configuracao_modelo.f90` | Configuração temporal: dt, duração, intervalos de saída. Controle de simulação. |

---

### Categoria 2: Dinâmica Atmosférica (Módulos 6-15)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **06** | `mod06_equacoes_primitivas.f90` | Equações primitivas: tendências de U, V, divergência horizontal. Base da dinâmica atmosférica. |
| **07** | `mod07_navier_stokes.f90` | Equações de Navier-Stokes 3D para fluidos viscosos. Número de Reynolds. |
| **08** | `mod08_adveccao_atmosferica.f90` | Advecção de escalares (T, q). Esquema upwind para transporte. |
| **09** | `mod09_difusao_turbulenta.f90` | Difusão horizontal e vertical. Viscosidade turbulenta. |
| **10** | `mod10_forca_coriolis.f90` | Força de Coriolis: f = 2Ω sin(φ). Número e raio de Rossby. |
| **11** | `mod11_gradiente_pressao.f90` | Gradiente de pressão horizontal. Pressão hidrostática. Altura geopotencial. |
| **12** | `mod12_camada_limite.f90` | Camada limite planetária (PBL): altura, u*, fluxos de superfície. Lei de Von Kármán. |
| **13** | `mod13_conveccao_profunda.f90` | Convecção profunda: CAPE, CIN, perfil de parcela, parametrização convectiva. |
| **14** | `mod14_ondas_gravidade.f90` | Ondas de gravidade: frequência Brunt-Väisälä, arrasto, velocidade de fase. |
| **15** | `mod15_vento_geostrofico.f90` | Vento geostrófico e vento térmico. Balanço geostrófico. |

---

### Categoria 3: Termodinâmica Atmosférica (Módulos 16-25)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **16** | `mod16_equacao_estado.f90` | Equação de estado para ar úmido: ρ = p/(R_d T_v). Temperatura virtual. |
| **17** | `mod17_energia_interna.f90` | Energia interna específica, balanço energético, entalpia. |
| **18** | `mod18_entalpia_atmosfera.f90` | Entalpia específica do ar úmido. Calor específico. |
| **19** | `mod19_umidade_atmosferica.f90` | Umidade relativa, pressão de saturação, umidade específica, ponto de orvalho. |
| **20** | `mod20_pressao_saturacao.f90` | Equação de Clausius-Clapeyron. Saturação sobre gelo. Temperatura LCL. |
| **21** | `mod21_temperatura_potencial.f90` | Temperatura potencial θ, θ_v virtual, θ_e equivalente. |
| **22** | `mod22_estabilidade_atmosferica.f90` | Índices de estabilidade: Lifted Index, Showalter, K-Index, Total Totals. |
| **23** | `mod23_lapse_rate.f90` | Taxas de lapso: adiabática seca (Γ_d), úmida (Γ_m), ambiental. |
| **24** | `mod24_troca_calor_latente.f90` | Calor latente de vaporização, condensação, fusão, sublimação. |
| **25** | `mod25_perfil_vertical.f90` | Perfis verticais de T, p, ρ. Atmosfera padrão. Escala de altura. |

---

### Categoria 4: Física de Nuvens (Módulos 26-35)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **26** | `mod26_microfisica_nuvens.f90` | Microfísica de nuvens quentes: condensação, supersaturação, conteúdo de água líquida. |
| **27** | `mod27_nucleacao_gotas.f90` | Nucleação de gotículas em CCN. Teoria de Köhler. Ativação. |
| **28** | `mod28_crescimento_gotas.f90` | Crescimento por condensação e coalescência. Colisão-coalescência. |
| **29** | `mod29_formacao_gelo.f90` | Formação de cristais de gelo. Nucleação homogênea e heterogênea. Processo Bergeron. |
| **30** | `mod30_precipitacao_quente.f90` | Precipitação quente: autoconversão, acreção, velocidade terminal. |
| **31** | `mod31_precipitacao_mista.f90` | Precipitação mista: neve, graupel, granizo. Riming. |
| **32** | `mod32_evaporacao_chuva.f90` | Evaporação de precipitação abaixo da base da nuvem. Virga. |
| **33** | `mod33_fracao_nuvens.f90` | Fração de cobertura de nuvens. Sobreposição aleatória/máxima. |
| **34** | `mod34_tipos_nuvens.f90` | Classificação: cumulus, stratus, cirrus, cumulonimbus. Níveis. |
| **35** | `mod35_aerossois_ccn.f90` | Aerossóis e CCN. Distribuição de tamanho. Efeitos indiretos. |

---

### Categoria 5: Radiação (Módulos 36-45)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **36** | `mod36_radiacao_solar.f90` | Radiação solar no TOA. Variação orbital. Constante solar. |
| **37** | `mod37_espectro_solar.f90` | Espectro solar: UV, visível, infravermelho. Bandas espectrais. |
| **38** | `mod38_absorcao_atmosferica.f90` | Absorção por gases: O₃, H₂O, CO₂. Coeficientes de absorção. |
| **39** | `mod39_espalhamento_rayleigh.f90` | Espalhamento Rayleigh por moléculas. Cor do céu. |
| **40** | `mod40_espalhamento_mie.f90` | Espalhamento Mie por aerossóis e gotículas. |
| **41** | `mod41_radiacao_onda_longa.f90` | Radiação terrestre (onda longa). Lei de Stefan-Boltzmann. Emissividade. |
| **42** | `mod42_efeito_estufa.f90` | Efeito estufa. Forçamento radiativo: CO₂, CH₄, N₂O. Sensibilidade climática. |
| **43** | `mod43_albedo_superficie.f90` | Albedo por tipo de superfície: oceano, terra, gelo, neve, vegetação. |
| **44** | `mod44_balanco_radiativo.f90` | Balanço radiativo no TOA: SW_in - SW_out - LW_out. |
| **45** | `mod45_transferencia_dois_fluxos.f90` | Método de dois fluxos para transferência radiativa. |

---

### Categoria 6: Oceano (Módulos 46-55)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **46** | `mod46_circulacao_termohalina.f90` | Circulação termohalina (MOC). Gradientes de densidade. Formação de águas profundas. |
| **47** | `mod47_correntes_superficiais.f90` | Correntes de superfície. Transporte de Ekman. Tensão do vento. |
| **48** | `mod48_mistura_vertical_oceano.f90` | Mistura vertical oceânica. Camada de mistura. Difusão. |
| **49** | `mod49_difusao_oceano.f90` | Difusão turbulenta horizontal e vertical no oceano. |
| **50** | `mod50_upwelling_downwelling.f90` | Ressurgência e subsidência costeira e equatorial. |
| **51** | `mod51_temperatura_oceano.f90` | Distribuição e evolução da temperatura oceânica. SST. Termoclina. |
| **52** | `mod52_salinidade.f90` | Distribuição de salinidade. Evaporação, precipitação, rios. |
| **53** | `mod53_densidade_oceano.f90` | Densidade oceânica (UNESCO). Estratificação. Frequência N². |
| **54** | `mod54_ondas_oceanicas.f90` | Ondas superficiais: altura, período, dispersão, Stokes. |
| **55** | `mod55_mares.f90` | Marés: amplitude, período, constituintes harmônicos. |

---

### Categoria 7: Superfície Terrestre (Módulos 56-60)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **56** | `mod56_solo_temperatura.f90` | Temperatura do solo. Condução de calor. Difusividade térmica. |
| **57** | `mod57_umidade_solo.f90` | Umidade do solo. Equação de Richards. Infiltração. Escoamento. |
| **58** | `mod58_vegetacao.f90` | Vegetação e evapotranspiração. LAI. Resistência estomática. |
| **59** | `mod59_topografia.f90` | Topografia e orografia. Elevação. Efeitos em ventos e precipitação. |
| **60** | `mod60_uso_solo.f90` | Uso do solo: floresta, agricultura, urbano. Mudança de cobertura. |

---

### Categoria 8: Criosfera (Módulos 61-65)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **61** | `mod61_gelo_marinho.f90` | Gelo marinho: concentração, espessura, dinâmica, termodinâmica. |
| **62** | `mod62_mantos_gelo.f90` | Mantos de gelo (Groenlândia, Antártica). Balanço de massa. Fluxo. |
| **63** | `mod63_geleiras.f90` | Geleiras de montanha. Linha de equilíbrio (ELA). Sensibilidade climática. |
| **64** | `mod64_permafrost.f90` | Permafrost. Camada ativa. Emissão de metano. |
| **65** | `mod65_neve.f90` | Neve: acúmulo, derretimento, equivalente em água (SWE), albedo. |

---

### Categoria 9: Ciclos Biogeoquímicos (Módulos 66-70)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **66** | `mod66_ciclo_carbono.f90` | Ciclo global do carbono. Fluxos ar-oceano, fotossíntese, respiração. GPP. |
| **67** | `mod67_co2_atmosferico.f90` | CO₂ atmosférico. Cenários RCP. Fertilização por CO₂. |
| **68** | `mod68_metano.f90` | Ciclo do metano. Emissões de wetlands. Tempo de vida. Forçamento. |
| **69** | `mod69_ozonio.f90` | Ozônio estratosférico e troposférico. Química de Chapman. Buraco de ozônio. |
| **70** | `mod70_nitrogenio.f90` | Ciclo do nitrogênio. N₂O. Deposição. Forçamento radiativo. |

---

### Categoria 10: Métodos Numéricos (Módulos 71-80)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **71** | `mod71_runge_kutta.f90` | Integração Runge-Kutta 4ª ordem. Escalar e vetorial. |
| **72** | `mod72_diferencas_finitas.f90` | Diferenças finitas: central, upwind, Laplaciano. |
| **73** | `mod73_espectral.f90` | Métodos espectrais: DFT, IDFT, harmônicos esféricos (Legendre). |
| **74** | `mod74_semi_lagrangiano.f90` | Advecção semi-Lagrangiana. Trajetória retrógrada. Interpolação. |
| **75** | `mod75_interpolacao.f90` | Interpolação: linear, cúbica, bilinear. Regridding. |
| **76** | `mod76_filtros_numericos.f90` | Filtros: Shapiro, Robert-Asselin. Difusão numérica. |
| **77** | `mod77_condicoes_contorno.f90` | Condições de contorno: periódica, polar, superfície, topo. |
| **78** | `mod78_acoplamento_modulos.f90` | Acoplamento atmosfera-oceano. Fluxos de calor e momento. |
| **79** | `mod79_paralelizacao.f90` | Estruturas para paralelização OpenMP. Decomposição de domínio. |
| **80** | `mod80_solver_linear.f90` | Solvers lineares: Gauss-Seidel, Thomas (tridiagonal). |

---

## 🐍 MÓDULOS PYTHON - ORQUESTRAÇÃO (81-90)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **81** | `mod81_interface_fortran.py` | Interface Python-Fortran via ctypes. Conversão de arrays. Inicialização de grade. |
| **82** | `mod82_controle_simulacao.py` | Controle temporal: data início/fim, passo de tempo, progresso. Eventos. |
| **83** | `mod83_gerenciador_dados.py` | Gerenciamento de estado: temperatura, umidade, ventos. Snapshots. Estatísticas. |
| **84** | `mod84_entrada_saida.py` | I/O: salvar/carregar campos binários (.npy), JSON, séries temporais. |
| **85** | `mod85_configuracao.py` | Configuração: grade, tempo, física. Dataclasses. Carregar/salvar JSON. |
| **86** | `mod86_logger.py` | Sistema de logging: arquivo e console. Logs de passo, início, fim. |
| **87** | `mod87_validacao.py` | Validação: limites físicos, NaN, Inf, conservação de massa/energia, CFL. |
| **88** | `mod88_diagnosticos.py` | Diagnósticos: T média global, balanço TOA, vorticidade, transporte de calor, Niño 3.4. |
| **89** | `mod89_estatisticas.py` | Estatísticas: média móvel, tendência linear, percentis, correlação, análise espectral. |
| **90** | `mod90_main_simulacao.py` | Script principal: orquestra toda a simulação, usa todos os módulos. |

---

## 📊 MÓDULOS PYTHON - VISUALIZAÇÃO (91-100)

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **91** | `mod91_mapa_global.py` | Mapas globais 2D: temperatura, precipitação. Colorbar, grid. |
| **92** | `mod92_projecoes.py` | Projeções: cilíndrica, polar estereográfica, Mollweide. |
| **93** | `mod93_cortes_verticais.py` | Seções verticais: latitude-altitude, longitude-altitude, média zonal. |
| **94** | `mod94_series_temporais.py` | Séries temporais: simples, múltiplas, com anomalia. |
| **95** | `mod95_anomalias.py` | Mapas de anomalias: escala divergente, tendências, significância estatística. |
| **96** | `mod96_animacoes.py` | Animações: evolução temporal, GIF, sequência de snapshots. |
| **97** | `mod97_perfis.py` | Perfis verticais: temperatura atmosférica, oceânica, Skew-T. |
| **98** | `mod98_diagramas_fase.py` | Diagramas: scatter 2D, Taylor, histograma 2D (joint distribution). |
| **99** | `mod99_comparacao.py` | Comparação modelo-observação: bias, RMSE, MAE, correlação. |
| **100** | `mod100_dashboard.py` | Dashboard interativo: múltiplos painéis, resumo de simulação. |

---

## 🚀 Como Usar

### 1. Compilar Fortran
```bash
cd src/fortran
make
./modelo_climatico
```

### 2. Executar Simulação Python
```bash
cd /path/to/NovoModeloClimatico
python3 executar_modelo.py
```

### 3. Resultados
Os resultados são salvos em `src/data/saida/`:
- `resultados_fortran.txt` - Saída numérica do Fortran
- `*.png` - Gráficos gerados pelo Python

---

## 📜 Licença

Este projeto foi desenvolvido para fins educacionais e de pesquisa.

**© 2024 Luiz Tiago Wilcke** - Todos os direitos reservados.
