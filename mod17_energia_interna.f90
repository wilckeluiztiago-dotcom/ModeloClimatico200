!===============================================================================
! Módulo 17: Energia Interna
! Autor: Luiz Tiago Wilcke
! Descrição: Balanço de energia interna da atmosfera.
!===============================================================================

module mod17_energia_interna
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
contains

    pure function energia_interna_ar(T, q) result(e_int)
        real(dp), intent(in) :: T, q
        real(dp) :: e_int, cv_efetivo
        cv_efetivo = CV_AR_SECO * (1.0_dp - q) + CP_VAPOR * q
        e_int = cv_efetivo * T
    end function energia_interna_ar
    
    subroutine balanco_energia(T, q, Q_rad, Q_lat, Q_sens, dT_dt)
        real(dp), intent(in) :: T(:,:,:), q(:,:,:)
        real(dp), intent(in) :: Q_rad(:,:,:), Q_lat(:,:,:), Q_sens(:,:,:)
        real(dp), intent(out) :: dT_dt(:,:,:)
        integer :: i, j, k
        real(dp) :: cp_efetivo
        
        do k = 1, size(T, 3)
            do j = 1, size(T, 2)
                do i = 1, size(T, 1)
                    cp_efetivo = CP_AR_SECO * (1.0_dp - q(i,j,k)) + CP_VAPOR * q(i,j,k)
                    dT_dt(i,j,k) = (Q_rad(i,j,k) + Q_lat(i,j,k) + Q_sens(i,j,k)) / cp_efetivo
                end do
            end do
        end do
    end subroutine balanco_energia
    
    pure function entalpia_ar(T, q) result(h)
        real(dp), intent(in) :: T, q
        real(dp) :: h
        h = CP_AR_SECO * T + q * (CALOR_LATENTE_VAPORIZACAO + (CP_VAPOR - CP_AGUA_LIQUIDA) * T)
    end function entalpia_ar

end module mod17_energia_interna
