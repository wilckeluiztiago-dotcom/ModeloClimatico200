!===============================================================================
! Módulo 63: Geleiras
! Autor: Luiz Tiago Wilcke
! Descrição: Geleiras de montanha e pequenas calotas.
!===============================================================================

module mod63_geleiras
    use mod01_constantes_fisicas
    implicit none
    
contains

    function linha_equilibrio_altitude(T_verao, P_inverno) result(ELA)
        real(dp), intent(in) :: T_verao, P_inverno
        real(dp) :: ELA
        ELA = 3000.0_dp - 200.0_dp * (T_verao - 283.0_dp) + 100.0_dp * (P_inverno - 1.0_dp)
    end function linha_equilibrio_altitude
    
    function sensibilidade_climatica_geleira(delta_T, delta_P) result(delta_L)
        real(dp), intent(in) :: delta_T, delta_P
        real(dp) :: delta_L
        delta_L = -100.0_dp * delta_T + 50.0_dp * delta_P
    end function sensibilidade_climatica_geleira
    
    subroutine evolucao_geleira(L, ELA, z_topo, z_base, dt_step, dL)
        real(dp), intent(in) :: L, ELA, z_topo, z_base, dt_step
        real(dp), intent(out) :: dL
        real(dp) :: AAR, taxa_resposta
        
        if (z_topo > ELA) then
            AAR = (z_topo - ELA) / (z_topo - z_base)
        else
            AAR = 0.0_dp
        end if
        
        taxa_resposta = 50.0_dp
        dL = (AAR - 0.6_dp) * L * dt_step / (taxa_resposta * 365.25_dp * 86400.0_dp)
    end subroutine evolucao_geleira

end module mod63_geleiras
