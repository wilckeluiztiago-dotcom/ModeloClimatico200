!===============================================================================
! Módulo 59: Topografia
! Autor: Luiz Tiago Wilcke
! Descrição: Efeitos topográficos no clima.
!===============================================================================

module mod59_topografia
    use mod01_constantes_fisicas
    implicit none
    
contains

    function correcao_temperatura_altitude(T_ref, z, z_ref, lapse) result(T)
        real(dp), intent(in) :: T_ref, z, z_ref, lapse
        real(dp) :: T
        T = T_ref - lapse * (z - z_ref)
    end function correcao_temperatura_altitude
    
    function pressao_altitude(p_ref, z, z_ref, T_med) result(p)
        real(dp), intent(in) :: p_ref, z, z_ref, T_med
        real(dp) :: p
        real(dp) :: H
        H = CONSTANTE_GAS_AR_SECO * T_med / GRAVIDADE_SUPERFICIE
        p = p_ref * exp(-(z - z_ref) / H)
    end function pressao_altitude
    
    subroutine sombreamento_topografico(elevacao, azimute_sol, elevacao_sol, sombra)
        real(dp), intent(in) :: elevacao(:,:), azimute_sol, elevacao_sol
        logical, intent(out) :: sombra(:,:)
        integer :: i, j, ni, nj
        
        ni = size(elevacao, 1)
        nj = size(elevacao, 2)
        sombra = .false.
        
        do j = 1, nj
            do i = 1, ni
                if (elevacao_sol < 5.0_dp) then
                    sombra(i,j) = .true.
                end if
            end do
        end do
    end subroutine sombreamento_topografico
    
    function efeito_foehn(T_barlavento, z_topo, z_sotavento, q) result(T_sotavento)
        real(dp), intent(in) :: T_barlavento, z_topo, z_sotavento, q
        real(dp) :: T_sotavento
        real(dp) :: gamma_seco, gamma_umido, T_topo
        
        gamma_seco = 9.8e-3_dp
        gamma_umido = 6.0e-3_dp
        
        T_topo = T_barlavento - gamma_umido * z_topo
        T_sotavento = T_topo + gamma_seco * (z_topo - z_sotavento)
    end function efeito_foehn

end module mod59_topografia
