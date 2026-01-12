!===============================================================================
! Módulo 11: Gradiente de Pressão
! Autor: Luiz Tiago Wilcke
! Descrição: Cálculo do gradiente de pressão atmosférico.
!===============================================================================

module mod11_gradiente_pressao
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
contains

    subroutine calcular_gradiente_pressao(p, rho, grad_px, grad_py)
        real(dp), intent(in) :: p(:,:,:), rho(:,:,:)
        real(dp), intent(out) :: grad_px(:,:,:), grad_py(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: dx, dy
        
        ni = size(p, 1)
        nj = size(p, 2)
        nk = size(p, 3)
        grad_px = 0.0_dp
        grad_py = 0.0_dp
        
        do k = 1, nk
            do j = 2, nj-1
                do i = 2, ni-1
                    dx = delta_lat * RAIO_TERRA * PI / 180.0_dp
                    dy = delta_lon * RAIO_TERRA * PI / 180.0_dp * cos(graus_para_radianos(latitude(i)))
                    grad_px(i,j,k) = -(p(i+1,j,k) - p(i-1,j,k)) / (2.0_dp * dx * rho(i,j,k))
                    grad_py(i,j,k) = -(p(i,j+1,k) - p(i,j-1,k)) / (2.0_dp * dy * rho(i,j,k))
                end do
            end do
        end do
    end subroutine calcular_gradiente_pressao
    
    subroutine calcular_pressao_hidrostatica(T, p_sup, p)
        real(dp), intent(in) :: T(:,:,:), p_sup(:,:)
        real(dp), intent(out) :: p(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: dz, T_media, g_R
        
        ni = size(T, 1)
        nj = size(T, 2)
        nk = size(T, 3)
        g_R = GRAVIDADE_SUPERFICIE / CONSTANTE_GAS_AR_SECO
        
        do j = 1, nj
            do i = 1, ni
                p(i,j,1) = p_sup(i,j)
                do k = 2, nk
                    dz = altitude_atm(k) - altitude_atm(k-1)
                    T_media = 0.5_dp * (T(i,j,k) + T(i,j,k-1))
                    p(i,j,k) = p(i,j,k-1) * exp(-g_R * dz / T_media)
                end do
            end do
        end do
    end subroutine calcular_pressao_hidrostatica
    
    function altura_geopotencial(z, lat) result(phi)
        real(dp), intent(in) :: z, lat
        real(dp) :: phi, g_local
        g_local = calcular_gravidade_local(lat)
        phi = g_local * z
    end function altura_geopotencial

end module mod11_gradiente_pressao
