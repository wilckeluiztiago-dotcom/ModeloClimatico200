!===============================================================================
! Módulo 41: Radiação de Onda Longa
! Autor: Luiz Tiago Wilcke
! Descrição: Radiação infravermelha terrestre.
!===============================================================================

module mod41_radiacao_onda_longa
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function emissao_planck(T) result(B)
        real(dp), intent(in) :: T
        real(dp) :: B
        B = CONSTANTE_STEFAN_BOLTZMANN * T**4
    end function emissao_planck
    
    subroutine fluxo_lw_ascendente(T, emiss, tau, F_up)
        real(dp), intent(in) :: T(:), emiss(:), tau(:)
        real(dp), intent(out) :: F_up(:)
        integer :: k, nk
        real(dp) :: transmiss
        
        nk = size(T)
        F_up(1) = emiss(1) * emissao_planck(T(1))
        
        do k = 2, nk
            transmiss = exp(-tau(k-1))
            F_up(k) = F_up(k-1) * transmiss + &
                      (1.0_dp - transmiss) * emissao_planck(T(k-1))
        end do
    end subroutine fluxo_lw_ascendente
    
    subroutine fluxo_lw_descendente(T, tau, F_down)
        real(dp), intent(in) :: T(:), tau(:)
        real(dp), intent(out) :: F_down(:)
        integer :: k, nk
        real(dp) :: transmiss
        
        nk = size(T)
        F_down(nk) = 0.0_dp
        
        do k = nk-1, 1, -1
            transmiss = exp(-tau(k))
            F_down(k) = F_down(k+1) * transmiss + &
                        (1.0_dp - transmiss) * emissao_planck(T(k+1))
        end do
    end subroutine fluxo_lw_descendente
    
    function taxa_resfriamento_radiativo(dF_net, rho, cp) result(dT_dt)
        real(dp), intent(in) :: dF_net, rho, cp
        real(dp) :: dT_dt
        dT_dt = -dF_net / (rho * cp)
    end function taxa_resfriamento_radiativo

end module mod41_radiacao_onda_longa
