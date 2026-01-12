!===============================================================================
! Módulo 34: Tipos de Nuvens
! Autor: Luiz Tiago Wilcke
! Descrição: Classificação de tipos de nuvens.
!===============================================================================

module mod34_tipos_nuvens
    use mod01_constantes_fisicas
    implicit none
    
    integer, parameter :: NUVEM_NENHUMA = 0
    integer, parameter :: NUVEM_CIRRUS = 1
    integer, parameter :: NUVEM_CIRROSTRATUS = 2
    integer, parameter :: NUVEM_ALTOCUMULUS = 3
    integer, parameter :: NUVEM_ALTOSTRATUS = 4
    integer, parameter :: NUVEM_STRATOCUMULUS = 5
    integer, parameter :: NUVEM_STRATUS = 6
    integer, parameter :: NUVEM_CUMULUS = 7
    integer, parameter :: NUVEM_CUMULONIMBUS = 8
    
contains

    function classificar_nuvem(z_base, z_topo, w_max, T_topo) result(tipo)
        real(dp), intent(in) :: z_base, z_topo, w_max, T_topo
        integer :: tipo
        real(dp) :: espessura
        
        espessura = z_topo - z_base
        
        if (z_base > 6000.0_dp) then
            if (T_topo < 233.0_dp) then
                tipo = NUVEM_CIRRUS
            else
                tipo = NUVEM_CIRROSTRATUS
            end if
        else if (z_base > 2000.0_dp) then
            if (espessura > 3000.0_dp) then
                tipo = NUVEM_ALTOSTRATUS
            else
                tipo = NUVEM_ALTOCUMULUS
            end if
        else
            if (w_max > 5.0_dp .and. z_topo > 10000.0_dp) then
                tipo = NUVEM_CUMULONIMBUS
            else if (w_max > 2.0_dp) then
                tipo = NUVEM_CUMULUS
            else if (espessura < 500.0_dp) then
                tipo = NUVEM_STRATUS
            else
                tipo = NUVEM_STRATOCUMULUS
            end if
        end if
    end function classificar_nuvem
    
    function albedo_nuvem(tipo, espessura_optica) result(albedo)
        integer, intent(in) :: tipo
        real(dp), intent(in) :: espessura_optica
        real(dp) :: albedo
        
        select case (tipo)
            case (NUVEM_CIRRUS, NUVEM_CIRROSTRATUS)
                albedo = 0.2_dp + 0.1_dp * min(espessura_optica / 5.0_dp, 1.0_dp)
            case (NUVEM_CUMULONIMBUS)
                albedo = 0.7_dp + 0.2_dp * min(espessura_optica / 50.0_dp, 1.0_dp)
            case default
                albedo = 0.4_dp + 0.3_dp * min(espessura_optica / 20.0_dp, 1.0_dp)
        end select
    end function albedo_nuvem

end module mod34_tipos_nuvens
