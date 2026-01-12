!===============================================================================
! Módulo 21: Temperatura Potencial
! Autor: Luiz Tiago Wilcke
! Descrição: Temperatura potencial e virtual.
!===============================================================================

module mod21_temperatura_potencial
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function temperatura_potencial(T, p) result(theta)
        real(dp), intent(in) :: T, p
        real(dp) :: theta
        theta = T * (PRESSAO_SUPERFICIE_MEDIA / p)**KAPPA_AR
    end function temperatura_potencial
    
    pure function temperatura_potencial_virtual(T, p, q) result(theta_v)
        real(dp), intent(in) :: T, p, q
        real(dp) :: theta_v, T_v, epsilon
        epsilon = MASSA_MOLAR_VAPOR_AGUA / MASSA_MOLAR_AR_SECO
        T_v = T * (1.0_dp + q * (1.0_dp/epsilon - 1.0_dp))
        theta_v = T_v * (PRESSAO_SUPERFICIE_MEDIA / p)**KAPPA_AR
    end function temperatura_potencial_virtual
    
    pure function temperatura_potencial_equivalente(T, p, q) result(theta_e)
        real(dp), intent(in) :: T, p, q
        real(dp) :: theta_e, theta
        theta = temperatura_potencial(T, p)
        theta_e = theta * exp(CALOR_LATENTE_VAPORIZACAO * q / (CP_AR_SECO * T))
    end function temperatura_potencial_equivalente
    
    pure function temperatura_de_theta(theta, p) result(T)
        real(dp), intent(in) :: theta, p
        real(dp) :: T
        T = theta * (p / PRESSAO_SUPERFICIE_MEDIA)**KAPPA_AR
    end function temperatura_de_theta

end module mod21_temperatura_potencial
