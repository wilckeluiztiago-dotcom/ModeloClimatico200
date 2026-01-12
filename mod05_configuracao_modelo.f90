!===============================================================================
! Módulo 05: Configuração do Modelo
! Autor: Luiz Tiago Wilcke
! Descrição: Parâmetros de controle e configuração da simulação climática.
!===============================================================================

module mod05_configuracao_modelo
    use mod01_constantes_fisicas
    implicit none
    
    real(dp) :: passo_tempo = 3600.0_dp
    real(dp) :: tempo_simulacao_total = 31536000.0_dp
    real(dp) :: tempo_atual = 0.0_dp
    integer :: passo_atual = 0
    integer :: intervalo_saida = 24
    integer :: ano_inicial = 2024
    integer :: mes_inicial = 1
    integer :: dia_inicial = 1
    logical :: usar_ciclo_diurno = .true.
    logical :: usar_ciclo_sazonal = .true.
    logical :: incluir_oceano = .true.
    logical :: incluir_gelo = .true.
    real(dp) :: co2_concentracao = 420.0_dp
    real(dp) :: ch4_concentracao = 1900.0_dp
    
contains

    subroutine configurar_simulacao(dt, tempo_total, ano, mes, dia)
        real(dp), intent(in) :: dt, tempo_total
        integer, intent(in) :: ano, mes, dia
        passo_tempo = dt
        tempo_simulacao_total = tempo_total
        ano_inicial = ano
        mes_inicial = mes
        dia_inicial = dia
    end subroutine configurar_simulacao
    
    subroutine avancar_tempo()
        tempo_atual = tempo_atual + passo_tempo
        passo_atual = passo_atual + 1
    end subroutine avancar_tempo
    
    function simulacao_completa() result(completa)
        logical :: completa
        completa = tempo_atual >= tempo_simulacao_total
    end function simulacao_completa
    
    function dia_do_ano_atual() result(dia)
        real(dp) :: dia
        dia = mod(tempo_atual / 86400.0_dp, 365.25_dp) + 1.0_dp
    end function dia_do_ano_atual

end module mod05_configuracao_modelo
