"""
Módulo 90: Main Simulação
Autor: Luiz Tiago Wilcke
Descrição: Script principal de execução do modelo climático.
"""

import numpy as np
import time
from datetime import datetime

from mod81_interface_fortran import InterfaceFortran
from mod82_controle_simulacao import ControleSimulacao, criar_simulacao_anual
from mod83_gerenciador_dados import GerenciadorDados
from mod84_entrada_saida import EntradaSaida
from mod85_configuracao import GerenciadorConfiguracao
from mod86_logger import LoggerModelo
from mod87_validacao import ValidadorDados
from mod88_diagnosticos import Diagnosticos
from mod89_estatisticas import EstatisticasClimaticas

class ModeloClimatico:
    """Modelo climático principal."""
    
    def __init__(self, config_arquivo=None):
        self.config_manager = GerenciadorConfiguracao(config_arquivo)
        self.config = self.config_manager.obter()
        
        self.logger = LoggerModelo()
        self.io = EntradaSaida()
        self.validador = ValidadorDados()
        
        self.interface_fortran = InterfaceFortran()
        self.grade = self.interface_fortran.inicializar_grade(
            self.config.grade.num_lat,
            self.config.grade.num_lon,
            self.config.grade.num_niveis_atm
        )
        
        self.dados = GerenciadorDados(self.grade)
        self.diagnosticos = Diagnosticos(self.grade)
        
        self.simulacao = criar_simulacao_anual()
        self.resultados = []
    
    def inicializar(self):
        """Inicializa o modelo com condições iniciais."""
        self.logger.info("Inicializando modelo climático...")
        
        estado_inicial = self.interface_fortran.criar_estado_inicial(self.grade)
        self.dados.inicializar_estado(estado_inicial)
        
        self.logger.log_inicio_simulacao(self.config)
    
    def passo_tempo(self):
        """Executa um passo de tempo."""
        estado = self.dados.estado_atual
        
        # Física simplificada (sem Fortran compilado)
        dT = -0.001 * (estado.temperatura - 280.0)
        estado.temperatura = estado.temperatura + dT * self.config.tempo.passo_tempo_segundos
        
        # Validação
        valido, erros = self.validador.validar_estado_completo(estado)
        if not valido:
            for erro in erros:
                self.logger.error(erro)
    
    def executar(self, passos=None):
        """Executa a simulação."""
        self.inicializar()
        tempo_inicio = time.time()
        
        passos_max = passos or self.simulacao.passos_totais
        
        for passo in range(passos_max):
            self.passo_tempo()
            
            if passo % 24 == 0:
                T_media = np.mean(self.dados.estado_atual.temperatura[:, :, 0])
                self.logger.log_passo(passo, self.simulacao.tempo_atual, T_media)
                self.dados.salvar_snapshot(passo)
                self.resultados.append({
                    'passo': passo,
                    'T_media': T_media
                })
            
            self.simulacao.avancar()
        
        tempo_execucao = time.time() - tempo_inicio
        self.logger.log_fim_simulacao(tempo_execucao)
        
        return self.resultados


def main():
    """Função principal."""
    print("=" * 60)
    print("MODELO CLIMÁTICO TERRESTRE")
    print("Autor: Luiz Tiago Wilcke")
    print("=" * 60)
    
    modelo = ModeloClimatico()
    resultados = modelo.executar(passos=100)
    
    print(f"\nSimulação concluída com {len(resultados)} snapshots salvos.")
    
    return resultados


if __name__ == "__main__":
    main()
