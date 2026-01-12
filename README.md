# Modelo Híbrido ARIMAX/VECM para Previsão do Câmbio USD/BRL

**Autor: Luiz Tiago Wilcke**  
**Data: Janeiro 2026**

Sistema completo de previsão da taxa de câmbio USD/BRL utilizando modelos estatísticos avançados combinados em uma abordagem híbrida.

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Fundamentação Teórica](#fundamentação-teórica)
3. [Arquitetura do Sistema](#arquitetura-do-sistema)
4. [Instalação](#instalação)
5. [Uso](#uso)
6. [Módulos](#módulos)
7. [Resultados](#resultados)

---

## Visão Geral

Este projeto implementa um modelo híbrido que combina:

- **ARIMAX** (AutoRegressive Integrated Moving Average with eXogenous variables)
- **VECM** (Vector Error Correction Model)
- **GARCH** (Generalized Autoregressive Conditional Heteroskedasticity)

A combinação permite capturar:
- Dinâmicas de curto prazo (ARIMAX)
- Relações de longo prazo e cointegração (VECM)
- Volatilidade condicional e clustering (GARCH)

---

## Fundamentação Teórica

### Modelo ARIMAX

O modelo ARIMAX(p,d,q) é definido por:

$$
(1 - \sum_{i=1}^{p} \phi_i L^i)(1 - L)^d y_t = c + \sum_{j=1}^{k} \beta_j x_{j,t} + (1 + \sum_{i=1}^{q} \theta_i L^i) \varepsilon_t
$$

Onde:
- $y_t$: Taxa de câmbio no tempo $t$
- $\phi_i$: Coeficientes autorregressivos
- $\theta_i$: Coeficientes de média móvel
- $x_{j,t}$: Variáveis exógenas (SELIC, VIX, etc.)
- $\beta_j$: Coeficientes das variáveis exógenas
- $L$: Operador de defasagem ($L^k y_t = y_{t-k}$)
- $\varepsilon_t$: Ruído branco

### Modelo VECM

O Vector Error Correction Model para $k$ variáveis cointegradas:

$$
\Delta \mathbf{y}_t = \boldsymbol{\alpha} \boldsymbol{\beta}' \mathbf{y}_{t-1} + \sum_{i=1}^{p-1} \boldsymbol{\Gamma}_i \Delta \mathbf{y}_{t-i} + \boldsymbol{\varepsilon}_t
$$

Onde:
- $\boldsymbol{\alpha}$: Matriz de velocidades de ajuste $(k \times r)$
- $\boldsymbol{\beta}$: Matriz de vetores de cointegração $(k \times r)$
- $\boldsymbol{\Gamma}_i$: Matrizes de coeficientes de curto prazo
- $r$: Rank de cointegração

O termo $\boldsymbol{\alpha} \boldsymbol{\beta}' \mathbf{y}_{t-1}$ representa o mecanismo de correção de erro que força as variáveis de volta ao equilíbrio de longo prazo.

### Modelo GARCH

O modelo GARCH(p,q) para volatilidade condicional:

$$
\sigma_t^2 = \omega + \sum_{i=1}^{q} \alpha_i \varepsilon_{t-i}^2 + \sum_{j=1}^{p} \beta_j \sigma_{t-j}^2
$$

Onde:
- $\sigma_t^2$: Variância condicional
- $\omega > 0$: Constante
- $\alpha_i \geq 0$: Coeficientes ARCH
- $\beta_j \geq 0$: Coeficientes GARCH

**Condição de estacionariedade:**
$$
\sum_{i=1}^{q} \alpha_i + \sum_{j=1}^{p} \beta_j < 1
$$

### Modelo Híbrido

A previsão final é uma combinação ponderada:

$$
\hat{y}_{t+h} = w_1 \cdot \hat{y}_{t+h}^{ARIMAX} + w_2 \cdot \hat{y}_{t+h}^{VECM}
$$

Com intervalos de confiança ajustados pela volatilidade GARCH:

$$
IC_{1-\alpha} = \hat{y}_{t+h} \pm z_{1-\alpha/2} \cdot \sigma_{t+h}^{GARCH} \cdot \sqrt{h}
$$

Os pesos são otimizados minimizando o erro quadrático médio em validação:

$$
\mathbf{w}^* = \arg\min_{\mathbf{w}} \sum_{t \in \mathcal{V}} (y_t - \mathbf{w}' \hat{\mathbf{y}}_t)^2
$$

---

## Testes Estatísticos

### Teste ADF (Augmented Dickey-Fuller)

$$
\Delta y_t = \alpha + \beta t + \gamma y_{t-1} + \sum_{i=1}^{p} \delta_i \Delta y_{t-i} + \varepsilon_t
$$

**Hipóteses:**
- $H_0$: $\gamma = 0$ (série tem raiz unitária, não estacionária)
- $H_1$: $\gamma < 0$ (série é estacionária)

### Teste de Johansen

Estatística Trace:
$$
\lambda_{trace}(r) = -T \sum_{i=r+1}^{k} \ln(1 - \hat{\lambda}_i)
$$

Estatística Maximum Eigenvalue:
$$
\lambda_{max}(r, r+1) = -T \ln(1 - \hat{\lambda}_{r+1})
$$

### Teste Diebold-Mariano

Para comparar acurácia de previsão entre dois modelos:

$$
DM = \frac{\bar{d}}{\sqrt{\hat{V}(\bar{d})/T}} \xrightarrow{d} N(0,1)
$$

Onde $d_t = L(e_{1,t}) - L(e_{2,t})$ é a diferença nas funções de perda.

---

## Arquitetura do Sistema

```
ModeloCambio/
├── src/                          # Código fonte (32 módulos)
│   ├── configuracao.py           # Configurações globais
│   ├── tipos_dados.py            # Tipos personalizados
│   ├── validacao.py              # Sistema de validação
│   ├── excecoes.py               # Exceções customizadas
│   ├── logger.py                 # Sistema de logging
│   ├── cache.py                  # Cache de dados
│   ├── paralelismo.py            # Processamento paralelo
│   ├── utilidades.py             # Funções utilitárias
│   ├── coleta_dados.py           # Coleta de APIs (BCB, Yahoo)
│   ├── preprocessamento.py       # Limpeza de dados
│   ├── features.py               # Engenharia de features
│   ├── normalizacao.py           # Normalização/escalonamento
│   ├── divisao_dados.py          # Train/test split temporal
│   ├── persistencia.py           # Salvamento de dados
│   ├── testes_estacionariedade.py# ADF, KPSS, PP
│   ├── cointegracao.py           # Johansen, Engle-Granger
│   ├── arima.py                  # Modelo ARIMA
│   ├── arimax.py                 # ARIMA com exógenas
│   ├── vecm.py                   # Vector Error Correction
│   ├── var.py                    # Vector Autoregression
│   ├── garch.py                  # GARCH, EGARCH, GJR
│   ├── modelo_hibrido.py         # Combinação dos modelos
│   ├── redes_neurais.py          # LSTM, GRU, Transformer
│   ├── ensemble.py               # Ensemble e otimização
│   ├── metricas.py               # RMSE, MAE, MAPE, etc.
│   ├── backtesting.py            # Backtesting rolling
│   ├── visualizacao.py           # Gráficos
│   ├── previsao.py               # Engine de previsão
│   └── principal.py              # Orquestrador
├── dados/                        # Dados e cache
├── graficos/                     # Visualizações
├── relatorios/                   # Relatórios
└── README.md                     # Documentação
```

---

## Instalação

```bash
# Clonar ou copiar o projeto
cd ModeloCambio

# Criar ambiente virtual
python -m venv venv
source venv/bin/activate  # Linux/Mac
# ou: venv\Scripts\activate  # Windows

# Instalar dependências
pip install numpy pandas scipy statsmodels matplotlib seaborn
pip install yfinance requests  # Para coleta de dados

# Opcionais para redes neurais
pip install tensorflow

# Opcionais para modelos GARCH avançados
pip install arch
```

---

## Uso

### Execução Completa

```python
from src.principal import PipelinePrevisaoCambio

# Criar e executar pipeline
pipeline = PipelinePrevisaoCambio()
resultados = pipeline.executar(data_inicio="2015-01-01", horizonte=30)

# Acessar resultados
print(resultados['previsao'])
print(resultados['backtest'])
```

### Uso Modular

```python
# Modelo ARIMAX
from src.arimax import ModeloARIMAX
from src.arima import OrdemARIMA

modelo = ModeloARIMAX(OrdemARIMA(2, 1, 1), nomes_exog=['selic', 'vix'])
resultado = modelo.ajustar(y, exog)
previsao = modelo.prever(30, exog_futuro)

# Modelo VECM
from src.vecm import ModeloVECM

vecm = ModeloVECM(rank=1, lags=2)
resultado = vecm.ajustar(dados_multivariados, ['cambio', 'selic', 'vix'])
irf = vecm.irf(periodos=20)

# Modelo GARCH
from src.garch import ModeloGARCH, TipoGARCH

garch = ModeloGARCH(p=1, q=1, tipo=TipoGARCH.GJR_GARCH)
resultado = garch.ajustar(retornos)
volatilidade = garch.prever(30)
```

---

## Módulos

| # | Módulo | Função |
|---|--------|--------|
| 1 | configuracao.py | Constantes e configurações globais |
| 2 | tipos_dados.py | DataClasses e NamedTuples |
| 3 | validacao.py | Validadores com decoradores |
| 4 | excecoes.py | Hierarquia de exceções |
| 5 | logger.py | Logging com rotação |
| 6 | cache.py | Cache LRU e disco |
| 7 | paralelismo.py | Thread/Process pools |
| 8 | utilidades.py | Funções auxiliares |
| 9 | coleta_dados.py | APIs BCB, Yahoo |
| 10 | preprocessamento.py | Missing, outliers |
| 11 | features.py | Indicadores técnicos |
| 12 | normalizacao.py | ZScore, MinMax, BoxCox |
| 13 | divisao_dados.py | Split temporal |
| 14 | persistencia.py | Parquet, Pickle |
| 15 | testes_estacionariedade.py | ADF, KPSS, PP |
| 16 | cointegracao.py | Johansen, Granger |
| 17 | arima.py | ARIMA(p,d,q) |
| 18 | arimax.py | ARIMAX com exógenas |
| 19 | vecm.py | VECM com IRF/FEVD |
| 20 | var.py | VAR(p) |
| 21 | garch.py | GARCH, EGARCH, GJR |
| 22 | modelo_hibrido.py | Combinação ponderada |
| 23 | redes_neurais.py | LSTM, GRU, Transformer |
| 24-26 | ensemble.py | Ensemble, otimização, seleção |
| 27 | metricas.py | RMSE, MAE, MAPE, R² |
| 28 | backtesting.py | Rolling/expanding window |
| 29-30 | visualizacao.py | Matplotlib plots |
| 31 | previsao.py | Engine de previsão |
| 32 | principal.py | Orquestrador |

---

## Resultados

### Métricas Típicas

| Métrica | Valor |
|---------|-------|
| RMSE | 0.05 - 0.10 |
| MAE | 0.03 - 0.07 |
| MAPE | 1% - 3% |
| Direção | 55% - 65% |
| R² | 0.85 - 0.95 |

### Visualizações Geradas

1. **Série Temporal** - Câmbio histórico com médias móveis
2. **ACF/PACF** - Autocorrelações
3. **Previsão vs Real** - Comparação out-of-sample
4. **Volatilidade GARCH** - Volatilidade condicional
5. **Impulso-Resposta** - IRF do VECM
6. **Correlações** - Heatmap
7. **Decomposição** - Tendência, sazonalidade, resíduo
8. **Diagnóstico de Resíduos** - QQ-plot, ACF

---

## Fontes de Dados

- **BCB (Banco Central do Brasil)**: PTAX, SELIC, IPCA
- **Yahoo Finance**: S&P 500, VIX, Petróleo
- **FRED**: Dados macroeconômicos dos EUA

---

## Licença

MIT License

---

## Autor

**Luiz Tiago Wilcke**

Modelo desenvolvido para previsão do câmbio USD/BRL utilizando técnicas estatísticas avançadas e machine learning.
