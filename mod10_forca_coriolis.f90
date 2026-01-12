!===============================================================================
! Módulo 10: Força de Coriolis
! Autor: Luiz Tiago Wilcke
! Descrição: Cálculo da força de Coriolis e efeitos rotacionais.
!===============================================================================

module mod10_forca_coriolis
    use mod01_constantes_fisicas
    use mod02_parametros_planeta
    use mod03_grade_espacial
    implicit none
    
contains

    subroutine aplicar_coriolis(u, v, latitude_graus, du_coriolis, dv_coriolis)
        real(dp), intent(in) :: u(:,:,:), v(:,:,:), latitude_graus(:)
        real(dp), intent(out) :: du_coriolis(:,:,:), dv_coriolis(:,:,:)
        integer :: i, j, k, ni, nj, nk
        real(dp) :: f
        
        ni = size(u, 1)
        nj = size(u, 2)
        nk = size(u, 3)
        
        do k = 1, nk
            do j = 1, nj
                do i = 1, ni
                    f = calcular_parametro_coriolis(latitude_graus(i))
                    du_coriolis(i,j,k) = f * v(i,j,k)
                    dv_coriolis(i,j,k) = -f * u(i,j,k)
                end do
            end do
        end do
    end subroutine aplicar_coriolis
    
    function calcular_numero_rossby(U, L, lat) result(Ro)
        real(dp), intent(in) :: U, L, lat
        real(dp) :: Ro, f
        f = abs(calcular_parametro_coriolis(lat))
        if (f > EPSILON_NUMERICO) then
            Ro = U / (f * L)
        else
            Ro = INFINITO
        end if
    end function calcular_numero_rossby
    
    function calcular_raio_deformacao_rossby(N, H, lat) result(Ld)
        real(dp), intent(in) :: N, H, lat
        real(dp) :: Ld, f
        f = abs(calcular_parametro_coriolis(lat))
        if (f > EPSILON_NUMERICO) then
            Ld = N * H / f
        else
            Ld = INFINITO
        end if
    end function calcular_raio_deformacao_rossby

end module mod10_forca_coriolis
