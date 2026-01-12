!===============================================================================
! Módulo 51: Temperatura do Oceano
! Autor: Luiz Tiago Wilcke
! Descrição: Distribuição e evolução da temperatura oceânica.
!===============================================================================

module mod51_temperatura_oceano
    use mod01_constantes_fisicas
    implicit none
    
contains

    subroutine tendencia_temperatura_oceano(T_o, u, v, w, Q_net, Kh, Kv, dx, dy, dz, dT)
        real(dp), intent(in) :: T_o(:,:,:), u(:,:,:), v(:,:,:), w(:,:,:)
        real(dp), intent(in) :: Q_net(:,:), Kh, Kv, dx, dy
        real(dp), intent(in) :: dz(:)
        real(dp), intent(out) :: dT(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: adv, diff_h, diff_v, heat_flux
        
        ni = size(T_o, 1)
        nj = size(T_o, 2)
        nk = size(T_o, 3)
        dT = 0.0_dp
        
        do k = 1, nk
            do j = 2, nj-1
                do i = 2, ni-1
                    adv = -u(i,j,k) * (T_o(i+1,j,k) - T_o(i-1,j,k)) / (2.0_dp * dx) &
                          -v(i,j,k) * (T_o(i,j+1,k) - T_o(i,j-1,k)) / (2.0_dp * dy)
                    
                    diff_h = Kh * ((T_o(i+1,j,k) - 2.0_dp*T_o(i,j,k) + T_o(i-1,j,k)) / dx**2 + &
                                   (T_o(i,j+1,k) - 2.0_dp*T_o(i,j,k) + T_o(i,j-1,k)) / dy**2)
                    
                    if (k > 1 .and. k < nk) then
                        diff_v = Kv * (T_o(i,j,k+1) - 2.0_dp*T_o(i,j,k) + T_o(i,j,k-1)) / dz(k)**2
                    else
                        diff_v = 0.0_dp
                    end if
                    
                    if (k == 1) then
                        heat_flux = Q_net(i,j) / (DENSIDADE_AGUA_MAR * CP_AGUA_MAR * dz(1))
                    else
                        heat_flux = 0.0_dp
                    end if
                    
                    dT(i,j,k) = adv + diff_h + diff_v + heat_flux
                end do
            end do
        end do
    end subroutine tendencia_temperatura_oceano
    
    function temperatura_superficie_mar(T_oceano_sup) result(SST)
        real(dp), intent(in) :: T_oceano_sup(:,:)
        real(dp) :: SST(size(T_oceano_sup,1), size(T_oceano_sup,2))
        SST = T_oceano_sup
    end function temperatura_superficie_mar

end module mod51_temperatura_oceano
