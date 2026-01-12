!===============================================================================
! Módulo 08: Advecção Atmosférica
! Autor: Luiz Tiago Wilcke
! Descrição: Transporte advectivo de propriedades atmosféricas.
!===============================================================================

module mod08_adveccao_atmosferica
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
contains

    subroutine adveccao_escalar(campo, u, v, w, tendencia)
        real(dp), intent(in) :: campo(:,:,:), u(:,:,:), v(:,:,:), w(:,:,:)
        real(dp), intent(out) :: tendencia(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: dx, dy, dz, adv_x, adv_y, adv_z
        
        ni = size(campo, 1)
        nj = size(campo, 2)
        nk = size(campo, 3)
        tendencia = 0.0_dp
        
        do k = 2, nk-1
            dz = altitude_atm(k+1) - altitude_atm(k-1)
            do j = 2, nj-1
                do i = 2, ni-1
                    dx = delta_lat * RAIO_TERRA * PI / 180.0_dp
                    dy = delta_lon * RAIO_TERRA * PI / 180.0_dp * cos(graus_para_radianos(latitude(i)))
                    adv_x = -u(i,j,k) * (campo(i+1,j,k) - campo(i-1,j,k)) / (2.0_dp * dx)
                    adv_y = -v(i,j,k) * (campo(i,j+1,k) - campo(i,j-1,k)) / (2.0_dp * dy)
                    adv_z = -w(i,j,k) * (campo(i,j,k+1) - campo(i,j,k-1)) / dz
                    tendencia(i,j,k) = adv_x + adv_y + adv_z
                end do
            end do
        end do
    end subroutine adveccao_escalar
    
    subroutine adveccao_upwind(campo, u, v, tendencia)
        real(dp), intent(in) :: campo(:,:,:), u(:,:,:), v(:,:,:)
        real(dp), intent(out) :: tendencia(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: dx, dy, flux_x, flux_y
        
        ni = size(campo, 1)
        nj = size(campo, 2)
        nk = size(campo, 3)
        tendencia = 0.0_dp
        
        do k = 1, nk
            do j = 2, nj-1
                do i = 2, ni-1
                    dx = delta_lat * RAIO_TERRA * PI / 180.0_dp
                    dy = delta_lon * RAIO_TERRA * PI / 180.0_dp
                    if (u(i,j,k) > 0) then
                        flux_x = u(i,j,k) * (campo(i,j,k) - campo(i-1,j,k)) / dx
                    else
                        flux_x = u(i,j,k) * (campo(i+1,j,k) - campo(i,j,k)) / dx
                    end if
                    if (v(i,j,k) > 0) then
                        flux_y = v(i,j,k) * (campo(i,j,k) - campo(i,j-1,k)) / dy
                    else
                        flux_y = v(i,j,k) * (campo(i,j+1,k) - campo(i,j,k)) / dy
                    end if
                    tendencia(i,j,k) = -flux_x - flux_y
                end do
            end do
        end do
    end subroutine adveccao_upwind

end module mod08_adveccao_atmosferica
