!===============================================================================
! Módulo 29: Formação de Gelo
! Autor: Luiz Tiago Wilcke
! Descrição: Formação de cristais de gelo em nuvens frias.
!===============================================================================

module mod29_formacao_gelo
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function taxa_nucleacao_homogenea(T) result(J)
        real(dp), intent(in) :: T
        real(dp) :: J
        if (T < 235.0_dp) then
            J = 1.0e10_dp
        else if (T < 238.0_dp) then
            J = exp((-1.0_dp) * (T - 235.0_dp)**2)
        else
            J = 0.0_dp
        end if
    end function taxa_nucleacao_homogenea
    
    function concentracao_nucleos_gelo(T) result(N_in)
        real(dp), intent(in) :: T
        real(dp) :: N_in
        real(dp) :: T_C
        T_C = T - 273.15_dp
        if (T_C < -5.0_dp) then
            N_in = exp(-0.639_dp - 12.96_dp * (T_C + 5.0_dp) / (-25.0_dp))
            N_in = N_in * 1.0e3_dp
        else
            N_in = 0.0_dp
        end if
    end function concentracao_nucleos_gelo
    
    subroutine bergeron_findeisen(T, ql, qi, dql, dqi, dt)
        real(dp), intent(in) :: T, ql, qi, dt
        real(dp), intent(out) :: dql, dqi
        real(dp) :: e_sw, e_si, taxa_transf, tau
        
        if (T < 273.15_dp .and. T > 233.15_dp .and. ql > 0.0_dp .and. qi > 0.0_dp) then
            e_sw = 611.2_dp * exp(17.67_dp * (T - 273.15_dp) / (T - 29.65_dp))
            e_si = 611.2_dp * exp(21.875_dp * (T - 273.15_dp) / (T - 7.65_dp))
            taxa_transf = (e_sw - e_si) / e_sw
            tau = 600.0_dp
            dql = -ql * taxa_transf * (1.0_dp - exp(-dt / tau))
            dqi = -dql
        else
            dql = 0.0_dp
            dqi = 0.0_dp
        end if
    end subroutine bergeron_findeisen

end module mod29_formacao_gelo
