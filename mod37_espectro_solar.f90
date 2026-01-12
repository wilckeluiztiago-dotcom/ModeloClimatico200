!===============================================================================
! Módulo 37: Espectro Solar
! Autor: Luiz Tiago Wilcke
! Descrição: Espectro solar e bandas espectrais.
!===============================================================================

module mod37_espectro_solar
    use mod01_constantes_fisicas
    implicit none
    
    integer, parameter :: NUM_BANDAS_SW = 6
    
    real(dp), parameter :: LAMBDA_MIN(NUM_BANDAS_SW) = &
        [0.2_dp, 0.35_dp, 0.5_dp, 0.7_dp, 1.0_dp, 2.0_dp]
    real(dp), parameter :: LAMBDA_MAX(NUM_BANDAS_SW) = &
        [0.35_dp, 0.5_dp, 0.7_dp, 1.0_dp, 2.0_dp, 4.0_dp]
    real(dp), parameter :: FRACAO_SOLAR(NUM_BANDAS_SW) = &
        [0.03_dp, 0.18_dp, 0.22_dp, 0.23_dp, 0.25_dp, 0.09_dp]
    
contains

    pure function planck_solar(lambda, T_sol) result(B)
        real(dp), intent(in) :: lambda, T_sol
        real(dp) :: B
        real(dp) :: c1, c2
        
        c1 = 2.0_dp * CONSTANTE_PLANCK * VELOCIDADE_LUZ**2
        c2 = CONSTANTE_PLANCK * VELOCIDADE_LUZ / CONSTANTE_BOLTZMANN
        
        B = c1 / (lambda**5 * (exp(c2 / (lambda * T_sol)) - 1.0_dp))
    end function planck_solar
    
    subroutine distribuir_radiacao_bandas(S_total, S_banda)
        real(dp), intent(in) :: S_total
        real(dp), intent(out) :: S_banda(NUM_BANDAS_SW)
        integer :: b
        
        do b = 1, NUM_BANDAS_SW
            S_banda(b) = S_total * FRACAO_SOLAR(b)
        end do
    end subroutine distribuir_radiacao_bandas
    
    pure function comprimento_onda_pico(T) result(lambda_max)
        real(dp), intent(in) :: T
        real(dp) :: lambda_max
        lambda_max = 2.898e-3_dp / T
    end function comprimento_onda_pico

end module mod37_espectro_solar
