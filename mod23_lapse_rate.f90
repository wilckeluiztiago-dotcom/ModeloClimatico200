!===============================================================================
! Módulo 23: Lapse Rate (Taxa de Variação Adiabática)
! Autor: Luiz Tiago Wilcke
! Descrição: Taxas de variação adiabáticas seca e úmida.
!===============================================================================

module mod23_lapse_rate
    use mod01_constantes_fisicas
    use mod20_pressao_saturacao
    implicit none
    
contains

    pure function lapse_rate_seco() result(gamma_d)
        real(dp) :: gamma_d
        gamma_d = GRAVIDADE_SUPERFICIE / CP_AR_SECO
    end function lapse_rate_seco
    
    pure function lapse_rate_umido(T, p) result(gamma_s)
        real(dp), intent(in) :: T, p
        real(dp) :: gamma_s, e_s, r_s, epsilon
        real(dp) :: numerador, denominador
        
        epsilon = MASSA_MOLAR_VAPOR_AGUA / MASSA_MOLAR_AR_SECO
        e_s = clausius_clapeyron(T)
        r_s = epsilon * e_s / (p - e_s)
        
        numerador = 1.0_dp + (CALOR_LATENTE_VAPORIZACAO * r_s) / (CONSTANTE_GAS_AR_SECO * T)
        denominador = 1.0_dp + (epsilon * CALOR_LATENTE_VAPORIZACAO**2 * r_s) / &
                      (CP_AR_SECO * CONSTANTE_GAS_AR_SECO * T**2)
        
        gamma_s = (GRAVIDADE_SUPERFICIE / CP_AR_SECO) * numerador / denominador
    end function lapse_rate_umido
    
    pure function lapse_rate_ambiental(T1, T2, z1, z2) result(gamma)
        real(dp), intent(in) :: T1, T2, z1, z2
        real(dp) :: gamma
        gamma = -(T2 - T1) / (z2 - z1)
    end function lapse_rate_ambiental
    
    function atmosfera_condicionalmente_instavel(gamma_amb, gamma_s, gamma_d) result(instavel)
        real(dp), intent(in) :: gamma_amb, gamma_s, gamma_d
        logical :: instavel
        instavel = (gamma_amb > gamma_s) .and. (gamma_amb < gamma_d)
    end function atmosfera_condicionalmente_instavel

end module mod23_lapse_rate
