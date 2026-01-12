!===============================================================================
! Módulo 14: Ondas de Gravidade
! Autor: Luiz Tiago Wilcke
! Descrição: Parametrização de ondas de gravidade atmosféricas.
!===============================================================================

module mod14_ondas_gravidade
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
contains

    function frequencia_brunt_vaisala(T, dT_dz) result(N)
        real(dp), intent(in) :: T, dT_dz
        real(dp) :: N, N2
        real(dp) :: gamma_adiab
        
        gamma_adiab = GRAVIDADE_SUPERFICIE / CP_AR_SECO
        N2 = (GRAVIDADE_SUPERFICIE / T) * (dT_dz + gamma_adiab)
        
        if (N2 > 0.0_dp) then
            N = sqrt(N2)
        else
            N = 0.0_dp
        end if
    end function frequencia_brunt_vaisala
    
    subroutine arrasto_ondas_gravidade(u, v, T, rho, drag_u, drag_v)
        real(dp), intent(in) :: u(:,:,:), v(:,:,:), T(:,:,:), rho(:,:,:)
        real(dp), intent(out) :: drag_u(:,:,:), drag_v(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: N, dT_dz, flux_momento, dz
        
        ni = size(u, 1)
        nj = size(u, 2)
        nk = size(u, 3)
        drag_u = 0.0_dp
        drag_v = 0.0_dp
        
        do k = 2, nk-1
            dz = altitude_atm(k+1) - altitude_atm(k-1)
            do j = 1, nj
                do i = 1, ni
                    dT_dz = (T(i,j,k+1) - T(i,j,k-1)) / dz
                    N = frequencia_brunt_vaisala(T(i,j,k), dT_dz)
                    flux_momento = rho(i,j,1) * N * u(i,j,1)**2 * 0.01_dp
                    if (N > 0.01_dp .and. rho(i,j,k) > 0.0_dp) then
                        drag_u(i,j,k) = -flux_momento / (rho(i,j,k) * 10000.0_dp)
                        drag_v(i,j,k) = -flux_momento * v(i,j,k) / (u(i,j,k) + 0.1_dp) / (rho(i,j,k) * 10000.0_dp)
                    end if
                end do
            end do
        end do
    end subroutine arrasto_ondas_gravidade
    
    function velocidade_fase_onda(N, k_horizontal, m_vertical) result(c)
        real(dp), intent(in) :: N, k_horizontal, m_vertical
        real(dp) :: c
        c = N * k_horizontal / sqrt(k_horizontal**2 + m_vertical**2)
    end function velocidade_fase_onda

end module mod14_ondas_gravidade
