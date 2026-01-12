!===============================================================================
! Módulo 27: Nucleação de Gotas
! Autor: Luiz Tiago Wilcke
! Descrição: Nucleação de gotículas em núcleos de condensação.
!===============================================================================

module mod27_nucleacao_gotas
    use mod01_constantes_fisicas
    implicit none
    
    real(dp), parameter :: TENSAO_SUPERFICIAL_AGUA = 0.0728_dp
    
contains

    pure function raio_critico_nucleacao(T, S) result(r_c)
        real(dp), intent(in) :: T, S
        real(dp) :: r_c
        if (S > 1.0_dp) then
            r_c = 2.0_dp * TENSAO_SUPERFICIAL_AGUA * MASSA_MOLAR_VAPOR_AGUA / &
                  (DENSIDADE_AGUA * CONSTANTE_GAS_UNIVERSAL * T * log(S))
        else
            r_c = 1.0e10_dp
        end if
    end function raio_critico_nucleacao
    
    pure function energia_gibbs_nucleacao(T, S, r) result(dG)
        real(dp), intent(in) :: T, S, r
        real(dp) :: dG
        dG = 4.0_dp * PI * r**2 * TENSAO_SUPERFICIAL_AGUA - &
             (4.0_dp / 3.0_dp) * PI * r**3 * DENSIDADE_AGUA * CONSTANTE_GAS_UNIVERSAL * T * log(S) / MASSA_MOLAR_VAPOR_AGUA
    end function energia_gibbs_nucleacao
    
    function taxa_nucleacao_ccn(supersaturacao, N_ccn) result(taxa)
        real(dp), intent(in) :: supersaturacao, N_ccn
        real(dp) :: taxa
        real(dp) :: k_ccn, c_ccn
        k_ccn = 0.5_dp
        c_ccn = 1.0e8_dp
        if (supersaturacao > 0.0_dp) then
            taxa = c_ccn * supersaturacao**k_ccn
            taxa = min(taxa, N_ccn)
        else
            taxa = 0.0_dp
        end if
    end function taxa_nucleacao_ccn
    
    pure function supersaturacao(q, q_sat) result(S)
        real(dp), intent(in) :: q, q_sat
        real(dp) :: S
        S = q / q_sat
    end function supersaturacao

end module mod27_nucleacao_gotas
