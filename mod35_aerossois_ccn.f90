!===============================================================================
! Módulo 35: Aerossóis e CCN
! Autor: Luiz Tiago Wilcke
! Descrição: Aerossóis e núcleos de condensação de nuvens.
!===============================================================================

module mod35_aerossois_ccn
    use mod01_constantes_fisicas
    implicit none
    
    real(dp), parameter :: CCN_MARITIMO = 100.0e6_dp
    real(dp), parameter :: CCN_CONTINENTAL = 1000.0e6_dp
    
contains

    function concentracao_ccn_ativo(S, tipo_regiao) result(N_ccn)
        real(dp), intent(in) :: S
        integer, intent(in) :: tipo_regiao
        real(dp) :: N_ccn
        real(dp) :: C, k
        
        if (tipo_regiao == 0) then
            C = CCN_MARITIMO
            k = 0.7_dp
        else
            C = CCN_CONTINENTAL
            k = 0.5_dp
        end if
        
        N_ccn = C * (S * 100.0_dp)**k
    end function concentracao_ccn_ativo
    
    function raio_efetivo_gota(ql, N_gotas) result(r_eff)
        real(dp), intent(in) :: ql, N_gotas
        real(dp) :: r_eff
        real(dp) :: k_eff
        
        k_eff = 0.8_dp
        if (N_gotas > 0.0_dp .and. ql > 0.0_dp) then
            r_eff = (3.0_dp * ql / (4.0_dp * PI * DENSIDADE_AGUA * N_gotas * k_eff))**(1.0_dp/3.0_dp)
            r_eff = max(r_eff, 2.0e-6_dp)
            r_eff = min(r_eff, 50.0e-6_dp)
        else
            r_eff = 10.0e-6_dp
        end if
    end function raio_efetivo_gota
    
    function efeito_indireto_aerossol(N_ccn_ref, N_ccn_atual, albedo_ref) result(delta_albedo)
        real(dp), intent(in) :: N_ccn_ref, N_ccn_atual, albedo_ref
        real(dp) :: delta_albedo
        delta_albedo = 0.07_dp * log(N_ccn_atual / N_ccn_ref) * (1.0_dp - albedo_ref)
    end function efeito_indireto_aerossol

end module mod35_aerossois_ccn
