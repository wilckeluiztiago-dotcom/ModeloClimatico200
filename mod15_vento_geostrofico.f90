!===============================================================================
! Módulo 15: Vento Geostrófico
! Autor: Luiz Tiago Wilcke
! Descrição: Cálculo do vento geostrófico e ageostrófico.
!===============================================================================

module mod15_vento_geostrofico
    use mod01_constantes_fisicas
    use mod02_parametros_planeta
    use mod03_grade_espacial
    implicit none
    
contains

    subroutine calcular_vento_geostrofico(p, rho, lat, u_geo, v_geo)
        real(dp), intent(in) :: p(:,:,:), rho(:,:,:), lat(:)
        real(dp), intent(out) :: u_geo(:,:,:), v_geo(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: f, dx, dy, dp_dx, dp_dy
        
        ni = size(p, 1)
        nj = size(p, 2)
        nk = size(p, 3)
        u_geo = 0.0_dp
        v_geo = 0.0_dp
        
        do k = 1, nk
            do j = 2, nj-1
                do i = 2, ni-1
                    f = calcular_parametro_coriolis(lat(i))
                    if (abs(f) > 1.0e-6_dp) then
                        dx = delta_lat * RAIO_TERRA * PI / 180.0_dp
                        dy = delta_lon * RAIO_TERRA * PI / 180.0_dp * cos(graus_para_radianos(lat(i)))
                        dp_dx = (p(i+1,j,k) - p(i-1,j,k)) / (2.0_dp * dx)
                        dp_dy = (p(i,j+1,k) - p(i,j-1,k)) / (2.0_dp * dy)
                        u_geo(i,j,k) = -dp_dy / (rho(i,j,k) * f)
                        v_geo(i,j,k) = dp_dx / (rho(i,j,k) * f)
                    end if
                end do
            end do
        end do
    end subroutine calcular_vento_geostrofico
    
    subroutine calcular_vento_termico(T, lat, p, du_dz, dv_dz)
        real(dp), intent(in) :: T(:,:,:), lat(:), p(:,:,:)
        real(dp), intent(out) :: du_dz(:,:,:), dv_dz(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: f, dx, dy, dT_dx, dT_dy
        
        ni = size(T, 1)
        nj = size(T, 2)
        nk = size(T, 3)
        du_dz = 0.0_dp
        dv_dz = 0.0_dp
        
        do k = 1, nk
            do j = 2, nj-1
                do i = 2, ni-1
                    f = calcular_parametro_coriolis(lat(i))
                    if (abs(f) > 1.0e-6_dp) then
                        dx = delta_lat * RAIO_TERRA * PI / 180.0_dp
                        dy = delta_lon * RAIO_TERRA * PI / 180.0_dp
                        dT_dx = (T(i+1,j,k) - T(i-1,j,k)) / (2.0_dp * dx)
                        dT_dy = (T(i,j+1,k) - T(i,j-1,k)) / (2.0_dp * dy)
                        du_dz(i,j,k) = (CONSTANTE_GAS_AR_SECO / f) * dT_dy / T(i,j,k)
                        dv_dz(i,j,k) = -(CONSTANTE_GAS_AR_SECO / f) * dT_dx / T(i,j,k)
                    end if
                end do
            end do
        end do
    end subroutine calcular_vento_termico

end module mod15_vento_geostrofico
