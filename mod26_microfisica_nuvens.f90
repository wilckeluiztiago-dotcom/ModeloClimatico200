!===============================================================================
! Módulo 26: Microfísica de Nuvens
! Autor: Luiz Tiago Wilcke
! Descrição: Microfísica de nuvens quentes (gotículas).
!===============================================================================

module mod26_microfisica_nuvens
    use mod01_constantes_fisicas
    implicit none
    
    real(dp), parameter :: RAIO_GOTA_NUVEM = 10.0e-6_dp
    real(dp), parameter :: RAIO_GOTA_CHUVA = 1000.0e-6_dp
    
contains

    pure function massa_gota(raio) result(m)
        real(dp), intent(in) :: raio
        real(dp) :: m
        m = (4.0_dp / 3.0_dp) * PI * raio**3 * DENSIDADE_AGUA
    end function massa_gota
    
    pure function velocidade_terminal_gota(raio, rho_ar) result(v_t)
        real(dp), intent(in) :: raio, rho_ar
        real(dp) :: v_t
        if (raio < 40.0e-6_dp) then
            v_t = 1.19e8_dp * raio**2
        else if (raio < 600.0e-6_dp) then
            v_t = 8.0e3_dp * raio
        else
            v_t = 2.01e5_dp * sqrt(raio)
        end if
    end function velocidade_terminal_gota
    
    subroutine condensacao_nuvem(T, q, ql, p, dt, dT_cond, dq, dql)
        real(dp), intent(in) :: T, q, ql, p, dt
        real(dp), intent(out) :: dT_cond, dq, dql
        real(dp) :: q_sat, excesso, tau_cond
        
        tau_cond = 600.0_dp
        q_sat = 0.622_dp * 611.2_dp * exp(17.67_dp * (T - 273.15_dp) / (T - 29.65_dp)) / p
        excesso = q - q_sat
        
        if (excesso > 0.0_dp) then
            dql = excesso * (1.0_dp - exp(-dt / tau_cond))
            dq = -dql
            dT_cond = CALOR_LATENTE_VAPORIZACAO * dql / CP_AR_SECO
        else if (ql > 0.0_dp .and. excesso < 0.0_dp) then
            dql = -min(ql, -excesso) * (1.0_dp - exp(-dt / tau_cond))
            dq = -dql
            dT_cond = CALOR_LATENTE_VAPORIZACAO * dql / CP_AR_SECO
        else
            dql = 0.0_dp
            dq = 0.0_dp
            dT_cond = 0.0_dp
        end if
    end subroutine condensacao_nuvem

end module mod26_microfisica_nuvens
