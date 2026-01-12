# Makefile para o Modelo Climático
# Autor: Luiz Tiago Wilcke

FC = gfortran
FFLAGS = -O2 -Wall -fcheck=all

# Módulos em ordem de dependência
MODS = mod01_constantes_fisicas.o \
       mod02_parametros_planeta.o \
       mod03_grade_espacial.o \
       mod04_condicoes_iniciais.o \
       mod05_configuracao_modelo.o \
       mod06_equacoes_primitivas.o \
       mod07_navier_stokes.o \
       mod08_adveccao_atmosferica.o \
       mod09_difusao_turbulenta.o \
       mod10_forca_coriolis.o \
       mod11_gradiente_pressao.o \
       mod12_camada_limite.o \
       mod13_conveccao_profunda.o \
       mod14_ondas_gravidade.o \
       mod15_vento_geostrofico.o \
       mod16_equacao_estado.o \
       mod17_energia_interna.o \
       mod18_entalpia_atmosfera.o \
       mod19_umidade_atmosferica.o \
       mod20_pressao_saturacao.o \
       mod21_temperatura_potencial.o \
       mod22_estabilidade_atmosferica.o \
       mod23_lapse_rate.o \
       mod24_troca_calor_latente.o \
       mod25_perfil_vertical.o \
       mod26_microfisica_nuvens.o \
       mod27_nucleacao_gotas.o \
       mod28_crescimento_gotas.o \
       mod29_formacao_gelo.o \
       mod30_precipitacao_quente.o \
       mod31_precipitacao_mista.o \
       mod32_evaporacao_chuva.o \
       mod33_fracao_nuvens.o \
       mod34_tipos_nuvens.o \
       mod35_aerossois_ccn.o \
       mod36_radiacao_solar.o \
       mod37_espectro_solar.o \
       mod38_absorcao_atmosferica.o \
       mod39_espalhamento_rayleigh.o \
       mod40_espalhamento_mie.o \
       mod41_radiacao_onda_longa.o \
       mod42_efeito_estufa.o \
       mod43_albedo_superficie.o \
       mod44_balanco_radiativo.o \
       mod45_transferencia_dois_fluxos.o \
       mod46_circulacao_termohalina.o \
       mod47_correntes_superficiais.o \
       mod48_mistura_vertical_oceano.o \
       mod49_difusao_oceano.o \
       mod50_upwelling_downwelling.o \
       mod51_temperatura_oceano.o \
       mod52_salinidade.o \
       mod53_densidade_oceano.o \
       mod54_ondas_oceanicas.o \
       mod55_mares.o \
       mod56_solo_temperatura.o \
       mod57_umidade_solo.o \
       mod58_vegetacao.o \
       mod59_topografia.o \
       mod60_uso_solo.o \
       mod61_gelo_marinho.o \
       mod62_mantos_gelo.o \
       mod63_geleiras.o \
       mod64_permafrost.o \
       mod65_neve.o \
       mod66_ciclo_carbono.o \
       mod67_co2_atmosferico.o \
       mod68_metano.o \
       mod69_ozonio.o \
       mod70_nitrogenio.o \
       mod71_runge_kutta.o \
       mod72_diferencas_finitas.o \
       mod73_espectral.o \
       mod74_semi_lagrangiano.o \
       mod75_interpolacao.o \
       mod76_filtros_numericos.o \
       mod77_condicoes_contorno.o \
       mod78_acoplamento_modulos.o \
       mod79_paralelizacao.o \
       mod80_solver_linear.o

all: libclima.a

libclima.a: $(MODS)
	ar rcs $@ $^

%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

clean:
	rm -f *.o *.mod libclima.a

.PHONY: all clean
