!===============================================================================
! Módulo 47: Correntes Superficiais
! Autor: Luiz Tiago Wilcke
! Descrição: Correntes oceânicas superficiais induzidas pelo vento.
!===============================================================================

module mod47_correntes_superficiais
    use mod01_constantes_fisicas
    use mod02_parametros_planeta
    implicit none
    
contains

    subroutine corrente_ekman(tau_x, tau_y, lat, rho_o, u_ek, v_ek)
        real(dp), intent(in) :: tau_x(:,:), tau_y(:,:), lat(:), rho_o
        real(dp), intent(out) :: u_ek(:,:), v_ek(:,:)
        integer :: i, j
        real(dp) :: f
        
        do j = 1, size(tau_x, 2)
            do i = 1, size(tau_x, 1)
                f = calcular_parametro_coriolis(lat(i))
                if (abs(f) > 1.0e-6_dp) then
                    u_ek(i,j) = tau_y(i,j) / (rho_o * f)
                    v_ek(i,j) = -tau_x(i,j) / (rho_o * f)
                else
                    u_ek(i,j) = 0.0_dp
                    v_ek(i,j) = 0.0_dp
                end if
            end do
        end do
    end subroutine corrente_ekman
    
    subroutine bombeamento_ekman(tau_x, tau_y, lat, dx, dy, rho_o, w_ek)
        real(dp), intent(in) :: tau_x(:,:), tau_y(:,:), lat(:), dx, dy, rho_o
        real(dp), intent(out) :: w_ek(:,:)
        integer :: i, j, ni, nj
        real(dp) :: f, curl_tau
        
        ni = size(tau_x, 1)
        nj = size(tau_x, 2)
        w_ek = 0.0_dp
        
        do j = 2, nj-1
            do i = 2, ni-1
                f = calcular_parametro_coriolis(lat(i))
                curl_tau = (tau_y(i+1,j) - tau_y(i-1,j)) / (2.0_dp * dx) - &
                           (tau_x(i,j+1) - tau_x(i,j-1)) / (2.0_dp * dy)
                if (abs(f) > 1.0e-6_dp) then
                    w_ek(i,j) = curl_tau / (rho_o * f)
                end if
            end do
        end do
    end subroutine bombeamento_ekman
    
    function tensao_vento(u_ar, v_ar, rho_ar, Cd) result(tau)
        real(dp), intent(in) :: u_ar, v_ar, rho_ar, Cd
        real(dp) :: tau(2)
        real(dp) :: V
        V = sqrt(u_ar**2 + v_ar**2)
        tau(1) = rho_ar * Cd * V * u_ar
        tau(2) = rho_ar * Cd * V * v_ar
    end function tensao_vento

end module mod47_correntes_superficiais
