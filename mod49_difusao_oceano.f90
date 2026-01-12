!===============================================================================
! Módulo 49: Difusão Oceânica
! Autor: Luiz Tiago Wilcke
! Descrição: Difusão turbulenta horizontal e vertical no oceano.
!===============================================================================

module mod49_difusao_oceano
    use mod01_constantes_fisicas
    implicit none
    
    real(dp), parameter :: KH_OCEANO = 1000.0_dp
    real(dp), parameter :: KV_OCEANO = 1.0e-4_dp
    
contains

    subroutine difusao_horizontal_oceano(T, Kh, dx, dy, dT)
        real(dp), intent(in) :: T(:,:,:), Kh, dx, dy
        real(dp), intent(out) :: dT(:,:,:)
        integer :: i, j, k, ni, nj, nk
        
        ni = size(T, 1)
        nj = size(T, 2)
        nk = size(T, 3)
        dT = 0.0_dp
        
        do k = 1, nk
            do j = 2, nj-1
                do i = 2, ni-1
                    dT(i,j,k) = Kh * ((T(i+1,j,k) - 2.0_dp*T(i,j,k) + T(i-1,j,k)) / dx**2 + &
                                      (T(i,j+1,k) - 2.0_dp*T(i,j,k) + T(i,j-1,k)) / dy**2)
                end do
            end do
        end do
    end subroutine difusao_horizontal_oceano
    
    subroutine difusao_vertical_oceano(T, Kv, dz, dT)
        real(dp), intent(in) :: T(:,:,:), Kv(:,:,:), dz(:)
        real(dp), intent(out) :: dT(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: dz2
        
        ni = size(T, 1)
        nj = size(T, 2)
        nk = size(T, 3)
        dT = 0.0_dp
        
        do k = 2, nk-1
            dz2 = ((dz(k) + dz(k+1)) / 2.0_dp)**2
            do j = 1, nj
                do i = 1, ni
                    dT(i,j,k) = Kv(i,j,k) * (T(i,j,k+1) - 2.0_dp*T(i,j,k) + T(i,j,k-1)) / dz2
                end do
            end do
        end do
    end subroutine difusao_vertical_oceano

end module mod49_difusao_oceano
