!===============================================================================
! Módulo 01: Constantes Físicas Fundamentais
! Autor: Luiz Tiago Wilcke
! Descrição: Define todas as constantes físicas fundamentais usadas no modelo
!            climático, incluindo constantes universais, atmosféricas e oceânicas.
!===============================================================================

module mod01_constantes_fisicas
    implicit none
    
    ! Precisão dupla para todos os cálculos
    integer, parameter :: dp = selected_real_kind(15, 307)
    
    !---------------------------------------------------------------------------
    ! Constantes Universais
    !---------------------------------------------------------------------------
    real(dp), parameter :: PI = 3.14159265358979323846_dp
    real(dp), parameter :: CONSTANTE_GRAVITACIONAL = 6.67430e-11_dp      ! m³/(kg·s²)
    real(dp), parameter :: CONSTANTE_BOLTZMANN = 1.380649e-23_dp         ! J/K
    real(dp), parameter :: CONSTANTE_AVOGADRO = 6.02214076e23_dp         ! mol⁻¹
    real(dp), parameter :: CONSTANTE_GAS_UNIVERSAL = 8.314462618_dp      ! J/(mol·K)
    real(dp), parameter :: CONSTANTE_PLANCK = 6.62607015e-34_dp          ! J·s
    real(dp), parameter :: VELOCIDADE_LUZ = 2.99792458e8_dp              ! m/s
    real(dp), parameter :: CONSTANTE_STEFAN_BOLTZMANN = 5.670374419e-8_dp ! W/(m²·K⁴)
    
    !---------------------------------------------------------------------------
    ! Constantes da Terra
    !---------------------------------------------------------------------------
    real(dp), parameter :: RAIO_TERRA = 6.371e6_dp                       ! m
    real(dp), parameter :: MASSA_TERRA = 5.972e24_dp                     ! kg
    real(dp), parameter :: GRAVIDADE_SUPERFICIE = 9.80665_dp             ! m/s²
    real(dp), parameter :: VELOCIDADE_ANGULAR_TERRA = 7.2921159e-5_dp    ! rad/s
    real(dp), parameter :: OBLIQUIDADE_ECLIPTICA = 23.44_dp              ! graus
    real(dp), parameter :: DISTANCIA_SOL = 1.496e11_dp                   ! m
    real(dp), parameter :: CONSTANTE_SOLAR = 1361.0_dp                   ! W/m²
    
    !---------------------------------------------------------------------------
    ! Constantes Atmosféricas
    !---------------------------------------------------------------------------
    real(dp), parameter :: PRESSAO_SUPERFICIE_MEDIA = 101325.0_dp        ! Pa
    real(dp), parameter :: TEMPERATURA_SUPERFICIE_MEDIA = 288.15_dp      ! K (15°C)
    real(dp), parameter :: MASSA_MOLAR_AR_SECO = 28.9647e-3_dp          ! kg/mol
    real(dp), parameter :: MASSA_MOLAR_VAPOR_AGUA = 18.01528e-3_dp      ! kg/mol
    real(dp), parameter :: CONSTANTE_GAS_AR_SECO = 287.058_dp           ! J/(kg·K)
    real(dp), parameter :: CONSTANTE_GAS_VAPOR = 461.5_dp               ! J/(kg·K)
    real(dp), parameter :: CP_AR_SECO = 1005.0_dp                       ! J/(kg·K)
    real(dp), parameter :: CV_AR_SECO = 718.0_dp                        ! J/(kg·K)
    real(dp), parameter :: CP_VAPOR = 1870.0_dp                         ! J/(kg·K)
    real(dp), parameter :: GAMMA_AR = 1.4_dp                            ! Cp/Cv
    real(dp), parameter :: KAPPA_AR = 0.286_dp                          ! R/Cp
    
    !---------------------------------------------------------------------------
    ! Constantes de Água e Mudança de Fase
    !---------------------------------------------------------------------------
    real(dp), parameter :: DENSIDADE_AGUA = 1000.0_dp                    ! kg/m³
    real(dp), parameter :: CALOR_LATENTE_VAPORIZACAO = 2.501e6_dp       ! J/kg (0°C)
    real(dp), parameter :: CALOR_LATENTE_FUSAO = 3.34e5_dp              ! J/kg
    real(dp), parameter :: CALOR_LATENTE_SUBLIMACAO = 2.834e6_dp        ! J/kg
    real(dp), parameter :: CP_AGUA_LIQUIDA = 4186.0_dp                  ! J/(kg·K)
    real(dp), parameter :: CP_GELO = 2090.0_dp                          ! J/(kg·K)
    real(dp), parameter :: TEMPERATURA_FUSAO = 273.15_dp                ! K
    real(dp), parameter :: TEMPERATURA_EBULICAO = 373.15_dp             ! K
    real(dp), parameter :: PRESSAO_TRIPLO = 611.657_dp                  ! Pa
    real(dp), parameter :: TEMPERATURA_TRIPLO = 273.16_dp               ! K
    
    !---------------------------------------------------------------------------
    ! Constantes Oceânicas
    !---------------------------------------------------------------------------
    real(dp), parameter :: DENSIDADE_AGUA_MAR = 1025.0_dp               ! kg/m³
    real(dp), parameter :: SALINIDADE_MEDIA = 35.0_dp                   ! psu
    real(dp), parameter :: CP_AGUA_MAR = 3993.0_dp                      ! J/(kg·K)
    real(dp), parameter :: PROFUNDIDADE_MEDIA_OCEANO = 3688.0_dp        ! m
    real(dp), parameter :: COEF_EXPANSAO_TERMICA = 2.0e-4_dp            ! K⁻¹
    real(dp), parameter :: COEF_CONTRACAO_HALINA = 7.6e-4_dp            ! psu⁻¹
    
    !---------------------------------------------------------------------------
    ! Constantes de Radiação
    !---------------------------------------------------------------------------
    real(dp), parameter :: ALBEDO_MEDIO_TERRA = 0.30_dp                 ! adimensional
    real(dp), parameter :: EMISSIVIDADE_SUPERFICIE = 0.95_dp            ! adimensional
    real(dp), parameter :: TEMPERATURA_EFETIVA_SOL = 5778.0_dp          ! K
    
    !---------------------------------------------------------------------------
    ! Constantes de Gelo e Neve
    !---------------------------------------------------------------------------
    real(dp), parameter :: DENSIDADE_GELO = 917.0_dp                    ! kg/m³
    real(dp), parameter :: DENSIDADE_NEVE = 300.0_dp                    ! kg/m³ (média)
    real(dp), parameter :: CONDUTIVIDADE_GELO = 2.22_dp                 ! W/(m·K)
    real(dp), parameter :: ALBEDO_GELO = 0.60_dp                        ! adimensional
    real(dp), parameter :: ALBEDO_NEVE = 0.85_dp                        ! adimensional
    
    !---------------------------------------------------------------------------
    ! Constantes de Gases de Efeito Estufa (concentrações pré-industriais)
    !---------------------------------------------------------------------------
    real(dp), parameter :: CO2_PRE_INDUSTRIAL = 280.0_dp                ! ppm
    real(dp), parameter :: CH4_PRE_INDUSTRIAL = 722.0_dp                ! ppb
    real(dp), parameter :: N2O_PRE_INDUSTRIAL = 270.0_dp                ! ppb
    
    !---------------------------------------------------------------------------
    ! Constantes Numéricas
    !---------------------------------------------------------------------------
    real(dp), parameter :: EPSILON_NUMERICO = 1.0e-10_dp
    real(dp), parameter :: INFINITO = 1.0e30_dp
    
contains

    !---------------------------------------------------------------------------
    ! Função para converter graus para radianos
    !---------------------------------------------------------------------------
    pure function graus_para_radianos(graus) result(radianos)
        real(dp), intent(in) :: graus
        real(dp) :: radianos
        radianos = graus * PI / 180.0_dp
    end function graus_para_radianos
    
    !---------------------------------------------------------------------------
    ! Função para converter radianos para graus
    !---------------------------------------------------------------------------
    pure function radianos_para_graus(radianos) result(graus)
        real(dp), intent(in) :: radianos
        real(dp) :: graus
        graus = radianos * 180.0_dp / PI
    end function radianos_para_graus
    
    !---------------------------------------------------------------------------
    ! Função para converter Celsius para Kelvin
    !---------------------------------------------------------------------------
    pure function celsius_para_kelvin(celsius) result(kelvin)
        real(dp), intent(in) :: celsius
        real(dp) :: kelvin
        kelvin = celsius + 273.15_dp
    end function celsius_para_kelvin
    
    !---------------------------------------------------------------------------
    ! Função para converter Kelvin para Celsius
    !---------------------------------------------------------------------------
    pure function kelvin_para_celsius(kelvin) result(celsius)
        real(dp), intent(in) :: kelvin
        real(dp) :: celsius
        celsius = kelvin - 273.15_dp
    end function kelvin_para_celsius

end module mod01_constantes_fisicas
