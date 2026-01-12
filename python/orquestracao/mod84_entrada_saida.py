"""
Módulo 84: Entrada e Saída
Autor: Luiz Tiago Wilcke
Descrição: Operações de I/O para arquivos de dados.
"""

import numpy as np
import json
import os
from datetime import datetime

class EntradaSaida:
    """Gerencia entrada e saída de dados do modelo."""
    
    def __init__(self, diretorio_base='./dados'):
        self.diretorio_base = diretorio_base
        self.diretorio_saida = os.path.join(diretorio_base, 'saida')
        self.diretorio_entrada = os.path.join(diretorio_base, 'entrada')
        self._criar_diretorios()
    
    def _criar_diretorios(self):
        """Cria diretórios necessários."""
        for d in [self.diretorio_base, self.diretorio_saida, self.diretorio_entrada]:
            os.makedirs(d, exist_ok=True)
    
    def salvar_campo_binario(self, campo, nome, passo):
        """Salva campo em formato binário."""
        arquivo = os.path.join(self.diretorio_saida, f"{nome}_{passo:06d}.npy")
        np.save(arquivo, campo)
        return arquivo
    
    def carregar_campo_binario(self, nome, passo):
        """Carrega campo de arquivo binário."""
        arquivo = os.path.join(self.diretorio_saida, f"{nome}_{passo:06d}.npy")
        return np.load(arquivo)
    
    def salvar_estado_json(self, estado, nome_arquivo):
        """Salva metadados do estado em JSON."""
        arquivo = os.path.join(self.diretorio_saida, nome_arquivo)
        dados = {
            'timestamp': datetime.now().isoformat(),
            'forma_temperatura': list(estado.temperatura.shape),
            'temperatura_media': float(np.mean(estado.temperatura)),
            'temperatura_min': float(np.min(estado.temperatura)),
            'temperatura_max': float(np.max(estado.temperatura))
        }
        with open(arquivo, 'w') as f:
            json.dump(dados, f, indent=2)
    
    def salvar_serie_temporal(self, tempos, valores, nome):
        """Salva série temporal."""
        arquivo = os.path.join(self.diretorio_saida, f"{nome}_serie.npz")
        np.savez(arquivo, tempos=tempos, valores=valores)
    
    def carregar_serie_temporal(self, nome):
        """Carrega série temporal."""
        arquivo = os.path.join(self.diretorio_saida, f"{nome}_serie.npz")
        dados = np.load(arquivo)
        return dados['tempos'], dados['valores']
    
    def listar_arquivos_saida(self, padrao='*.npy'):
        """Lista arquivos de saída."""
        import glob
        return glob.glob(os.path.join(self.diretorio_saida, padrao))
