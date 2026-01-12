!===============================================================================
! Módulo 58: Vegetação
! Autor: Luiz Tiago Wilcke
! Descrição: Cobertura vegetal e evapotranspiração.
!===============================================================================

module mod58_vegetacao
    use mod01_constantes_fisicas
    implicit none
    
contains

    function evapotranspiracao_penman_monteith(Rn, G, T, e_s, e_a, r_a, r_s) result(ET)
        real(dp), intent(in) :: Rn, G, T, e_s, e_a, r_a, r_s
        real(dp) :: ET
        real(dp) :: delta, gamma, rho_a, cp_a, lambda
        
        lambda = CALOR_LATENTE_VAPORIZACAO
        delta = 4098.0_dp * e_s / (T - 35.85_dp)**2
        gamma = CP_AR_SECO * 101325.0_dp / (0.622_dp * lambda)
        rho_a = 1.2_dp
        cp_a = CP_AR_SECO
        
        ET = (delta * (Rn - G) + rho_a * cp_a * (e_s - e_a) / r_a) / &
             (delta + gamma * (1.0_dp + r_s / r_a))
        ET = ET / lambda
    end function evapotranspiracao_penman_monteith
    
    function indice_area_foliar(tipo_veg, dia_ano) result(LAI)
        integer, intent(in) :: tipo_veg
        real(dp), intent(in) :: dia_ano
        real(dp) :: LAI
        real(dp) :: LAI_max, fase
        
        select case (tipo_veg)
            case (1)
                LAI_max = 5.0_dp
            case (2)
                LAI_max = 3.0_dp
            case (3)
                LAI_max = 1.0_dp
            case default
                LAI_max = 2.0_dp
        end select
        
        fase = sin(2.0_dp * PI * (dia_ano - 80.0_dp) / 365.0_dp)
        LAI = LAI_max * (0.5_dp + 0.5_dp * max(0.0_dp, fase))
    end function indice_area_foliar
    
    function resistencia_estomatica(LAI, PAR, theta, T) result(r_s)
        real(dp), intent(in) :: LAI, PAR, theta, T
        real(dp) :: r_s
        real(dp) :: r_s_min, f_luz, f_agua, f_temp
        
        r_s_min = 100.0_dp
        f_luz = 1.0_dp / (1.0_dp + PAR / 200.0_dp)
        f_agua = min(1.0_dp, theta / 0.3_dp)
        f_temp = 1.0_dp - 0.01_dp * (T - 298.0_dp)**2
        f_temp = max(0.1_dp, f_temp)
        
        r_s = r_s_min / (LAI * f_luz * f_agua * f_temp + 0.01_dp)
    end function resistencia_estomatica

end module mod58_vegetacao
