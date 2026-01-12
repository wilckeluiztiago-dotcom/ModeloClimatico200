!===============================================================================
! Módulo 48: Mistura Vertical Oceânica
! Autor: Luiz Tiago Wilcke
! Descrição: Mistura vertical turbulenta no oceano.
!===============================================================================

module mod48_mistura_vertical_oceano
    use mod01_constantes_fisicas
    implicit none
    
contains

    function coeficiente_mistura_vertical(N2, shear2) result(Kv)
        real(dp), intent(in) :: N2, shear2
        real(dp) :: Kv
        real(dp) :: Ri, Kv_max, Kv_min
        
        Kv_max = 1.0e-2_dp
        Kv_min = 1.0e-5_dp
        
        if (shear2 > 0.0_dp) then
            Ri = N2 / shear2
            if (Ri < 0.0_dp) then
                Kv = Kv_max
            else if (Ri < 0.25_dp) then
                Kv = Kv_max * (1.0_dp - Ri / 0.25_dp)**2
            else
                Kv = Kv_min
            end if
        else
            Kv = Kv_min
        end if
    end function coeficiente_mistura_vertical
    
    subroutine mistura_convectiva_oceano(T, S, dz)
        real(dp), intent(inout) :: T(:), S(:)
        real(dp), intent(in) :: dz(:)
        integer :: k, nk
        real(dp) :: rho_k, rho_k1, T_mix, S_mix, dz_total
        
        nk = size(T)
        
        do k = 1, nk-1
            rho_k = 1025.0_dp * (1.0_dp - 2.0e-4_dp * (T(k) - 283.0_dp) + 7.6e-4_dp * (S(k) - 35.0_dp))
            rho_k1 = 1025.0_dp * (1.0_dp - 2.0e-4_dp * (T(k+1) - 283.0_dp) + 7.6e-4_dp * (S(k+1) - 35.0_dp))
            
            if (rho_k > rho_k1) then
                dz_total = dz(k) + dz(k+1)
                T_mix = (T(k) * dz(k) + T(k+1) * dz(k+1)) / dz_total
                S_mix = (S(k) * dz(k) + S(k+1) * dz(k+1)) / dz_total
                T(k) = T_mix
                T(k+1) = T_mix
                S(k) = S_mix
                S(k+1) = S_mix
            end if
        end do
    end subroutine mistura_convectiva_oceano

end module mod48_mistura_vertical_oceano
