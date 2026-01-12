!===============================================================================
! Módulo 24: Troca de Calor Latente
! Autor: Luiz Tiago Wilcke
! Descrição: Liberação e absorção de calor latente.
!===============================================================================

module mod24_troca_calor_latente
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function calor_latente_condensacao(T) result(Lv)
        real(dp), intent(in) :: T
        real(dp) :: Lv
        Lv = CALOR_LATENTE_VAPORIZACAO - 2370.0_dp * (T - 273.15_dp)
    end function calor_latente_condensacao
    
    pure function calor_latente_congelamento(T) result(Lf)
        real(dp), intent(in) :: T
        real(dp) :: Lf
        Lf = CALOR_LATENTE_FUSAO + (CP_AGUA_LIQUIDA - CP_GELO) * (T - 273.15_dp)
    end function calor_latente_congelamento
    
    subroutine liberar_calor_condensacao(dq_condensado, T, dT)
        real(dp), intent(in) :: dq_condensado(:,:,:), T(:,:,:)
        real(dp), intent(out) :: dT(:,:,:)
        integer :: i, j, k
        real(dp) :: Lv
        do k = 1, size(T, 3)
            do j = 1, size(T, 2)
                do i = 1, size(T, 1)
                    Lv = calor_latente_condensacao(T(i,j,k))
                    dT(i,j,k) = Lv * dq_condensado(i,j,k) / CP_AR_SECO
                end do
            end do
        end do
    end subroutine liberar_calor_condensacao
    
    subroutine liberar_calor_congelamento(dq_congelado, T, dT)
        real(dp), intent(in) :: dq_congelado(:,:,:), T(:,:,:)
        real(dp), intent(out) :: dT(:,:,:)
        integer :: i, j, k
        real(dp) :: Lf
        do k = 1, size(T, 3)
            do j = 1, size(T, 2)
                do i = 1, size(T, 1)
                    Lf = calor_latente_congelamento(T(i,j,k))
                    dT(i,j,k) = Lf * dq_congelado(i,j,k) / CP_AR_SECO
                end do
            end do
        end do
    end subroutine liberar_calor_congelamento

end module mod24_troca_calor_latente
