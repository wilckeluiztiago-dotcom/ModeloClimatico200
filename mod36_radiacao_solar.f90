!===============================================================================
! Módulo 36: Radiação Solar
! Autor: Luiz Tiago Wilcke
! Descrição: Radiação solar incidente no topo da atmosfera.
!===============================================================================

module mod36_radiacao_solar
    use mod01_constantes_fisicas
    use mod02_parametros_planeta
    implicit none
    
contains

    function radiacao_toa(dia_ano, lat, hora) result(S)
        real(dp), intent(in) :: dia_ano, lat, hora
        real(dp) :: S
        real(dp) :: dec, h_ang, cos_zen, S0_corr
        
        S0_corr = calcular_irradiancia_toa(dia_ano)
        dec = calcular_declinacao_solar(dia_ano)
        h_ang = (hora - 12.0_dp) * PI / 12.0_dp
        
        cos_zen = sin(graus_para_radianos(lat)) * sin(dec) + &
                  cos(graus_para_radianos(lat)) * cos(dec) * cos(h_ang)
        
        S = S0_corr * max(0.0_dp, cos_zen)
    end function radiacao_toa
    
    subroutine radiacao_toa_media_diaria(dia_ano, lat, S_med)
        real(dp), intent(in) :: dia_ano
        real(dp), intent(in) :: lat(:)
        real(dp), intent(out) :: S_med(:)
        integer :: i, n
        real(dp) :: dec, lat_rad, H0, cos_zen_med, S0_corr
        
        n = size(lat)
        S0_corr = calcular_irradiancia_toa(dia_ano)
        dec = calcular_declinacao_solar(dia_ano)
        
        do i = 1, n
            lat_rad = graus_para_radianos(lat(i))
            cos_zen_med = -tan(lat_rad) * tan(dec)
            
            if (cos_zen_med <= -1.0_dp) then
                H0 = PI
            else if (cos_zen_med >= 1.0_dp) then
                H0 = 0.0_dp
            else
                H0 = acos(cos_zen_med)
            end if
            
            S_med(i) = (S0_corr / PI) * (H0 * sin(lat_rad) * sin(dec) + &
                       cos(lat_rad) * cos(dec) * sin(H0))
            S_med(i) = max(0.0_dp, S_med(i))
        end do
    end subroutine radiacao_toa_media_diaria

end module mod36_radiacao_solar
