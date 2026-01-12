!===============================================================================
! Módulo 43: Albedo de Superfície
! Autor: Luiz Tiago Wilcke
! Descrição: Albedo de diferentes superfícies.
!===============================================================================

module mod43_albedo_superficie
    use mod01_constantes_fisicas
    implicit none
    
    real(dp), parameter :: ALBEDO_OCEANO = 0.06_dp
    real(dp), parameter :: ALBEDO_FLORESTA = 0.15_dp
    real(dp), parameter :: ALBEDO_DESERTO = 0.35_dp
    real(dp), parameter :: ALBEDO_NEVE_FRESCA = 0.85_dp
    real(dp), parameter :: ALBEDO_NEVE_VELHA = 0.60_dp
    real(dp), parameter :: ALBEDO_GELO_MAR = 0.65_dp
    
contains

    function albedo_oceano_zenital(zen) result(albedo)
        real(dp), intent(in) :: zen
        real(dp) :: albedo
        real(dp) :: mu
        mu = max(0.01_dp, cos(zen))
        albedo = 0.026_dp / (mu**1.7_dp + 0.065_dp) + 0.15_dp * (mu - 0.1_dp) * (mu - 0.5_dp) * (mu - 1.0_dp)
        albedo = max(ALBEDO_OCEANO, min(0.5_dp, albedo))
    end function albedo_oceano_zenital
    
    function albedo_neve_temperatura(T) result(albedo)
        real(dp), intent(in) :: T
        real(dp) :: albedo
        if (T < 263.0_dp) then
            albedo = ALBEDO_NEVE_FRESCA
        else if (T < 273.0_dp) then
            albedo = ALBEDO_NEVE_FRESCA - (ALBEDO_NEVE_FRESCA - ALBEDO_NEVE_VELHA) * &
                     (T - 263.0_dp) / 10.0_dp
        else
            albedo = 0.3_dp
        end if
    end function albedo_neve_temperatura
    
    subroutine albedo_superficie_2d(tipo_sup, T_sup, albedo)
        integer, intent(in) :: tipo_sup(:,:)
        real(dp), intent(in) :: T_sup(:,:)
        real(dp), intent(out) :: albedo(:,:)
        integer :: i, j
        
        do j = 1, size(tipo_sup, 2)
            do i = 1, size(tipo_sup, 1)
                select case (tipo_sup(i,j))
                    case (0)
                        albedo(i,j) = ALBEDO_OCEANO
                    case (1)
                        albedo(i,j) = ALBEDO_FLORESTA
                    case (2)
                        albedo(i,j) = ALBEDO_DESERTO
                    case (3)
                        albedo(i,j) = albedo_neve_temperatura(T_sup(i,j))
                    case default
                        albedo(i,j) = 0.2_dp
                end select
            end do
        end do
    end subroutine albedo_superficie_2d

end module mod43_albedo_superficie
