!===============================================================================
! Módulo 61: Gelo Marinho
! Autor: Luiz Tiago Wilcke
! Descrição: Dinâmica do gelo marinho.
!===============================================================================

module mod61_gelo_marinho
    use mod01_constantes_fisicas
    implicit none
    
contains

    subroutine crescimento_gelo_marinho(T_oceano, T_ar, h_gelo, dt, dh)
        real(dp), intent(in) :: T_oceano, T_ar, h_gelo, dt
        real(dp), intent(out) :: dh
        real(dp) :: T_fusao, Q_cond, Q_oceano
        
        T_fusao = 271.35_dp
        
        if (T_oceano < T_fusao .and. T_ar < T_fusao) then
            Q_cond = CONDUTIVIDADE_GELO * (T_fusao - T_ar) / max(h_gelo, 0.01_dp)
            Q_oceano = 2.0_dp
            dh = (Q_cond - Q_oceano) * dt / (DENSIDADE_GELO * CALOR_LATENTE_FUSAO)
        else if (T_ar > T_fusao .or. T_oceano > T_fusao) then
            dh = -0.01_dp * (max(T_ar, T_oceano) - T_fusao) * dt / 86400.0_dp
        else
            dh = 0.0_dp
        end if
    end subroutine crescimento_gelo_marinho
    
    function concentracao_gelo(h_gelo) result(A)
        real(dp), intent(in) :: h_gelo
        real(dp) :: A
        if (h_gelo <= 0.0_dp) then
            A = 0.0_dp
        else if (h_gelo >= 2.0_dp) then
            A = 1.0_dp
        else
            A = h_gelo / 2.0_dp
        end if
    end function concentracao_gelo
    
    function albedo_gelo_marinho(h_gelo, T_sup) result(albedo)
        real(dp), intent(in) :: h_gelo, T_sup
        real(dp) :: albedo
        if (h_gelo <= 0.0_dp) then
            albedo = 0.06_dp
        else if (T_sup > 273.0_dp) then
            albedo = 0.4_dp
        else
            albedo = 0.6_dp + 0.1_dp * min(h_gelo / 3.0_dp, 1.0_dp)
        end if
    end function albedo_gelo_marinho

end module mod61_gelo_marinho
