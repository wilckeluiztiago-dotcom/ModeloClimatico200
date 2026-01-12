!===============================================================================
! Módulo 12: Camada Limite Planetária
! Autor: Luiz Tiago Wilcke
! Descrição: Parametrização da camada limite planetária (PBL).
!===============================================================================

module mod12_camada_limite
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
    real(dp), parameter :: CONSTANTE_VON_KARMAN = 0.4_dp
    real(dp), parameter :: RUGOSIDADE_OCEANO = 0.0002_dp
    real(dp), parameter :: RUGOSIDADE_TERRA = 0.1_dp
    real(dp), parameter :: DENSIDADE_AR_REF = 1.225_dp
    
contains

    function calcular_altura_pbl(theta_v, u_star, f) result(h_pbl)
        real(dp), intent(in) :: theta_v(:), u_star, f
        real(dp) :: h_pbl
        real(dp) :: N2, theta_ref
        integer :: k, nk
        
        nk = size(theta_v)
        theta_ref = theta_v(1)
        h_pbl = 1000.0_dp
        
        do k = 2, nk
            N2 = GRAVIDADE_SUPERFICIE * (theta_v(k) - theta_v(k-1)) / &
                 (theta_ref * (altitude_atm(k) - altitude_atm(k-1)))
            if (N2 > 1.0e-4_dp) then
                h_pbl = altitude_atm(k)
                exit
            end if
        end do
    end function calcular_altura_pbl
    
    function calcular_velocidade_friccao(vento, z, z0) result(u_star)
        real(dp), intent(in) :: vento, z, z0
        real(dp) :: u_star
        u_star = CONSTANTE_VON_KARMAN * vento / log(z / z0)
    end function calcular_velocidade_friccao
    
    subroutine fluxos_superficie(T_ar, T_sup, q_ar, q_sup, vento, z0, flux_calor, flux_umidade)
        real(dp), intent(in) :: T_ar, T_sup, q_ar, q_sup, vento, z0
        real(dp), intent(out) :: flux_calor, flux_umidade
        real(dp) :: C_H, C_E, u_star, z_ref
        
        z_ref = 10.0_dp
        u_star = calcular_velocidade_friccao(vento, z_ref, z0)
        C_H = CONSTANTE_VON_KARMAN**2 / (log(z_ref/z0))**2
        C_E = C_H
        
        flux_calor = -DENSIDADE_AR_REF * CP_AR_SECO * C_H * vento * (T_ar - T_sup)
        flux_umidade = -DENSIDADE_AR_REF * C_E * vento * (q_ar - q_sup)
    end subroutine fluxos_superficie

end module mod12_camada_limite
