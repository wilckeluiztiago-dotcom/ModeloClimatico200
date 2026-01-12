# 🌍 Modelo Climático Terrestre Completo

## Autor: Luiz Tiago Wilcke

---

## 📋 Descrição

Este é um **modelo climático global completo** do planeta Terra, implementado em **100 módulos**:

- **80 módulos Fortran90**: Núcleo físico e equações diferenciais
- **20 módulos Python**: Orquestração e visualização

O modelo simula os principais processos físicos do sistema climático, incluindo:
- Dinâmica atmosférica (equações primitivas, Navier-Stokes)
- Termodinâmica e física de nuvens
- Transferência radiativa
- Circulação oceânica
- Criosfera (gelo marinho, geleiras, neve)
- Ciclos biogeoquímicos (carbono, nitrogênio)

---

## 📐 Equações Diferenciais Principais

### 1. Equações Primitivas da Atmosfera

A dinâmica atmosférica é governada pelas equações primitivas:

**Equação do Momento (horizontal):**
```
∂v⃗/∂t + (v⃗ · ∇)v⃗ + f k̂ × v⃗ = -1/ρ ∇p + g⃗ + F⃗
```

Onde:
- `v⃗` = vetor velocidade (u, v)
- `f = 2Ω sin(φ)` = parâmetro de Coriolis
- `ρ` = densidade do ar
- `p` = pressão
- `g⃗` = aceleração gravitacional
- `F⃗` = forças de fricção

**Equação da Termodinâmica:**
```
∂T/∂t + v⃗ · ∇T = Q/cₚ + κ∇²T
```

**Equação da Continuidade:**
```
∂ρ/∂t + ∇ · (ρv⃗) = 0
```

---

### 2. Equações de Navier-Stokes

Para fluidos viscosos (oceano e atmosfera):

```
∂u/∂t + u ∂u/∂x + v ∂u/∂y + w ∂u/∂z = -1/ρ ∂p/∂x + ν∇²u + fv

∂v/∂t + u ∂v/∂x + v ∂v/∂y + w ∂v/∂z = -1/ρ ∂p/∂y + ν∇²v - fu

∂w/∂t + u ∂w/∂x + v ∂w/∂y + w ∂w/∂z = -1/ρ ∂p/∂z + ν∇²w - g
```

---

### 3. Equação de Clausius-Clapeyron

Relação entre pressão de saturação e temperatura:

```
deₛ/dT = Lᵥ eₛ / (Rᵥ T²)
```

Solução integrada:
```
eₛ(T) = e₀ exp[Lᵥ/Rᵥ (1/T₀ - 1/T)]
```

Onde:
- `eₛ` = pressão de saturação do vapor
- `Lᵥ = 2.501 × 10⁶ J/kg` = calor latente de vaporização
- `Rᵥ = 461.5 J/(kg·K)` = constante do vapor d'água

---

### 4. Equação de Transferência Radiativa

```
dI_λ/ds = -κ_λ ρ I_λ + j_λ
```

**Lei de Stefan-Boltzmann:**
```
E = εσT⁴
```

Onde `σ = 5.67 × 10⁻⁸ W/(m²·K⁴)`

**Método de Dois Fluxos:**
```
dF↑/dτ = γ₁F↑ - γ₂F↓
dF↓/dτ = γ₂F↑ - γ₁F↓
```

---

### 5. Circulação Termohalina

**Equação da Temperatura Oceânica:**
```
∂T/∂t + u⃗ · ∇T = Kₕ∇ₕ²T + Kᵥ ∂²T/∂z² + Qₜ
```

**Equação da Salinidade:**
```
∂S/∂t + u⃗ · ∇S = Kₕ∇ₕ²S + Kᵥ ∂²S/∂z² + Qₛ
```

**Equação de Estado (UNESCO):**
```
ρ = ρ₀[1 - α(T - T₀) + β(S - S₀)]
```

Onde:
- `α ≈ 2 × 10⁻⁴ K⁻¹` = coeficiente de expansão térmica
- `β ≈ 7.6 × 10⁻⁴ psu⁻¹` = coeficiente de contração halina

---

### 6. Forçamento Radiativo de Gases de Efeito Estufa

**CO₂:**
```
ΔF_CO₂ = 5.35 ln(C/C₀) [W/m²]
```

**CH₄:**
```
ΔF_CH₄ = 0.036 (√M - √M₀) [W/m²]
```

**N₂O:**
```
ΔF_N₂O = 0.12 (√N - √N₀) [W/m²]
```

---

### 7. Balanço Energético Global

```
C dT/dt = S₀(1-α)/4 - εσT⁴
```

**Temperatura de Equilíbrio:**
```
Tₑq = [S₀(1-α)/(4εσ)]^(1/4)
```

---

### 8. Frequência de Brunt-Väisälä

Estabilidade atmosférica/oceânica:

```
N² = (g/θ)(∂θ/∂z)
```

---

### 9. Número de Rossby

```
Ro = U / (fL)
```

---

### 10. Integração Numérica (Runge-Kutta 4ª Ordem)

```
k₁ = f(tₙ, yₙ)
k₂ = f(tₙ + dt/2, yₙ + dt·k₁/2)
k₃ = f(tₙ + dt/2, yₙ + dt·k₂/2)
k₄ = f(tₙ + dt, yₙ + dt·k₃)

yₙ₊₁ = yₙ + (dt/6)(k₁ + 2k₂ + 2k₃ + k₄)
```

---

## 📁 Estrutura do Projeto

```
NovoModeloClimatico/
├── src/
│   ├── fortran/           # 80 módulos Fortran
│   │   ├── mod01_constantes_fisicas.f90
│   │   ├── mod02_parametros_planeta.f90
│   │   ├── ... (até mod80)
│   │   └── Makefile
│   └── python/
│       ├── orquestracao/  # Módulos 81-90
│       │   ├── mod81_interface_fortran.py
│       │   └── ...
│       └── visualizacao/  # Módulos 91-100
│           ├── mod91_mapa_global.py
│           └── ...
├── README.md
└── requirements.txt
```

---

## 🔧 Instalação e Uso

### Requisitos
- **Fortran**: gfortran
- **Python 3.8+**: numpy, matplotlib, scipy

### Compilar Fortran
```bash
cd src/fortran
make
```

### Executar Simulação
```bash
cd src/python/orquestracao
python mod90_main_simulacao.py
```

---

## 📊 Módulos

### Fortran (1-80) - Núcleo Físico
| # | Módulo | Descrição |
|---|--------|-----------|
| 1-5 | Constantes | Física, planeta, grade |
| 6-15 | Dinâmica | Equações primitivas, Navier-Stokes |
| 16-25 | Termodinâmica | Estado, energia, umidade |
| 26-35 | Nuvens | Microfísica, precipitação |
| 36-45 | Radiação | Solar, onda longa, transferência |
| 46-55 | Oceano | Termohalina, correntes |
| 56-65 | Superfície | Solo, vegetação, criosfera |
| 66-70 | Biogeoquímica | Carbono, metano, ozônio |
| 71-80 | Numéricos | RK4, diferenças finitas |

### Python (81-100) - Orquestração e Visualização
| # | Módulo | Descrição |
|---|--------|-----------|
| 81-90 | Orquestração | Interface, controle, I/O |
| 91-100 | Visualização | Mapas, séries, dashboard |

---

## 📜 Licença

Este projeto foi desenvolvido para fins educacionais e de pesquisa.

**© 2024 Luiz Tiago Wilcke** - Todos os direitos reservados.
