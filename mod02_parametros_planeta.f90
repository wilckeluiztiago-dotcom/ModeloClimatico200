!===============================================================================
! Módulo 02: Parâmetros do Planeta Terra
! Autor: Luiz Tiago Wilcke
! Descrição: Define parâmetros geométricos, orbitais e geográficos do planeta
!            Terra para uso no modelo climático.
!===============================================================================

module mod02_parametros_planeta
    use mod01_constantes_fisicas
    implicit none
    
    !---------------------------------------------------------------------------
    ! Parâmetros Geométricos
    !---------------------------------------------------------------------------
    real(dp), parameter :: RAIO_EQUATORIAL = 6.378137e6_dp          ! m
    real(dp), parameter :: RAIO_POLAR = 6.356752e6_dp               ! m
    real(dp), parameter :: ACHATAMENTO = 1.0_dp/298.257223563_dp    ! adimensional
    real(dp), parameter :: AREA_SUPERFICIE_TERRA = 5.1e14_dp        ! m²
    real(dp), parameter :: AREA_OCEANOS = 3.61e14_dp                ! m²
    real(dp), parameter :: AREA_CONTINENTES = 1.49e14_dp            ! m²
    real(dp), parameter :: FRACAO_OCEANO = 0.708_dp                 ! adimensional
    
    !---------------------------------------------------------------------------
    ! Parâmetros Orbitais
    !---------------------------------------------------------------------------
    real(dp), parameter :: SEMI_EIXO_MAIOR = 1.49598023e11_dp       ! m
    real(dp), parameter :: EXCENTRICIDADE_ORBITAL = 0.0167086_dp    ! adimensional
    real(dp), parameter :: PERIODO_ORBITAL = 365.25636_dp           ! dias
    real(dp), parameter :: PERIODO_ROTACAO = 86164.1_dp             ! segundos (dia sideral)
    real(dp), parameter :: INCLINACAO_AXIAL = 23.4392911_dp         ! graus
    real(dp), parameter :: LONGITUDE_PERIHELIO = 102.94719_dp       ! graus
    
    !---------------------------------------------------------------------------
    ! Parâmetros de Milankovich
    !---------------------------------------------------------------------------
    real(dp), parameter :: OBLIQUIDADE_MIN = 22.1_dp                ! graus
    real(dp), parameter :: OBLIQUIDADE_MAX = 24.5_dp                ! graus
    real(dp), parameter :: PERIODO_OBLIQUIDADE = 41000.0_dp         ! anos
    real(dp), parameter :: PERIODO_PRECESSAO = 26000.0_dp           ! anos
    real(dp), parameter :: PERIODO_EXCENTRICIDADE = 100000.0_dp     ! anos
    
    !---------------------------------------------------------------------------
    ! Zonas Climáticas (latitudes em graus)
    !---------------------------------------------------------------------------
    real(dp), parameter :: LAT_TROPICO_CANCER = 23.4392911_dp       ! graus N
    real(dp), parameter :: LAT_TROPICO_CAPRICORNIO = -23.4392911_dp ! graus S
    real(dp), parameter :: LAT_CIRCULO_ARTICO = 66.5607089_dp       ! graus N
    real(dp), parameter :: LAT_CIRCULO_ANTARTICO = -66.5607089_dp   ! graus S
    
    !---------------------------------------------------------------------------
    ! Estrutura para Posição Orbital
    !---------------------------------------------------------------------------
    type :: posicao_orbital_tipo
        real(dp) :: dia_do_ano          ! Dia juliano (1-365)
        real(dp) :: distancia_sol       ! Distância ao Sol (m)
        real(dp) :: declinacao_solar    ! Declinação solar (radianos)
        real(dp) :: equacao_tempo       ! Equação do tempo (segundos)
        real(dp) :: angulo_horario      ! Ângulo horário (radianos)
    end type posicao_orbital_tipo
    
contains

    !---------------------------------------------------------------------------
    ! Calcula a distância Terra-Sol para um dia do ano
    ! Usa a aproximação elíptica
    !---------------------------------------------------------------------------
    pure function calcular_distancia_sol(dia_do_ano) result(distancia)
        real(dp), intent(in) :: dia_do_ano
        real(dp) :: distancia
        real(dp) :: angulo_medio
        
        ! Ângulo médio orbital
        angulo_medio = 2.0_dp * PI * (dia_do_ano - 1.0_dp) / 365.25_dp
        
        ! Distância aproximada usando série de Fourier truncada
        distancia = SEMI_EIXO_MAIOR * (1.0_dp - EXCENTRICIDADE_ORBITAL * &
                    cos(angulo_medio - graus_para_radianos(LONGITUDE_PERIHELIO)))
    end function calcular_distancia_sol
    
    !---------------------------------------------------------------------------
    ! Calcula a declinação solar para um dia do ano
    ! Retorna em radianos
    !---------------------------------------------------------------------------
    pure function calcular_declinacao_solar(dia_do_ano) result(declinacao)
        real(dp), intent(in) :: dia_do_ano
        real(dp) :: declinacao
        real(dp) :: angulo_dia
        
        ! Ângulo do dia no ciclo anual
        angulo_dia = 2.0_dp * PI * (dia_do_ano + 10.0_dp) / 365.25_dp
        
        ! Declinação solar
        declinacao = -graus_para_radianos(INCLINACAO_AXIAL) * cos(angulo_dia)
    end function calcular_declinacao_solar
    
    !---------------------------------------------------------------------------
    ! Calcula a irradiância solar no topo da atmosfera
    ! Considera a variação da distância Terra-Sol
    !---------------------------------------------------------------------------
    pure function calcular_irradiancia_toa(dia_do_ano) result(irradiancia)
        real(dp), intent(in) :: dia_do_ano
        real(dp) :: irradiancia
        real(dp) :: distancia
        
        distancia = calcular_distancia_sol(dia_do_ano)
        irradiancia = CONSTANTE_SOLAR * (DISTANCIA_SOL / distancia)**2
    end function calcular_irradiancia_toa
    
    !---------------------------------------------------------------------------
    ! Calcula o parâmetro de Coriolis para uma latitude
    ! f = 2 * Omega * sin(latitude)
    !---------------------------------------------------------------------------
    pure function calcular_parametro_coriolis(latitude_graus) result(f)
        real(dp), intent(in) :: latitude_graus
        real(dp) :: f
        real(dp) :: latitude_rad
        
        latitude_rad = graus_para_radianos(latitude_graus)
        f = 2.0_dp * VELOCIDADE_ANGULAR_TERRA * sin(latitude_rad)
    end function calcular_parametro_coriolis
    
    !---------------------------------------------------------------------------
    ! Calcula o parâmetro beta de Rossby
    ! beta = df/dy = 2 * Omega * cos(latitude) / R
    !---------------------------------------------------------------------------
    pure function calcular_beta_rossby(latitude_graus) result(beta)
        real(dp), intent(in) :: latitude_graus
        real(dp) :: beta
        real(dp) :: latitude_rad
        
        latitude_rad = graus_para_radianos(latitude_graus)
        beta = 2.0_dp * VELOCIDADE_ANGULAR_TERRA * cos(latitude_rad) / RAIO_TERRA
    end function calcular_beta_rossby
    
    !---------------------------------------------------------------------------
    ! Calcula o ângulo zenital solar
    ! Depende da latitude, declinação e hora do dia
    !---------------------------------------------------------------------------
    pure function calcular_angulo_zenital(latitude_graus, declinacao, angulo_horario) &
                  result(zenital)
        real(dp), intent(in) :: latitude_graus
        real(dp), intent(in) :: declinacao      ! radianos
        real(dp), intent(in) :: angulo_horario  ! radianos
        real(dp) :: zenital
        real(dp) :: latitude_rad, cos_zenital
        
        latitude_rad = graus_para_radianos(latitude_graus)
        
        cos_zenital = sin(latitude_rad) * sin(declinacao) + &
                      cos(latitude_rad) * cos(declinacao) * cos(angulo_horario)
        
        ! Limitar entre -1 e 1
        cos_zenital = max(-1.0_dp, min(1.0_dp, cos_zenital))
        zenital = acos(cos_zenital)
    end function calcular_angulo_zenital
    
    !---------------------------------------------------------------------------
    ! Calcula a duração do dia em horas
    !---------------------------------------------------------------------------
    pure function calcular_duracao_dia(latitude_graus, dia_do_ano) result(duracao)
        real(dp), intent(in) :: latitude_graus
        real(dp), intent(in) :: dia_do_ano
        real(dp) :: duracao
        real(dp) :: latitude_rad, declinacao
        real(dp) :: cos_angulo_horario, angulo_horario
        
        latitude_rad = graus_para_radianos(latitude_graus)
        declinacao = calcular_declinacao_solar(dia_do_ano)
        
        ! Calcular ângulo horário do nascer/pôr do sol
        cos_angulo_horario = -tan(latitude_rad) * tan(declinacao)
        
        ! Verificar casos especiais (dia polar, noite polar)
        if (cos_angulo_horario <= -1.0_dp) then
            duracao = 24.0_dp  ! Sol de meia-noite
        else if (cos_angulo_horario >= 1.0_dp) then
            duracao = 0.0_dp   ! Noite polar
        else
            angulo_horario = acos(cos_angulo_horario)
            duracao = 24.0_dp * angulo_horario / PI
        end if
    end function calcular_duracao_dia
    
    !---------------------------------------------------------------------------
    ! Calcula a gravidade efetiva em função da latitude
    ! Considera rotação e achatamento da Terra
    !---------------------------------------------------------------------------
    pure function calcular_gravidade_local(latitude_graus) result(g_local)
        real(dp), intent(in) :: latitude_graus
        real(dp) :: g_local
        real(dp) :: latitude_rad, sin2, sin4
        
        latitude_rad = graus_para_radianos(latitude_graus)
        sin2 = sin(latitude_rad)**2
        sin4 = sin2**2
        
        ! Fórmula de Somigliana simplificada
        g_local = GRAVIDADE_SUPERFICIE * &
                  (1.0_dp + 5.2885e-3_dp * sin2 - 5.9e-6_dp * sin4)
    end function calcular_gravidade_local
    
    !---------------------------------------------------------------------------
    ! Retorna a posição orbital completa para um dia
    !---------------------------------------------------------------------------
    pure function obter_posicao_orbital(dia_do_ano) result(posicao)
        real(dp), intent(in) :: dia_do_ano
        type(posicao_orbital_tipo) :: posicao
        
        posicao%dia_do_ano = dia_do_ano
        posicao%distancia_sol = calcular_distancia_sol(dia_do_ano)
        posicao%declinacao_solar = calcular_declinacao_solar(dia_do_ano)
        posicao%equacao_tempo = 0.0_dp  ! Simplificado
        posicao%angulo_horario = 0.0_dp ! Meio-dia
    end function obter_posicao_orbital

end module mod02_parametros_planeta
