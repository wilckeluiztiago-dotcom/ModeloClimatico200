!===============================================================================
! Módulo 18: Entalpia Atmosférica
! Autor: Luiz Tiago Wilcke
! Descrição: Cálculos de entalpia e calor específico.
!===============================================================================

module mod18_entalpia_atmosfera
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function entalpia_especifica(T, q, ql, qi) result(h)
        real(dp), intent(in) :: T, q, ql, qi
        real(dp) :: h
        h = CP_AR_SECO * T * (1.0_dp - q - ql - qi) + &
            CP_VAPOR * T * q + &
            CP_AGUA_LIQUIDA * T * ql + &
            CP_GELO * T * qi + &
            CALOR_LATENTE_VAPORIZACAO * q - &
            CALOR_LATENTE_FUSAO * qi
    end function entalpia_especifica
    
    pure function cp_ar_umido(q) result(cp)
        real(dp), intent(in) :: q
        real(dp) :: cp
        cp = CP_AR_SECO * (1.0_dp - q) + CP_VAPOR * q
    end function cp_ar_umido
    
    pure function cv_ar_umido(q) result(cv)
        real(dp), intent(in) :: q
        real(dp) :: cv
        cv = CV_AR_SECO * (1.0_dp - q) + (CP_VAPOR - CONSTANTE_GAS_VAPOR) * q
    end function cv_ar_umido
    
    pure function gamma_ar_umido(q) result(gamma)
        real(dp), intent(in) :: q
        real(dp) :: gamma
        gamma = cp_ar_umido(q) / cv_ar_umido(q)
    end function gamma_ar_umido

end module mod18_entalpia_atmosfera
