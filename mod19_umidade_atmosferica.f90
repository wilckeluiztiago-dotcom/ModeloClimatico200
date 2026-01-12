!===============================================================================
! Módulo 19: Umidade Atmosférica
! Autor: Luiz Tiago Wilcke
! Descrição: Cálculos de umidade específica e relativa.
!===============================================================================

module mod19_umidade_atmosferica
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function umidade_relativa(q, T, p) result(RH)
        real(dp), intent(in) :: q, T, p
        real(dp) :: RH, e, e_s, epsilon
        epsilon = MASSA_MOLAR_VAPOR_AGUA / MASSA_MOLAR_AR_SECO
        e = p * q / (epsilon + q * (1.0_dp - epsilon))
        e_s = pressao_saturacao_agua(T)
        RH = e / e_s
    end function umidade_relativa
    
    pure function pressao_saturacao_agua(T) result(e_s)
        real(dp), intent(in) :: T
        real(dp) :: e_s, T_C
        T_C = T - 273.15_dp
        if (T >= TEMPERATURA_FUSAO) then
            e_s = 611.2_dp * exp(17.67_dp * T_C / (T_C + 243.5_dp))
        else
            e_s = 611.2_dp * exp(21.8745584_dp * T_C / (T_C + 265.5_dp))
        end if
    end function pressao_saturacao_agua
    
    pure function umidade_saturacao(T, p) result(q_s)
        real(dp), intent(in) :: T, p
        real(dp) :: q_s, e_s, epsilon
        epsilon = MASSA_MOLAR_VAPOR_AGUA / MASSA_MOLAR_AR_SECO
        e_s = pressao_saturacao_agua(T)
        q_s = epsilon * e_s / (p - e_s * (1.0_dp - epsilon))
    end function umidade_saturacao
    
    pure function temperatura_ponto_orvalho(T, RH) result(T_d)
        real(dp), intent(in) :: T, RH
        real(dp) :: T_d, T_C, gamma
        T_C = T - 273.15_dp
        gamma = log(RH) + 17.67_dp * T_C / (T_C + 243.5_dp)
        T_d = 243.5_dp * gamma / (17.67_dp - gamma) + 273.15_dp
    end function temperatura_ponto_orvalho

end module mod19_umidade_atmosferica
