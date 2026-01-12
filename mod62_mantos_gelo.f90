!===============================================================================
! Módulo 62: Mantos de Gelo
! Autor: Luiz Tiago Wilcke
! Descrição: Mantos de gelo continentais (Antártida, Groenlândia).
!===============================================================================

module mod62_mantos_gelo
    use mod01_constantes_fisicas
    implicit none
    
contains

    function taxa_derretimento_manto(T_sup, insolacao) result(taxa)
        real(dp), intent(in) :: T_sup, insolacao
        real(dp) :: taxa
        real(dp) :: PDD
        
        PDD = max(0.0_dp, T_sup - 273.15_dp)
        taxa = 0.005_dp * PDD + 0.001_dp * insolacao / 1000.0_dp
    end function taxa_derretimento_manto
    
    function fluxo_gelo(h, inclinacao, A_glen, n_glen) result(u)
        real(dp), intent(in) :: h, inclinacao, A_glen, n_glen
        real(dp) :: u
        real(dp) :: tau
        
        tau = DENSIDADE_GELO * GRAVIDADE_SUPERFICIE * h * inclinacao
        u = A_glen * tau**n_glen * h
    end function fluxo_gelo
    
    function contribuicao_nivel_mar(volume_derretido) result(dSL)
        real(dp), intent(in) :: volume_derretido
        real(dp) :: dSL
        real(dp) :: area_oceano
        area_oceano = 3.61e14_dp
        dSL = volume_derretido * (DENSIDADE_GELO / DENSIDADE_AGUA) / area_oceano
    end function contribuicao_nivel_mar
    
    subroutine balanco_massa_manto(acumulacao, ablacao, calving, dM)
        real(dp), intent(in) :: acumulacao, ablacao, calving
        real(dp), intent(out) :: dM
        dM = acumulacao - ablacao - calving
    end subroutine balanco_massa_manto

end module mod62_mantos_gelo
