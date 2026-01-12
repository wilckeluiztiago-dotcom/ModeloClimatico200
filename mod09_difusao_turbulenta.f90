!===============================================================================
! Módulo 09: Difusão Turbulenta
! Autor: Luiz Tiago Wilcke
! Descrição: Difusão turbulenta e viscosidade na atmosfera.
!===============================================================================

module mod09_difusao_turbulenta
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
    real(dp), parameter :: COEF_DIFUSAO_HORIZONTAL = 1.0e5_dp
    real(dp), parameter :: COEF_DIFUSAO_VERTICAL = 10.0_dp
    
contains

    subroutine difusao_horizontal(campo, coef_dif, tendencia)
        real(dp), intent(in) :: campo(:,:,:), coef_dif
        real(dp), intent(out) :: tendencia(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: dx2, dy2, laplaciano
        
        ni = size(campo, 1)
        nj = size(campo, 2)
        nk = size(campo, 3)
        tendencia = 0.0_dp
        
        do k = 1, nk
            do j = 2, nj-1
                do i = 2, ni-1
                    dx2 = (delta_lat * RAIO_TERRA * PI / 180.0_dp)**2
                    dy2 = (delta_lon * RAIO_TERRA * PI / 180.0_dp * cos(graus_para_radianos(latitude(i))))**2
                    laplaciano = (campo(i+1,j,k) - 2.0_dp*campo(i,j,k) + campo(i-1,j,k)) / dx2 + &
                                 (campo(i,j+1,k) - 2.0_dp*campo(i,j,k) + campo(i,j-1,k)) / dy2
                    tendencia(i,j,k) = coef_dif * laplaciano
                end do
            end do
        end do
    end subroutine difusao_horizontal
    
    subroutine difusao_vertical(campo, coef_dif, tendencia)
        real(dp), intent(in) :: campo(:,:,:), coef_dif
        real(dp), intent(out) :: tendencia(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: dz2
        
        ni = size(campo, 1)
        nj = size(campo, 2)
        nk = size(campo, 3)
        tendencia = 0.0_dp
        
        do k = 2, nk-1
            dz2 = ((altitude_atm(k+1) - altitude_atm(k-1)) / 2.0_dp)**2
            do j = 1, nj
                do i = 1, ni
                    tendencia(i,j,k) = coef_dif * (campo(i,j,k+1) - 2.0_dp*campo(i,j,k) + campo(i,j,k-1)) / dz2
                end do
            end do
        end do
    end subroutine difusao_vertical
    
    function calcular_viscosidade_turbulenta(velocidade_escala, comprimento_mistura) result(nu_t)
        real(dp), intent(in) :: velocidade_escala, comprimento_mistura
        real(dp) :: nu_t
        nu_t = velocidade_escala * comprimento_mistura
    end function calcular_viscosidade_turbulenta

end module mod09_difusao_turbulenta
