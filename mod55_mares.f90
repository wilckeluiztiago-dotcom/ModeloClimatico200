!===============================================================================
! Módulo 55: Marés
! Autor: Luiz Tiago Wilcke
! Descrição: Forças de maré lunar e solar.
!===============================================================================

module mod55_mares
    use mod01_constantes_fisicas
    implicit none
    
    real(dp), parameter :: MASSA_LUA = 7.342e22_dp
    real(dp), parameter :: DISTANCIA_LUA = 3.844e8_dp
    real(dp), parameter :: MASSA_SOL = 1.989e30_dp
    
contains

    pure function potencial_mare_lunar(lat, lon, fase_lua) result(phi)
        real(dp), intent(in) :: lat, lon, fase_lua
        real(dp) :: phi
        real(dp) :: P2, cos_theta
        
        cos_theta = cos(lat * PI / 180.0_dp) * cos((lon - fase_lua) * PI / 180.0_dp)
        P2 = 0.5_dp * (3.0_dp * cos_theta**2 - 1.0_dp)
        
        phi = CONSTANTE_GRAVITACIONAL * MASSA_LUA * RAIO_TERRA**2 * P2 / DISTANCIA_LUA**3
    end function potencial_mare_lunar
    
    pure function potencial_mare_solar(lat, lon, hora_solar) result(phi)
        real(dp), intent(in) :: lat, lon, hora_solar
        real(dp) :: phi
        real(dp) :: P2, cos_theta
        
        cos_theta = cos(lat * PI / 180.0_dp) * cos((lon + hora_solar * 15.0_dp) * PI / 180.0_dp)
        P2 = 0.5_dp * (3.0_dp * cos_theta**2 - 1.0_dp)
        
        phi = CONSTANTE_GRAVITACIONAL * MASSA_SOL * RAIO_TERRA**2 * P2 / DISTANCIA_SOL**3
    end function potencial_mare_solar
    
    function amplitude_mare(lat, lon, fase_lua, hora_solar) result(h)
        real(dp), intent(in) :: lat, lon, fase_lua, hora_solar
        real(dp) :: h
        real(dp) :: phi_lua, phi_sol
        
        phi_lua = potencial_mare_lunar(lat, lon, fase_lua)
        phi_sol = potencial_mare_solar(lat, lon, hora_solar)
        
        h = (phi_lua + phi_sol) / GRAVIDADE_SUPERFICIE
    end function amplitude_mare

end module mod55_mares
