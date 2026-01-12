!===============================================================================
! Módulo 66: Ciclo do Carbono
! Autor: Luiz Tiago Wilcke
! Descrição: Ciclo global do carbono.
!===============================================================================

module mod66_ciclo_carbono
    use mod01_constantes_fisicas
    implicit none
    
    real(dp), parameter :: CARBONO_ATMOSFERA = 850.0e15_dp
    real(dp), parameter :: CARBONO_OCEANO = 38000.0e15_dp
    real(dp), parameter :: CARBONO_BIOSFERA = 2000.0e15_dp
    
contains

    function fluxo_ar_oceano(pCO2_ar, pCO2_oceano, k_gas, solubilidade) result(F)
        real(dp), intent(in) :: pCO2_ar, pCO2_oceano, k_gas, solubilidade
        real(dp) :: F
        F = k_gas * solubilidade * (pCO2_ar - pCO2_oceano)
    end function fluxo_ar_oceano
    
    function fotossintese(PAR, LAI, T, CO2, beta_F) result(GPP)
        real(dp), intent(in) :: PAR, LAI, T, CO2, beta_F
        real(dp) :: GPP
        real(dp) :: f_luz, f_temp, f_CO2
        
        f_luz = PAR / (PAR + 200.0_dp)
        f_temp = exp(-0.05_dp * (T - 298.0_dp)**2)
        f_CO2 = (CO2 - 50.0_dp) / (CO2 + 200.0_dp)
        
        GPP = beta_F * f_luz * f_temp * f_CO2 * LAI
    end function fotossintese
    
    function respiracao_ecosistema(T, C_solo, Q10) result(R_eco)
        real(dp), intent(in) :: T, C_solo, Q10
        real(dp) :: R_eco
        real(dp) :: T_ref
        
        T_ref = 283.15_dp
        R_eco = 1.0e-3_dp * C_solo * Q10**((T - T_ref) / 10.0_dp)
    end function respiracao_ecosistema
    
    function concentracao_co2_ppm(massa_C_atm) result(ppm)
        real(dp), intent(in) :: massa_C_atm
        real(dp) :: ppm
        ppm = massa_C_atm / (2.13e15_dp)
    end function concentracao_co2_ppm

end module mod66_ciclo_carbono
