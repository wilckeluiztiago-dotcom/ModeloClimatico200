!===============================================================================
! Módulo 16: Equação de Estado
! Autor: Luiz Tiago Wilcke
! Descrição: Equação de estado dos gases para ar úmido.
!===============================================================================

module mod16_equacao_estado
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function densidade_ar_seco(p, T) result(rho)
        real(dp), intent(in) :: p, T
        real(dp) :: rho
        rho = p / (CONSTANTE_GAS_AR_SECO * T)
    end function densidade_ar_seco
    
    pure function densidade_ar_umido(p, T, q) result(rho)
        real(dp), intent(in) :: p, T, q
        real(dp) :: rho, T_v
        T_v = temperatura_virtual(T, q)
        rho = p / (CONSTANTE_GAS_AR_SECO * T_v)
    end function densidade_ar_umido
    
    pure function temperatura_virtual(T, q) result(T_v)
        real(dp), intent(in) :: T, q
        real(dp) :: T_v, epsilon
        epsilon = MASSA_MOLAR_VAPOR_AGUA / MASSA_MOLAR_AR_SECO
        T_v = T * (1.0_dp + q * (1.0_dp/epsilon - 1.0_dp))
    end function temperatura_virtual
    
    pure function pressao_parcial_vapor(p, q) result(e)
        real(dp), intent(in) :: p, q
        real(dp) :: e, epsilon
        epsilon = MASSA_MOLAR_VAPOR_AGUA / MASSA_MOLAR_AR_SECO
        e = p * q / (epsilon + q * (1.0_dp - epsilon))
    end function pressao_parcial_vapor
    
    pure function umidade_especifica(e, p) result(q)
        real(dp), intent(in) :: e, p
        real(dp) :: q, epsilon
        epsilon = MASSA_MOLAR_VAPOR_AGUA / MASSA_MOLAR_AR_SECO
        q = epsilon * e / (p - e * (1.0_dp - epsilon))
    end function umidade_especifica

end module mod16_equacao_estado
