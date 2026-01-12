!===============================================================================
! Módulo 64: Permafrost
! Autor: Luiz Tiago Wilcke
! Descrição: Permafrost e solo congelado.
!===============================================================================

module mod64_permafrost
    use mod01_constantes_fisicas
    implicit none
    
contains

    function profundidade_ativa(T_ar_media, amplitude) result(ALT)
        real(dp), intent(in) :: T_ar_media, amplitude
        real(dp) :: ALT
        real(dp) :: I_ar
        
        I_ar = max(0.0_dp, (T_ar_media - 273.15_dp)) * 180.0_dp
        ALT = 0.5_dp * sqrt(I_ar)
    end function profundidade_ativa
    
    function emissao_metano_permafrost(T_solo, theta, C_org) result(CH4)
        real(dp), intent(in) :: T_solo, theta, C_org
        real(dp) :: CH4
        real(dp) :: Q10, T_ref
        
        T_ref = 283.15_dp
        Q10 = 2.0_dp
        
        if (T_solo > 273.15_dp) then
            CH4 = C_org * 1.0e-6_dp * Q10**((T_solo - T_ref) / 10.0_dp) * theta
        else
            CH4 = 0.0_dp
        end if
    end function emissao_metano_permafrost
    
    function indice_congelamento(T_mensal, n_meses) result(FI)
        real(dp), intent(in) :: T_mensal(:)
        integer, intent(in) :: n_meses
        real(dp) :: FI
        integer :: m
        
        FI = 0.0_dp
        do m = 1, n_meses
            if (T_mensal(m) < 273.15_dp) then
                FI = FI + (273.15_dp - T_mensal(m)) * 30.0_dp
            end if
        end do
    end function indice_congelamento

end module mod64_permafrost
