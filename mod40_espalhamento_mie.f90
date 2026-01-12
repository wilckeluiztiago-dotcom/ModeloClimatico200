!===============================================================================
! Módulo 40: Espalhamento Mie
! Autor: Luiz Tiago Wilcke
! Descrição: Espalhamento Mie por aerossóis e partículas.
!===============================================================================

module mod40_espalhamento_mie
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function parametro_tamanho(raio, lambda) result(x)
        real(dp), intent(in) :: raio, lambda
        real(dp) :: x
        x = 2.0_dp * PI * raio / lambda
    end function parametro_tamanho
    
    function eficiencia_extincao_mie(x, m_real, m_imag) result(Q_ext)
        real(dp), intent(in) :: x, m_real, m_imag
        real(dp) :: Q_ext
        
        if (x < 0.01_dp) then
            Q_ext = 0.0_dp
        else if (x < 1.0_dp) then
            Q_ext = 4.0_dp * x * ((m_real**2 - 1.0_dp) / (m_real**2 + 2.0_dp))
        else if (x < 10.0_dp) then
            Q_ext = 2.0_dp + 4.0_dp * sin(2.0_dp * x) / x
        else
            Q_ext = 2.0_dp
        end if
    end function eficiencia_extincao_mie
    
    function espessura_optica_aerossol(N, r, Q_ext, dz) result(tau)
        real(dp), intent(in) :: N, r, Q_ext, dz
        real(dp) :: tau
        tau = N * PI * r**2 * Q_ext * dz
    end function espessura_optica_aerossol
    
    pure function fator_assimetria(x) result(g)
        real(dp), intent(in) :: x
        real(dp) :: g
        g = min(0.9_dp, 0.8_dp * (1.0_dp - exp(-x / 10.0_dp)))
    end function fator_assimetria

end module mod40_espalhamento_mie
