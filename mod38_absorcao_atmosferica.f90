!===============================================================================
! Módulo 38: Absorção Atmosférica
! Autor: Luiz Tiago Wilcke
! Descrição: Absorção por gases atmosféricos (H2O, CO2, O3).
!===============================================================================

module mod38_absorcao_atmosferica
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function absortividade_vapor_agua(u_h2o, banda) result(a)
        real(dp), intent(in) :: u_h2o
        integer, intent(in) :: banda
        real(dp) :: a
        real(dp) :: k
        
        select case (banda)
            case (1)
                k = 0.0_dp
            case (2)
                k = 0.01_dp
            case (3)
                k = 0.05_dp
            case (4)
                k = 0.1_dp
            case (5)
                k = 0.5_dp
            case (6)
                k = 1.0_dp
            case default
                k = 0.1_dp
        end select
        
        a = 1.0_dp - exp(-k * u_h2o)
    end function absortividade_vapor_agua
    
    pure function absortividade_co2(u_co2) result(a)
        real(dp), intent(in) :: u_co2
        real(dp) :: a
        a = 0.05_dp * log(1.0_dp + u_co2 / 300.0_dp)
    end function absortividade_co2
    
    pure function absortividade_ozonio(u_o3, banda) result(a)
        real(dp), intent(in) :: u_o3
        integer, intent(in) :: banda
        real(dp) :: a
        
        if (banda == 1) then
            a = 1.0_dp - exp(-1.08_dp * u_o3)
        else
            a = 0.0_dp
        end if
    end function absortividade_ozonio
    
    function caminho_optico(q, p, dz, g) result(u)
        real(dp), intent(in) :: q, p, dz, g
        real(dp) :: u
        real(dp) :: rho
        rho = p / (CONSTANTE_GAS_AR_SECO * 280.0_dp)
        u = q * rho * dz * 1000.0_dp
    end function caminho_optico

end module mod38_absorcao_atmosferica
