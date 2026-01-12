!===============================================================================
! Módulo 13: Convecção Profunda
! Autor: Luiz Tiago Wilcke
! Descrição: Parametrização de convecção profunda e cumulus.
!===============================================================================

module mod13_conveccao_profunda
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
contains

    subroutine calcular_cape_cin(T, T_parcela, z, cape, cin)
        real(dp), intent(in) :: T(:), T_parcela(:), z(:)
        real(dp), intent(out) :: cape, cin
        integer :: k, nk, lfc, el
        real(dp) :: buoyancy, dz
        
        nk = size(T)
        cape = 0.0_dp
        cin = 0.0_dp
        lfc = 0
        el = nk
        
        do k = 2, nk
            buoyancy = GRAVIDADE_SUPERFICIE * (T_parcela(k) - T(k)) / T(k)
            dz = z(k) - z(k-1)
            if (buoyancy > 0.0_dp) then
                if (lfc == 0) lfc = k
                cape = cape + buoyancy * dz
            else
                if (lfc == 0) then
                    cin = cin + buoyancy * dz
                else
                    el = k
                    exit
                end if
            end if
        end do
    end subroutine calcular_cape_cin
    
    subroutine esquema_conveccao_simples(T, q, w_conv, dT_conv, dq_conv)
        real(dp), intent(in) :: T(:,:,:), q(:,:,:)
        real(dp), intent(out) :: w_conv(:,:,:), dT_conv(:,:,:), dq_conv(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: cape, cin, T_col(NUM_NIVEIS_ATM), T_parcela(NUM_NIVEIS_ATM), z(NUM_NIVEIS_ATM)
        real(dp) :: tau_conv, flux_massa
        
        ni = size(T, 1)
        nj = size(T, 2)
        nk = size(T, 3)
        
        tau_conv = 3600.0_dp
        w_conv = 0.0_dp
        dT_conv = 0.0_dp
        dq_conv = 0.0_dp
        
        do j = 1, nj
            do i = 1, ni
                T_col = T(i,j,:)
                z = altitude_atm
                call calcular_perfil_parcela(T_col(1), q(i,j,1), z, T_parcela)
                call calcular_cape_cin(T_col, T_parcela, z, cape, cin)
                
                if (cape > 100.0_dp) then
                    flux_massa = 0.01_dp * sqrt(2.0_dp * cape)
                    do k = 1, nk
                        w_conv(i,j,k) = flux_massa * exp(-altitude_atm(k) / 10000.0_dp)
                        dT_conv(i,j,k) = -cape / (CP_AR_SECO * tau_conv) * exp(-altitude_atm(k) / 5000.0_dp)
                        dq_conv(i,j,k) = -q(i,j,k) * flux_massa / tau_conv
                    end do
                end if
            end do
        end do
    end subroutine esquema_conveccao_simples
    
    subroutine calcular_perfil_parcela(T_sup, q_sup, z, T_parcela)
        real(dp), intent(in) :: T_sup, q_sup, z(:)
        real(dp), intent(out) :: T_parcela(:)
        integer :: k, nk
        real(dp) :: gamma_seco, gamma_umido, T_lcl
        
        nk = size(z)
        gamma_seco = GRAVIDADE_SUPERFICIE / CP_AR_SECO
        gamma_umido = 6.0e-3_dp
        T_lcl = T_sup - 20.0_dp
        
        do k = 1, nk
            if (T_sup - gamma_seco * z(k) > T_lcl) then
                T_parcela(k) = T_sup - gamma_seco * z(k)
            else
                T_parcela(k) = T_lcl - gamma_umido * (z(k) - (T_sup - T_lcl) / gamma_seco)
            end if
        end do
    end subroutine calcular_perfil_parcela

end module mod13_conveccao_profunda
