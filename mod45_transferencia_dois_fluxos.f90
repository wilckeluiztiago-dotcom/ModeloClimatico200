!===============================================================================
! Módulo 45: Transferência de Dois Fluxos
! Autor: Luiz Tiago Wilcke
! Descrição: Método de dois fluxos para transferência radiativa.
!===============================================================================

module mod45_transferencia_dois_fluxos
    use mod01_constantes_fisicas
    implicit none
    
contains

    subroutine dois_fluxos_sw(tau, omega, g, mu0, albedo_sup, F_down, F_up)
        real(dp), intent(in) :: tau(:), omega(:), g(:), mu0, albedo_sup
        real(dp), intent(out) :: F_down(:), F_up(:)
        integer :: k, nk
        real(dp) :: gamma1, gamma2, alpha, k_coef, exp_k, denom
        real(dp) :: S0
        
        nk = size(tau)
        S0 = 1.0_dp
        
        do k = 1, nk
            gamma1 = (7.0_dp - omega(k) * (4.0_dp + 3.0_dp * g(k))) / 4.0_dp
            gamma2 = -(1.0_dp - omega(k) * (4.0_dp - 3.0_dp * g(k))) / 4.0_dp
            k_coef = sqrt(gamma1**2 - gamma2**2)
            exp_k = exp(-k_coef * tau(k))
            
            alpha = gamma1 - k_coef
            denom = (gamma1 + k_coef) + (gamma1 - k_coef) * exp_k**2
            
            F_down(k) = S0 * exp(-sum(tau(1:k)) / mu0) + &
                        S0 * omega(k) * (1.0_dp - exp_k) / (denom + 0.01_dp)
            F_up(k) = F_down(k) * albedo_sup * exp(-sum(tau(k:nk)) / mu0)
        end do
    end subroutine dois_fluxos_sw
    
    subroutine dois_fluxos_lw(tau, T, B, F_down, F_up)
        real(dp), intent(in) :: tau(:), T(:), B(:)
        real(dp), intent(out) :: F_down(:), F_up(:)
        integer :: k, nk
        real(dp) :: trans
        
        nk = size(tau)
        
        F_up(1) = B(1)
        do k = 2, nk
            trans = exp(-tau(k-1))
            F_up(k) = F_up(k-1) * trans + B(k-1) * (1.0_dp - trans)
        end do
        
        F_down(nk) = 0.0_dp
        do k = nk-1, 1, -1
            trans = exp(-tau(k))
            F_down(k) = F_down(k+1) * trans + B(k+1) * (1.0_dp - trans)
        end do
    end subroutine dois_fluxos_lw

end module mod45_transferencia_dois_fluxos
