!===============================================================================
! Módulo 33: Fração de Nuvens
! Autor: Luiz Tiago Wilcke
! Descrição: Cálculo da fração de cobertura de nuvens.
!===============================================================================

module mod33_fracao_nuvens
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function fracao_nuvem_diagnostica(RH, RH_crit) result(cf)
        real(dp), intent(in) :: RH, RH_crit
        real(dp) :: cf
        if (RH >= 1.0_dp) then
            cf = 1.0_dp
        else if (RH > RH_crit) then
            cf = ((RH - RH_crit) / (1.0_dp - RH_crit))**2
        else
            cf = 0.0_dp
        end if
    end function fracao_nuvem_diagnostica
    
    pure function fracao_nuvem_conteudo(ql, qi, ql_crit) result(cf)
        real(dp), intent(in) :: ql, qi, ql_crit
        real(dp) :: cf, q_total
        q_total = ql + qi
        if (q_total > ql_crit) then
            cf = 1.0_dp - exp(-(q_total / ql_crit)**2)
        else
            cf = 0.0_dp
        end if
    end function fracao_nuvem_conteudo
    
    subroutine fracao_nuvem_3d(RH, ql, qi, cf)
        real(dp), intent(in) :: RH(:,:,:), ql(:,:,:), qi(:,:,:)
        real(dp), intent(out) :: cf(:,:,:)
        integer :: i, j, k
        real(dp) :: RH_crit, ql_crit
        
        RH_crit = 0.8_dp
        ql_crit = 1.0e-5_dp
        
        do k = 1, size(RH, 3)
            do j = 1, size(RH, 2)
                do i = 1, size(RH, 1)
                    cf(i,j,k) = max(fracao_nuvem_diagnostica(RH(i,j,k), RH_crit), &
                                    fracao_nuvem_conteudo(ql(i,j,k), qi(i,j,k), ql_crit))
                end do
            end do
        end do
    end subroutine fracao_nuvem_3d

end module mod33_fracao_nuvens
