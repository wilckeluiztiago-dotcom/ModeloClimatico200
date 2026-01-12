!===============================================================================
! Módulo 46: Circulação Termohalina
! Autor: Luiz Tiago Wilcke
! Descrição: Circulação termohalina global do oceano.
!===============================================================================

module mod46_circulacao_termohalina
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
contains

    subroutine calcular_densidade_oceano(T, S, p, rho)
        real(dp), intent(in) :: T(:,:,:), S(:,:,:), p(:,:,:)
        real(dp), intent(out) :: rho(:,:,:)
        integer :: i, j, k
        real(dp) :: T_C, rho_0, alpha, beta
        
        rho_0 = 1025.0_dp
        alpha = COEF_EXPANSAO_TERMICA
        beta = COEF_CONTRACAO_HALINA
        
        do k = 1, size(T, 3)
            do j = 1, size(T, 2)
                do i = 1, size(T, 1)
                    T_C = T(i,j,k) - 273.15_dp
                    rho(i,j,k) = rho_0 * (1.0_dp - alpha * (T_C - 10.0_dp) + &
                                 beta * (S(i,j,k) - 35.0_dp))
                end do
            end do
        end do
    end subroutine calcular_densidade_oceano
    
    subroutine velocidade_termohalina(rho, w_th)
        real(dp), intent(in) :: rho(:,:,:)
        real(dp), intent(out) :: w_th(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: drho_dz, dz
        
        ni = size(rho, 1)
        nj = size(rho, 2)
        nk = size(rho, 3)
        w_th = 0.0_dp
        
        do k = 2, nk-1
            dz = 500.0_dp
            do j = 1, nj
                do i = 1, ni
                    drho_dz = (rho(i,j,k+1) - rho(i,j,k-1)) / (2.0_dp * dz)
                    if (drho_dz > 0.0_dp) then
                        w_th(i,j,k) = -1.0e-4_dp * drho_dz / DENSIDADE_AGUA_MAR
                    end if
                end do
            end do
        end do
    end subroutine velocidade_termohalina
    
    function transporte_amoc(v_merid, dz, dx) result(psi)
        real(dp), intent(in) :: v_merid(:,:), dz(:), dx
        real(dp) :: psi
        integer :: j, k
        psi = 0.0_dp
        do k = 1, size(dz)
            do j = 1, size(v_merid, 1)
                psi = psi + v_merid(j,k) * dz(k) * dx
            end do
        end do
        psi = psi * 1.0e-6_dp
    end function transporte_amoc

end module mod46_circulacao_termohalina
