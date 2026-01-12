!===============================================================================
! Módulo 39: Espalhamento Rayleigh
! Autor: Luiz Tiago Wilcke
! Descrição: Espalhamento Rayleigh por moléculas atmosféricas.
!===============================================================================

module mod39_espalhamento_rayleigh
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function secao_choque_rayleigh(lambda) result(sigma)
        real(dp), intent(in) :: lambda
        real(dp) :: sigma
        real(dp) :: n_ref, lambda_um
        
        n_ref = 1.0003_dp
        lambda_um = lambda * 1.0e6_dp
        
        sigma = (24.0_dp * PI**3 / (CONSTANTE_AVOGADRO * lambda_um**4)) * &
                ((n_ref**2 - 1.0_dp) / (n_ref**2 + 2.0_dp))**2 * &
                (6.0_dp + 3.0_dp * 0.035_dp) / (6.0_dp - 7.0_dp * 0.035_dp)
        
        sigma = sigma * 1.0e-28_dp
    end function secao_choque_rayleigh
    
    function espessura_optica_rayleigh(lambda, p_sup, p_topo) result(tau)
        real(dp), intent(in) :: lambda, p_sup, p_topo
        real(dp) :: tau
        real(dp) :: sigma, N_col
        
        sigma = secao_choque_rayleigh(lambda)
        N_col = (p_sup - p_topo) * CONSTANTE_AVOGADRO / (MASSA_MOLAR_AR_SECO * GRAVIDADE_SUPERFICIE)
        tau = sigma * N_col
    end function espessura_optica_rayleigh
    
    pure function funcao_fase_rayleigh(cos_theta) result(P)
        real(dp), intent(in) :: cos_theta
        real(dp) :: P
        P = 0.75_dp * (1.0_dp + cos_theta**2)
    end function funcao_fase_rayleigh
    
    function albedo_rayleigh(tau) result(A)
        real(dp), intent(in) :: tau
        real(dp) :: A
        A = tau / (tau + 1.0_dp)
    end function albedo_rayleigh

end module mod39_espalhamento_rayleigh
