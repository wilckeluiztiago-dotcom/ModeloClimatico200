!===============================================================================
! Módulo 22: Estabilidade Atmosférica
! Autor: Luiz Tiago Wilcke
! Descrição: Índices de estabilidade atmosférica (CAPE, CIN, LI).
!===============================================================================

module mod22_estabilidade_atmosferica
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
contains

    function indice_lifted(T_500, T_parcela_500) result(LI)
        real(dp), intent(in) :: T_500, T_parcela_500
        real(dp) :: LI
        LI = T_500 - T_parcela_500
    end function indice_lifted
    
    function indice_showalter(T_850, Td_850, T_500) result(SI)
        real(dp), intent(in) :: T_850, Td_850, T_500
        real(dp) :: SI, T_parcela
        T_parcela = T_850 - (T_850 - Td_850) * 0.5_dp - 30.0_dp
        SI = T_500 - T_parcela
    end function indice_showalter
    
    function indice_k(T_850, T_700, T_500, Td_850, Td_700) result(K)
        real(dp), intent(in) :: T_850, T_700, T_500, Td_850, Td_700
        real(dp) :: K
        K = (T_850 - T_500) + Td_850 - (T_700 - Td_700)
    end function indice_k
    
    function indice_total_totals(T_850, T_500, Td_850) result(TT)
        real(dp), intent(in) :: T_850, T_500, Td_850
        real(dp) :: TT
        TT = T_850 + Td_850 - 2.0_dp * T_500
    end function indice_total_totals
    
    function energia_convectiva_disponivel(T_amb, T_parc, z, n) result(cape)
        integer, intent(in) :: n
        real(dp), intent(in) :: T_amb(n), T_parc(n), z(n)
        real(dp) :: cape
        integer :: k
        real(dp) :: dz, buoy
        cape = 0.0_dp
        do k = 2, n
            buoy = GRAVIDADE_SUPERFICIE * (T_parc(k) - T_amb(k)) / T_amb(k)
            dz = z(k) - z(k-1)
            if (buoy > 0.0_dp) cape = cape + buoy * dz
        end do
    end function energia_convectiva_disponivel

end module mod22_estabilidade_atmosferica
