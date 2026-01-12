!===============================================================================
! Módulo 60: Uso do Solo
! Autor: Luiz Tiago Wilcke
! Descrição: Tipos de uso do solo e suas propriedades.
!===============================================================================

module mod60_uso_solo
    use mod01_constantes_fisicas
    implicit none
    
    integer, parameter :: USO_OCEANO = 0
    integer, parameter :: USO_FLORESTA = 1
    integer, parameter :: USO_AGRICULTURA = 2
    integer, parameter :: USO_PASTO = 3
    integer, parameter :: USO_URBANO = 4
    integer, parameter :: USO_DESERTO = 5
    integer, parameter :: USO_GELO = 6
    
contains

    function albedo_uso_solo(tipo) result(albedo)
        integer, intent(in) :: tipo
        real(dp) :: albedo
        select case (tipo)
            case (USO_OCEANO)
                albedo = 0.06_dp
            case (USO_FLORESTA)
                albedo = 0.15_dp
            case (USO_AGRICULTURA)
                albedo = 0.20_dp
            case (USO_PASTO)
                albedo = 0.25_dp
            case (USO_URBANO)
                albedo = 0.18_dp
            case (USO_DESERTO)
                albedo = 0.35_dp
            case (USO_GELO)
                albedo = 0.80_dp
            case default
                albedo = 0.20_dp
        end select
    end function albedo_uso_solo
    
    function rugosidade_uso_solo(tipo) result(z0)
        integer, intent(in) :: tipo
        real(dp) :: z0
        select case (tipo)
            case (USO_OCEANO)
                z0 = 0.0002_dp
            case (USO_FLORESTA)
                z0 = 2.0_dp
            case (USO_AGRICULTURA)
                z0 = 0.1_dp
            case (USO_PASTO)
                z0 = 0.05_dp
            case (USO_URBANO)
                z0 = 1.0_dp
            case (USO_DESERTO)
                z0 = 0.01_dp
            case (USO_GELO)
                z0 = 0.001_dp
            case default
                z0 = 0.1_dp
        end select
    end function rugosidade_uso_solo

end module mod60_uso_solo
