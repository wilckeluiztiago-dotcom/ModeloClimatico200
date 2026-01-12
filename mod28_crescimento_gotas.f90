!===============================================================================
! Módulo 28: Crescimento de Gotas
! Autor: Luiz Tiago Wilcke
! Descrição: Crescimento de gotas por condensação e coalescência.
!===============================================================================

module mod28_crescimento_gotas
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function taxa_crescimento_condensacao(r, S, T, p) result(dr_dt)
        real(dp), intent(in) :: r, S, T, p
        real(dp) :: dr_dt
        real(dp) :: D_v, K_a, F_k, F_d, e_s
        
        D_v = 2.21e-5_dp * (T / 273.15_dp)**1.94_dp * (101325.0_dp / p)
        K_a = 2.4e-2_dp * (T / 273.15_dp)**0.7_dp
        e_s = 611.2_dp * exp(17.67_dp * (T - 273.15_dp) / (T - 29.65_dp))
        
        F_k = (CALOR_LATENTE_VAPORIZACAO / (CONSTANTE_GAS_VAPOR * T) - 1.0_dp) * &
              CALOR_LATENTE_VAPORIZACAO / (K_a * T)
        F_d = CONSTANTE_GAS_VAPOR * T / (D_v * e_s)
        
        dr_dt = (S - 1.0_dp) / (r * DENSIDADE_AGUA * (F_k + F_d))
    end function taxa_crescimento_condensacao
    
    function taxa_colecao(r1, r2, ql, E_col) result(dql_dt)
        real(dp), intent(in) :: r1, r2, ql, E_col
        real(dp) :: dql_dt
        real(dp) :: v1, v2, area
        
        v1 = 1.19e8_dp * r1**2
        v2 = 1.19e8_dp * r2**2
        area = PI * (r1 + r2)**2
        
        dql_dt = area * abs(v1 - v2) * E_col * ql * DENSIDADE_AGUA
    end function taxa_colecao
    
    function eficiencia_colecao(r1, r2) result(E)
        real(dp), intent(in) :: r1, r2
        real(dp) :: E, p_ratio
        p_ratio = min(r1, r2) / max(r1, r2)
        E = 0.5_dp * (1.0_dp + tanh(10.0_dp * (p_ratio - 0.1_dp)))
    end function eficiencia_colecao

end module mod28_crescimento_gotas
