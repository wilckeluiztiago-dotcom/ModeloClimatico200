!===============================================================================
! Módulo 65: Neve
! Autor: Luiz Tiago Wilcke
! Descrição: Acúmulo e derretimento de neve.
!===============================================================================

module mod65_neve
    use mod01_constantes_fisicas
    implicit none
    
contains

    subroutine acumulo_neve(P, T, h_neve, dh)
        real(dp), intent(in) :: P, T, h_neve
        real(dp), intent(out) :: dh
        real(dp) :: fracao_neve
        
        if (T < 273.15_dp) then
            fracao_neve = 1.0_dp
        else if (T < 275.15_dp) then
            fracao_neve = (275.15_dp - T) / 2.0_dp
        else
            fracao_neve = 0.0_dp
        end if
        
        dh = P * fracao_neve / DENSIDADE_NEVE * 1000.0_dp
    end subroutine acumulo_neve
    
    function derretimento_neve(T, insolacao, h_neve) result(taxa)
        real(dp), intent(in) :: T, insolacao, h_neve
        real(dp) :: taxa
        real(dp) :: PDD, fator_rad
        
        if (h_neve <= 0.0_dp) then
            taxa = 0.0_dp
            return
        end if
        
        PDD = max(0.0_dp, T - 273.15_dp)
        fator_rad = insolacao / 300.0_dp
        
        taxa = (4.0e-3_dp * PDD + 2.0e-3_dp * fator_rad) * DENSIDADE_NEVE / DENSIDADE_AGUA
        taxa = min(taxa, h_neve)
    end function derretimento_neve
    
    pure function equivalente_agua_neve(h_neve, densidade_neve) result(SWE)
        real(dp), intent(in) :: h_neve, densidade_neve
        real(dp) :: SWE
        SWE = h_neve * densidade_neve / DENSIDADE_AGUA
    end function equivalente_agua_neve
    
    pure function calcular_albedo_neve(idade_neve, T) result(albedo_result)
        real(dp), intent(in) :: idade_neve, T
        real(dp) :: albedo_result
        albedo_result = 0.85_dp - 0.1_dp * min(idade_neve / 30.0_dp, 1.0_dp)
        if (T > 273.0_dp) albedo_result = albedo_result - 0.1_dp
    end function calcular_albedo_neve

end module mod65_neve
