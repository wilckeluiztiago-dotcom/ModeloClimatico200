!===============================================================================
! Módulo 06: Equações Primitivas da Atmosfera
! Autor: Luiz Tiago Wilcke
! Descrição: Implementa as equações primitivas para dinâmica atmosférica.
!===============================================================================

module mod06_equacoes_primitivas
    use mod01_constantes_fisicas
    use mod02_parametros_planeta
    use mod03_grade_espacial
    implicit none
    
contains

    subroutine calcular_tendencia_vento_u(u, v, T, p, du_dt)
        real(dp), intent(in) :: u(:,:,:), v(:,:,:), T(:,:,:), p(:,:)
        real(dp), intent(out) :: du_dt(:,:,:)
        integer :: i, j, k
        real(dp) :: f, dp_dx, adv_u, rho
        
        do k = 1, NUM_NIVEIS_ATM
            do j = 2, NUM_LON-1
                do i = 2, NUM_LAT-1
                    f = calcular_parametro_coriolis(latitude(i))
                    rho = nivel_atm(k) / (CONSTANTE_GAS_AR_SECO * T(i,j,k))
                    dp_dx = (p(i,j+1) - p(i,j-1)) / (2.0_dp * delta_lon * RAIO_TERRA * &
                            cos(graus_para_radianos(latitude(i))))
                    adv_u = u(i,j,k) * (u(i,j+1,k) - u(i,j-1,k)) / (2.0_dp * delta_lon * RAIO_TERRA)
                    du_dt(i,j,k) = f * v(i,j,k) - dp_dx / rho - adv_u
                end do
            end do
        end do
        du_dt(1,:,:) = 0.0_dp
        du_dt(NUM_LAT,:,:) = 0.0_dp
        du_dt(:,1,:) = du_dt(:,NUM_LON-1,:)
        du_dt(:,NUM_LON,:) = du_dt(:,2,:)
    end subroutine calcular_tendencia_vento_u
    
    subroutine calcular_tendencia_vento_v(u, v, T, p, dv_dt)
        real(dp), intent(in) :: u(:,:,:), v(:,:,:), T(:,:,:), p(:,:)
        real(dp), intent(out) :: dv_dt(:,:,:)
        integer :: i, j, k
        real(dp) :: f, dp_dy, adv_v, rho
        
        do k = 1, NUM_NIVEIS_ATM
            do j = 1, NUM_LON
                do i = 2, NUM_LAT-1
                    f = calcular_parametro_coriolis(latitude(i))
                    rho = nivel_atm(k) / (CONSTANTE_GAS_AR_SECO * T(i,j,k))
                    dp_dy = (p(i+1,j) - p(i-1,j)) / (2.0_dp * delta_lat * RAIO_TERRA)
                    adv_v = v(i,j,k) * (v(i+1,j,k) - v(i-1,j,k)) / (2.0_dp * delta_lat * RAIO_TERRA)
                    dv_dt(i,j,k) = -f * u(i,j,k) - dp_dy / rho - adv_v
                end do
            end do
        end do
        dv_dt(1,:,:) = 0.0_dp
        dv_dt(NUM_LAT,:,:) = 0.0_dp
    end subroutine calcular_tendencia_vento_v
    
    subroutine calcular_divergencia(u, v, div)
        real(dp), intent(in) :: u(:,:,:), v(:,:,:)
        real(dp), intent(out) :: div(:,:,:)
        integer :: i, j, k
        real(dp) :: lat_rad, cos_lat
        
        do k = 1, NUM_NIVEIS_ATM
            do j = 2, NUM_LON-1
                do i = 2, NUM_LAT-1
                    lat_rad = graus_para_radianos(latitude(i))
                    cos_lat = cos(lat_rad)
                    div(i,j,k) = (u(i,j+1,k) - u(i,j-1,k)) / (2.0_dp * delta_lon * RAIO_TERRA * cos_lat) + &
                                 (v(i+1,j,k)*cos(graus_para_radianos(latitude(i+1))) - &
                                  v(i-1,j,k)*cos(graus_para_radianos(latitude(i-1)))) / &
                                 (2.0_dp * delta_lat * RAIO_TERRA * cos_lat)
                end do
            end do
        end do
    end subroutine calcular_divergencia

end module mod06_equacoes_primitivas
