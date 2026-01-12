!===============================================================================
! Módulo 25: Perfil Vertical
! Autor: Luiz Tiago Wilcke
! Descrição: Perfis verticais de temperatura, pressão e densidade.
!===============================================================================

module mod25_perfil_vertical
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
contains

    subroutine atmosfera_padrao_isa(z, T, p, rho)
        real(dp), intent(in) :: z(:)
        real(dp), intent(out) :: T(:), p(:), rho(:)
        integer :: k, nk
        real(dp) :: T0, p0, H, gamma_tropo
        
        nk = size(z)
        T0 = 288.15_dp
        p0 = 101325.0_dp
        gamma_tropo = 0.0065_dp
        H = 8500.0_dp
        
        do k = 1, nk
            if (z(k) <= 11000.0_dp) then
                T(k) = T0 - gamma_tropo * z(k)
                p(k) = p0 * (T(k) / T0)**(GRAVIDADE_SUPERFICIE / (CONSTANTE_GAS_AR_SECO * gamma_tropo))
            else if (z(k) <= 20000.0_dp) then
                T(k) = 216.65_dp
                p(k) = 22632.0_dp * exp(-GRAVIDADE_SUPERFICIE * (z(k) - 11000.0_dp) / (CONSTANTE_GAS_AR_SECO * 216.65_dp))
            else
                T(k) = 216.65_dp + 0.001_dp * (z(k) - 20000.0_dp)
                p(k) = 5474.9_dp * (216.65_dp / T(k))**(GRAVIDADE_SUPERFICIE / (CONSTANTE_GAS_AR_SECO * 0.001_dp))
            end if
            rho(k) = p(k) / (CONSTANTE_GAS_AR_SECO * T(k))
        end do
    end subroutine atmosfera_padrao_isa
    
    subroutine interpolar_vertical(campo_orig, z_orig, z_novo, campo_novo)
        real(dp), intent(in) :: campo_orig(:), z_orig(:), z_novo(:)
        real(dp), intent(out) :: campo_novo(:)
        integer :: k, kk, n_orig, n_novo
        real(dp) :: peso
        
        n_orig = size(z_orig)
        n_novo = size(z_novo)
        
        do k = 1, n_novo
            do kk = 1, n_orig-1
                if (z_novo(k) >= z_orig(kk) .and. z_novo(k) < z_orig(kk+1)) then
                    peso = (z_novo(k) - z_orig(kk)) / (z_orig(kk+1) - z_orig(kk))
                    campo_novo(k) = campo_orig(kk) * (1.0_dp - peso) + campo_orig(kk+1) * peso
                    exit
                end if
            end do
        end do
    end subroutine interpolar_vertical

end module mod25_perfil_vertical
