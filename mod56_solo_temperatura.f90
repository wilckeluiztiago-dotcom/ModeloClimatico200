!===============================================================================
! Módulo 56: Temperatura do Solo
! Autor: Luiz Tiago Wilcke
! Descrição: Temperatura e condução de calor no solo.
!===============================================================================

module mod56_solo_temperatura
    use mod01_constantes_fisicas
    implicit none
    
    real(dp), parameter :: CONDUTIVIDADE_SOLO = 1.0_dp
    real(dp), parameter :: CAPACIDADE_TERMICA_SOLO = 2.0e6_dp
    
contains

    subroutine conducao_calor_solo(T_solo, dz, dt_step, G_sup, dT_out)
        real(dp), intent(in) :: T_solo(:), dz(:), dt_step, G_sup
        real(dp), intent(out) :: dT_out(:)
        integer :: k, nk
        real(dp) :: alpha, dz2
        
        nk = size(T_solo)
        alpha = CONDUTIVIDADE_SOLO / CAPACIDADE_TERMICA_SOLO
        dT_out = 0.0_dp
        
        dT_out(1) = G_sup / (CAPACIDADE_TERMICA_SOLO * dz(1))
        
        do k = 2, nk-1
            dz2 = ((dz(k) + dz(k+1)) / 2.0_dp)**2
            dT_out(k) = alpha * (T_solo(k+1) - 2.0_dp * T_solo(k) + T_solo(k-1)) / dz2
        end do
        
        dT_out(nk) = 0.0_dp
    end subroutine conducao_calor_solo
    
    function fluxo_calor_solo(T_sup, T_solo_1, dz1) result(G)
        real(dp), intent(in) :: T_sup, T_solo_1, dz1
        real(dp) :: G
        G = -CONDUTIVIDADE_SOLO * (T_solo_1 - T_sup) / (dz1 / 2.0_dp)
    end function fluxo_calor_solo

end module mod56_solo_temperatura
