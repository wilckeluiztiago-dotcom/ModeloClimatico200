!===============================================================================
! Módulo 52: Salinidade
! Autor: Luiz Tiago Wilcke
! Descrição: Distribuição de salinidade oceânica.
!===============================================================================

module mod52_salinidade
    use mod01_constantes_fisicas
    implicit none
    
contains

    subroutine tendencia_salinidade(S, u, v, w, E, P, Kh, Kv, dx, dy, dz, dS)
        real(dp), intent(in) :: S(:,:,:), u(:,:,:), v(:,:,:), w(:,:,:)
        real(dp), intent(in) :: E(:,:), P(:,:), Kh, Kv, dx, dy
        real(dp), intent(in) :: dz(:)
        real(dp), intent(out) :: dS(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: adv, diff_h, diff_v, flux_sup
        
        ni = size(S, 1)
        nj = size(S, 2)
        nk = size(S, 3)
        dS = 0.0_dp
        
        do k = 1, nk
            do j = 2, nj-1
                do i = 2, ni-1
                    adv = -u(i,j,k) * (S(i+1,j,k) - S(i-1,j,k)) / (2.0_dp * dx) &
                          -v(i,j,k) * (S(i,j+1,k) - S(i,j-1,k)) / (2.0_dp * dy)
                    
                    diff_h = Kh * ((S(i+1,j,k) - 2.0_dp*S(i,j,k) + S(i-1,j,k)) / dx**2 + &
                                   (S(i,j+1,k) - 2.0_dp*S(i,j,k) + S(i,j-1,k)) / dy**2)
                    
                    if (k > 1 .and. k < nk) then
                        diff_v = Kv * (S(i,j,k+1) - 2.0_dp*S(i,j,k) + S(i,j,k-1)) / dz(k)**2
                    else
                        diff_v = 0.0_dp
                    end if
                    
                    if (k == 1) then
                        flux_sup = S(i,j,1) * (E(i,j) - P(i,j)) / dz(1)
                    else
                        flux_sup = 0.0_dp
                    end if
                    
                    dS(i,j,k) = adv + diff_h + diff_v + flux_sup
                end do
            end do
        end do
    end subroutine tendencia_salinidade

end module mod52_salinidade
