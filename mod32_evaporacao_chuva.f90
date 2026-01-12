!===============================================================================
! Módulo 32: Evaporação de Chuva
! Autor: Luiz Tiago Wilcke
! Descrição: Evaporação de precipitação abaixo da base da nuvem.
!===============================================================================

module mod32_evaporacao_chuva
    use mod01_constantes_fisicas
    implicit none
    
contains

    subroutine evaporacao_precipitacao(qr, T, q, p, dt, dqr, dq, dT_out)
        real(dp), intent(in) :: qr, T, q, p, dt
        real(dp), intent(out) :: dqr, dq, dT_out
        real(dp) :: q_sat, deficit, taxa_evap, C_evap
        
        q_sat = 0.622_dp * 611.2_dp * exp(17.67_dp * (T - 273.15_dp) / (T - 29.65_dp)) / p
        deficit = q_sat - q
        
        if (deficit > 0.0_dp .and. qr > 0.0_dp) then
            C_evap = 5.0e-4_dp
            taxa_evap = C_evap * deficit * qr**0.65_dp
            dqr = -taxa_evap * dt
            dqr = max(dqr, -qr)
            dq = -dqr
            dT_out = CALOR_LATENTE_VAPORIZACAO * dqr / CP_AR_SECO
        else
            dqr = 0.0_dp
            dq = 0.0_dp
            dT_out = 0.0_dp
        end if
    end subroutine evaporacao_precipitacao
    
    pure function umidade_relativa_critica_evap(T) result(RH_crit)
        real(dp), intent(in) :: T
        real(dp) :: RH_crit
        RH_crit = 0.9_dp - 0.002_dp * (T - 273.15_dp)
        RH_crit = max(0.5_dp, min(0.95_dp, RH_crit))
    end function umidade_relativa_critica_evap

end module mod32_evaporacao_chuva
