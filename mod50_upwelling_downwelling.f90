!===============================================================================
! Módulo 50: Ressurgência e Subsidência
! Autor: Luiz Tiago Wilcke
! Descrição: Upwelling e downwelling oceânico.
!===============================================================================

module mod50_upwelling_downwelling
    use mod01_constantes_fisicas
    implicit none
    
contains

    subroutine calcular_upwelling_costeiro(tau_y, lat, dx, rho_o, w_up)
        real(dp), intent(in) :: tau_y(:,:), lat(:), dx, rho_o
        real(dp), intent(out) :: w_up(:,:)
        integer :: i, j
        real(dp) :: f, dtau_dx
        
        do j = 1, size(tau_y, 2)
            do i = 2, size(tau_y, 1)-1
                f = 2.0_dp * 7.292e-5_dp * sin(lat(i) * 3.14159_dp / 180.0_dp)
                dtau_dx = (tau_y(i+1,j) - tau_y(i-1,j)) / (2.0_dp * dx)
                if (abs(f) > 1.0e-6_dp) then
                    w_up(i,j) = dtau_dx / (rho_o * f)
                else
                    w_up(i,j) = 0.0_dp
                end if
            end do
        end do
    end subroutine calcular_upwelling_costeiro
    
    subroutine efeito_upwelling_temperatura(w_up, T, dz, dt_step, dT_out)
        real(dp), intent(in) :: w_up(:,:), T(:,:,:), dz(:), dt_step
        real(dp), intent(out) :: dT_out(:,:,:)
        integer :: i, j, k, ni, nj, nk
        
        ni = size(T, 1)
        nj = size(T, 2)
        nk = size(T, 3)
        dT_out = 0.0_dp
        
        do k = 2, nk
            do j = 1, nj
                do i = 1, ni
                    if (w_up(i,j) > 0.0_dp) then
                        dT_out(i,j,k) = -w_up(i,j) * (T(i,j,k) - T(i,j,k-1)) / dz(k)
                    else
                        if (k < nk) then
                            dT_out(i,j,k) = -w_up(i,j) * (T(i,j,k+1) - T(i,j,k)) / dz(k)
                        end if
                    end if
                end do
            end do
        end do
    end subroutine efeito_upwelling_temperatura

end module mod50_upwelling_downwelling
