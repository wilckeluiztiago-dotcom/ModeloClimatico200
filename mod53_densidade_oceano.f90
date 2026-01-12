!===============================================================================
! Módulo 53: Densidade do Oceano
! Autor: Luiz Tiago Wilcke
! Descrição: Cálculo de densidade e estratificação oceânica.
!===============================================================================

module mod53_densidade_oceano
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function equacao_estado_unesco(T, S, p) result(rho)
        real(dp), intent(in) :: T, S, p
        real(dp) :: rho
        real(dp) :: T_C, rho_0, A, B
        
        T_C = T - 273.15_dp
        rho_0 = 999.842594_dp + 6.793952e-2_dp * T_C - 9.095290e-3_dp * T_C**2 + &
                1.001685e-4_dp * T_C**3
        A = 0.824493_dp - 4.0899e-3_dp * T_C + 7.6438e-5_dp * T_C**2
        B = -5.72466e-3_dp + 1.0227e-4_dp * T_C - 1.6546e-6_dp * T_C**2
        
        rho = rho_0 + A * S + B * S**1.5_dp
    end function equacao_estado_unesco
    
    function frequencia_brunt_vaisala_oceano(rho, z) result(N)
        real(dp), intent(in) :: rho(:), z(:)
        real(dp) :: N(size(rho))
        integer :: k, nk
        real(dp) :: drho_dz
        
        nk = size(rho)
        N = 0.0_dp
        
        do k = 2, nk-1
            drho_dz = (rho(k+1) - rho(k-1)) / (z(k+1) - z(k-1))
            if (drho_dz > 0.0_dp) then
                N(k) = sqrt(GRAVIDADE_SUPERFICIE * drho_dz / rho(k))
            else
                N(k) = 0.0_dp
            end if
        end do
    end function frequencia_brunt_vaisala_oceano
    
    function profundidade_camada_mistura(rho, z, delta_rho) result(MLD)
        real(dp), intent(in) :: rho(:), z(:), delta_rho
        real(dp) :: MLD
        integer :: k
        
        MLD = z(size(z))
        do k = 2, size(rho)
            if (rho(k) - rho(1) > delta_rho) then
                MLD = z(k)
                exit
            end if
        end do
    end function profundidade_camada_mistura

end module mod53_densidade_oceano
