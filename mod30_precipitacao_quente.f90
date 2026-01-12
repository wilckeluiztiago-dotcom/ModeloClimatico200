!===============================================================================
! Módulo 30: Precipitação Quente
! Autor: Luiz Tiago Wilcke
! Descrição: Precipitação de nuvens quentes (autoconversão).
!===============================================================================

module mod30_precipitacao_quente
    use mod01_constantes_fisicas
    implicit none
    
contains

    subroutine autoconversao_kessler(ql, qr, dql, dqr, dt)
        real(dp), intent(in) :: ql, qr, dt
        real(dp), intent(out) :: dql, dqr
        real(dp) :: k1, ql_crit
        
        k1 = 0.001_dp
        ql_crit = 0.5e-3_dp
        
        if (ql > ql_crit) then
            dqr = k1 * (ql - ql_crit) * dt
            dql = -dqr
        else
            dqr = 0.0_dp
            dql = 0.0_dp
        end if
    end subroutine autoconversao_kessler
    
    subroutine acrecao_chuva(ql, qr, dql, dqr, dt)
        real(dp), intent(in) :: ql, qr, dt
        real(dp), intent(out) :: dql, dqr
        real(dp) :: k2
        
        k2 = 2.2_dp
        dqr = k2 * ql * qr**0.875_dp * dt
        dql = -dqr
    end subroutine acrecao_chuva
    
    function taxa_precipitacao(qr, rho) result(P)
        real(dp), intent(in) :: qr, rho
        real(dp) :: P
        real(dp) :: v_t
        v_t = 5.0_dp * qr**0.125_dp
        P = rho * qr * v_t
    end function taxa_precipitacao
    
    subroutine sedimentacao_chuva(qr, rho, dz, dt, qr_sed)
        real(dp), intent(in) :: qr(:), rho(:), dz, dt
        real(dp), intent(out) :: qr_sed(:)
        integer :: k, nk
        real(dp) :: v_t, flux_in, flux_out
        
        nk = size(qr)
        qr_sed = qr
        
        do k = nk, 2, -1
            v_t = 5.0_dp * max(qr(k), 0.0_dp)**0.125_dp
            flux_out = rho(k) * qr(k) * v_t * dt / dz
            qr_sed(k) = qr_sed(k) - flux_out / rho(k)
            qr_sed(k-1) = qr_sed(k-1) + flux_out / rho(k-1)
        end do
    end subroutine sedimentacao_chuva

end module mod30_precipitacao_quente
