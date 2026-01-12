!===============================================================================
! Módulo 44: Balanço Radiativo TOA
! Autor: Luiz Tiago Wilcke
! Descrição: Balanço radiativo no topo da atmosfera.
!===============================================================================

module mod44_balanco_radiativo
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function radiacao_liquida_toa(SW_in, SW_out, LW_out) result(R_net)
        real(dp), intent(in) :: SW_in, SW_out, LW_out
        real(dp) :: R_net
        R_net = SW_in - SW_out - LW_out
    end function radiacao_liquida_toa
    
    pure function desequilibrio_energetico(R_net_global) result(N)
        real(dp), intent(in) :: R_net_global
        real(dp) :: N
        N = R_net_global
    end function desequilibrio_energetico
    
    subroutine balanco_radiativo_coluna(S_toa, albedo_sup, T, q, cf, tau_lw, SW_net, LW_net)
        real(dp), intent(in) :: S_toa, albedo_sup, T(:), q(:), cf(:), tau_lw(:)
        real(dp), intent(out) :: SW_net, LW_net
        real(dp) :: albedo_atm, trans_sw, LW_up_toa, LW_down_sup
        integer :: k, nk
        
        nk = size(T)
        albedo_atm = 0.0_dp
        trans_sw = 1.0_dp
        
        do k = 1, nk
            albedo_atm = albedo_atm + cf(k) * 0.3_dp * trans_sw
            trans_sw = trans_sw * (1.0_dp - cf(k) * 0.3_dp)
        end do
        
        SW_net = S_toa * (1.0_dp - albedo_atm) * (1.0_dp - albedo_sup)
        
        LW_up_toa = CONSTANTE_STEFAN_BOLTZMANN * T(nk)**4
        LW_down_sup = 0.0_dp
        do k = nk, 1, -1
            LW_down_sup = LW_down_sup + (1.0_dp - exp(-tau_lw(k))) * CONSTANTE_STEFAN_BOLTZMANN * T(k)**4
        end do
        
        LW_net = CONSTANTE_STEFAN_BOLTZMANN * T(1)**4 - LW_down_sup
    end subroutine balanco_radiativo_coluna

end module mod44_balanco_radiativo
