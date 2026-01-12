!===============================================================================
! Módulo 31: Precipitação Mista
! Autor: Luiz Tiago Wilcke
! Descrição: Precipitação de nuvens com fase mista (gelo + água).
!===============================================================================

module mod31_precipitacao_mista
    use mod01_constantes_fisicas
    implicit none
    
contains

    subroutine rimming(qi, ql, dqi, dql, E_rim, dt)
        real(dp), intent(in) :: qi, ql, E_rim, dt
        real(dp), intent(out) :: dqi, dql
        real(dp) :: taxa
        taxa = 0.1_dp * E_rim * qi * ql
        dqi = taxa * dt
        dql = -dqi
    end subroutine rimming
    
    subroutine agregacao(qi, qs, dqi, dqs, dt)
        real(dp), intent(in) :: qi, qs, dt
        real(dp), intent(out) :: dqi, dqs
        real(dp) :: taxa
        taxa = 0.05_dp * qi * qs**0.5_dp
        dqs = taxa * dt
        dqi = -dqs
    end subroutine agregacao
    
    subroutine derretimento(qs, T, dqs, dqr, dt)
        real(dp), intent(in) :: qs, T, dt
        real(dp), intent(out) :: dqs, dqr
        real(dp) :: taxa, T_C
        
        T_C = T - 273.15_dp
        if (T_C > 0.0_dp) then
            taxa = 2.0e-3_dp * T_C * qs
            dqr = taxa * dt
            dqs = -dqr
        else
            dqr = 0.0_dp
            dqs = 0.0_dp
        end if
    end subroutine derretimento
    
    function fracao_fase_gelo(T) result(f_ice)
        real(dp), intent(in) :: T
        real(dp) :: f_ice
        if (T >= 273.15_dp) then
            f_ice = 0.0_dp
        else if (T <= 233.15_dp) then
            f_ice = 1.0_dp
        else
            f_ice = (273.15_dp - T) / 40.0_dp
        end if
    end function fracao_fase_gelo

end module mod31_precipitacao_mista
