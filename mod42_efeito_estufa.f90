!===============================================================================
! Módulo 42: Efeito Estufa
! Autor: Luiz Tiago Wilcke
! Descrição: Efeito estufa e forçamento radiativo.
!===============================================================================

module mod42_efeito_estufa
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function forcamento_co2(C, C0) result(RF)
        real(dp), intent(in) :: C, C0
        real(dp) :: RF
        RF = 5.35_dp * log(C / C0)
    end function forcamento_co2
    
    pure function forcamento_ch4(M, M0) result(RF)
        real(dp), intent(in) :: M, M0
        real(dp) :: RF
        RF = 0.036_dp * (sqrt(M) - sqrt(M0))
    end function forcamento_ch4
    
    pure function forcamento_n2o(N, N0) result(RF)
        real(dp), intent(in) :: N, N0
        real(dp) :: RF
        RF = 0.12_dp * (sqrt(N) - sqrt(N0))
    end function forcamento_n2o
    
    function sensibilidade_climatica(RF, lambda) result(dT)
        real(dp), intent(in) :: RF, lambda
        real(dp) :: dT
        dT = RF / lambda
    end function sensibilidade_climatica
    
    function feedback_vapor_agua(dT_inicial) result(fator)
        real(dp), intent(in) :: dT_inicial
        real(dp) :: fator
        real(dp) :: f_wv
        f_wv = 0.5_dp
        fator = 1.0_dp / (1.0_dp - f_wv)
    end function feedback_vapor_agua
    
    function temperatura_equilibrio_terra(S0, albedo, emiss) result(T_eq)
        real(dp), intent(in) :: S0, albedo, emiss
        real(dp) :: T_eq
        T_eq = ((S0 * (1.0_dp - albedo)) / (4.0_dp * emiss * CONSTANTE_STEFAN_BOLTZMANN))**0.25_dp
    end function temperatura_equilibrio_terra

end module mod42_efeito_estufa
