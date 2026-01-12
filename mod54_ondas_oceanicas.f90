!===============================================================================
! Módulo 54: Ondas Oceânicas
! Autor: Luiz Tiago Wilcke
! Descrição: Ondas de superfície e internas.
!===============================================================================

module mod54_ondas_oceanicas
    use mod01_constantes_fisicas
    implicit none
    
contains

    pure function velocidade_onda_superficie(lambda_onda, H) result(c)
        real(dp), intent(in) :: lambda_onda, H
        real(dp) :: c
        real(dp) :: k
        
        k = 2.0_dp * PI / lambda_onda
        
        if (k * H > PI) then
            c = sqrt(GRAVIDADE_SUPERFICIE / k)
        else
            c = sqrt(GRAVIDADE_SUPERFICIE * H)
        end if
    end function velocidade_onda_superficie
    
    function altura_onda_significativa(U10, fetch, duracao) result(Hs)
        real(dp), intent(in) :: U10, fetch, duracao
        real(dp) :: Hs
        real(dp) :: Hs_fetch, Hs_dur
        
        Hs_fetch = 0.0016_dp * sqrt(GRAVIDADE_SUPERFICIE * fetch) * (U10**2 / GRAVIDADE_SUPERFICIE)
        Hs_dur = 0.0051_dp * U10 * sqrt(duracao)
        Hs = min(Hs_fetch, Hs_dur)
    end function altura_onda_significativa
    
    pure function velocidade_onda_kelvin(c_int, lat) result(c_kelvin)
        real(dp), intent(in) :: c_int, lat
        real(dp) :: c_kelvin
        c_kelvin = c_int
    end function velocidade_onda_kelvin
    
    pure function velocidade_onda_rossby(c_int, lat, lambda) result(c_rossby)
        real(dp), intent(in) :: c_int, lat, lambda
        real(dp) :: c_rossby
        real(dp) :: beta, k
        
        beta = 2.0_dp * 7.292e-5_dp * cos(lat * PI / 180.0_dp) / RAIO_TERRA
        k = 2.0_dp * PI / lambda
        c_rossby = -beta / k**2
    end function velocidade_onda_rossby

end module mod54_ondas_oceanicas
