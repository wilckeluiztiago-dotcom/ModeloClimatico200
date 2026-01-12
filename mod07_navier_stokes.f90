!===============================================================================
! Módulo 07: Equações de Navier-Stokes
! Autor: Luiz Tiago Wilcke
! Descrição: Implementação das equações de Navier-Stokes 3D para fluidos.
!===============================================================================

module mod07_navier_stokes
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
    real(dp), parameter :: VISCOSIDADE_CINEMATICA = 1.5e-5_dp
    
contains

    subroutine navier_stokes_3d(u, v, w, p, rho, nu, du, dv, dw)
        real(dp), intent(in) :: u(:,:,:), v(:,:,:), w(:,:,:)
        real(dp), intent(in) :: p(:,:,:), rho(:,:,:), nu
        real(dp), intent(out) :: du(:,:,:), dv(:,:,:), dw(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: adv_x, adv_y, adv_z, visc, grad_p
        real(dp) :: dx, dy, dz
        
        ni = size(u, 1)
        nj = size(u, 2)
        nk = size(u, 3)
        
        dx = delta_lat * RAIO_TERRA * PI / 180.0_dp
        dy = delta_lon * RAIO_TERRA * PI / 180.0_dp
        
        du = 0.0_dp
        dv = 0.0_dp
        dw = 0.0_dp
        
        do k = 2, nk-1
            dz = altitude_atm(k) - altitude_atm(k-1)
            do j = 2, nj-1
                do i = 2, ni-1
                    adv_x = u(i,j,k) * (u(i+1,j,k) - u(i-1,j,k)) / (2.0_dp * dx)
                    adv_y = v(i,j,k) * (u(i,j+1,k) - u(i,j-1,k)) / (2.0_dp * dy)
                    adv_z = w(i,j,k) * (u(i,j,k+1) - u(i,j,k-1)) / (2.0_dp * dz)
                    grad_p = (p(i+1,j,k) - p(i-1,j,k)) / (2.0_dp * dx * rho(i,j,k))
                    visc = nu * ((u(i+1,j,k) - 2.0_dp*u(i,j,k) + u(i-1,j,k)) / dx**2 + &
                                 (u(i,j+1,k) - 2.0_dp*u(i,j,k) + u(i,j-1,k)) / dy**2 + &
                                 (u(i,j,k+1) - 2.0_dp*u(i,j,k) + u(i,j,k-1)) / dz**2)
                    du(i,j,k) = -adv_x - adv_y - adv_z - grad_p + visc
                    
                    adv_x = u(i,j,k) * (v(i+1,j,k) - v(i-1,j,k)) / (2.0_dp * dx)
                    adv_y = v(i,j,k) * (v(i,j+1,k) - v(i,j-1,k)) / (2.0_dp * dy)
                    adv_z = w(i,j,k) * (v(i,j,k+1) - v(i,j,k-1)) / (2.0_dp * dz)
                    grad_p = (p(i,j+1,k) - p(i,j-1,k)) / (2.0_dp * dy * rho(i,j,k))
                    visc = nu * ((v(i+1,j,k) - 2.0_dp*v(i,j,k) + v(i-1,j,k)) / dx**2 + &
                                 (v(i,j+1,k) - 2.0_dp*v(i,j,k) + v(i,j-1,k)) / dy**2 + &
                                 (v(i,j,k+1) - 2.0_dp*v(i,j,k) + v(i,j,k-1)) / dz**2)
                    dv(i,j,k) = -adv_x - adv_y - adv_z - grad_p + visc
                    
                    adv_x = u(i,j,k) * (w(i+1,j,k) - w(i-1,j,k)) / (2.0_dp * dx)
                    adv_y = v(i,j,k) * (w(i,j+1,k) - w(i,j-1,k)) / (2.0_dp * dy)
                    adv_z = w(i,j,k) * (w(i,j,k+1) - w(i,j,k-1)) / (2.0_dp * dz)
                    grad_p = (p(i,j,k+1) - p(i,j,k-1)) / (2.0_dp * dz * rho(i,j,k))
                    visc = nu * ((w(i+1,j,k) - 2.0_dp*w(i,j,k) + w(i-1,j,k)) / dx**2 + &
                                 (w(i,j+1,k) - 2.0_dp*w(i,j,k) + w(i,j-1,k)) / dy**2 + &
                                 (w(i,j,k+1) - 2.0_dp*w(i,j,k) + w(i,j,k-1)) / dz**2)
                    dw(i,j,k) = -adv_x - adv_y - adv_z - grad_p + visc - GRAVIDADE_SUPERFICIE
                end do
            end do
        end do
    end subroutine navier_stokes_3d
    
    pure function calcular_numero_reynolds(velocidade, comprimento, viscosidade) result(Re)
        real(dp), intent(in) :: velocidade, comprimento, viscosidade
        real(dp) :: Re
        Re = velocidade * comprimento / viscosidade
    end function calcular_numero_reynolds

end module mod07_navier_stokes
