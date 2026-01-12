!===============================================================================
! Módulo 20: Pressão de Saturação (Clausius-Clapeyron)
! Autor: Luiz Tiago Wilcke
! Descrição: Equação de Clausius-Clapeyron para pressão de saturação.
!===============================================================================

module mod20_pressao_saturacao
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function clausius_clapeyron(T) result(e_s)
        real(dp), intent(in) :: T
        real(dp) :: e_s
        e_s = PRESSAO_TRIPLO * exp((CALOR_LATENTE_VAPORIZACAO / CONSTANTE_GAS_VAPOR) * &
              (1.0_dp / TEMPERATURA_TRIPLO - 1.0_dp / T))
    end function clausius_clapeyron
    
    pure function derivada_pressao_saturacao(T) result(de_dT)
        real(dp), intent(in) :: T
        real(dp) :: de_dT, e_s
        e_s = clausius_clapeyron(T)
        de_dT = e_s * CALOR_LATENTE_VAPORIZACAO / (CONSTANTE_GAS_VAPOR * T**2)
    end function derivada_pressao_saturacao
    
    pure function pressao_saturacao_gelo(T) result(e_si)
        real(dp), intent(in) :: T
        real(dp) :: e_si
        e_si = PRESSAO_TRIPLO * exp((CALOR_LATENTE_SUBLIMACAO / CONSTANTE_GAS_VAPOR) * &
              (1.0_dp / TEMPERATURA_TRIPLO - 1.0_dp / T))
    end function pressao_saturacao_gelo
    
    pure function temperatura_lcl(T, p, q) result(T_lcl)
        real(dp), intent(in) :: T, p, q
        real(dp) :: T_lcl, RH, T_d
        real(dp) :: epsilon
        epsilon = MASSA_MOLAR_VAPOR_AGUA / MASSA_MOLAR_AR_SECO
        RH = q * p / (epsilon * clausius_clapeyron(T))
        T_d = 1.0_dp / (1.0_dp/TEMPERATURA_TRIPLO - (CONSTANTE_GAS_VAPOR/CALOR_LATENTE_VAPORIZACAO) * log(RH))
        T_lcl = T - (T - T_d) / (1.0_dp + (CALOR_LATENTE_VAPORIZACAO * epsilon * clausius_clapeyron(T)) / &
                (CP_AR_SECO * p))
    end function temperatura_lcl

end module mod20_pressao_saturacao
