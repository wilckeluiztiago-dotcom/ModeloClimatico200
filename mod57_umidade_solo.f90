!===============================================================================
! Módulo 57: Umidade do Solo
! Autor: Luiz Tiago Wilcke
! Descrição: Balanço hídrico e umidade do solo.
!===============================================================================

module mod57_umidade_solo
    use mod01_constantes_fisicas
    implicit none
    
    real(dp), parameter :: POROSIDADE_SOLO = 0.4_dp
    real(dp), parameter :: CONDUTIVIDADE_HIDRAULICA = 1.0e-6_dp
    
contains

    subroutine balanco_hidrico_solo(theta, P, E, R, dz, dt, dtheta)
        real(dp), intent(in) :: theta(:), P, E, R, dt
        real(dp), intent(in) :: dz(:)
        real(dp), intent(out) :: dtheta(:)
        integer :: k, nk
        real(dp) :: infiltracao, drenagem
        
        nk = size(theta)
        dtheta = 0.0_dp
        
        infiltracao = min(P - R, CONDUTIVIDADE_HIDRAULICA * 3600.0_dp)
        dtheta(1) = (infiltracao - E) / dz(1)
        
        do k = 2, nk
            drenagem = CONDUTIVIDADE_HIDRAULICA * (theta(k-1) / POROSIDADE_SOLO)**3
            dtheta(k) = drenagem / dz(k)
            dtheta(k-1) = dtheta(k-1) - drenagem / dz(k-1)
        end do
    end subroutine balanco_hidrico_solo
    
    function umidade_saturacao_solo(porosidade) result(theta_sat)
        real(dp), intent(in) :: porosidade
        real(dp) :: theta_sat
        theta_sat = porosidade
    end function umidade_saturacao_solo
    
    function estresse_hidrico(theta, theta_wp, theta_fc) result(beta)
        real(dp), intent(in) :: theta, theta_wp, theta_fc
        real(dp) :: beta
        if (theta <= theta_wp) then
            beta = 0.0_dp
        else if (theta >= theta_fc) then
            beta = 1.0_dp
        else
            beta = (theta - theta_wp) / (theta_fc - theta_wp)
        end if
    end function estresse_hidrico

end module mod57_umidade_solo
