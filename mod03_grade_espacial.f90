!===============================================================================
! Módulo 03: Grade Espacial
! Autor: Luiz Tiago Wilcke
! Descrição: Grade espacial 3D (lat/lon/altitude) para o modelo climático.
!===============================================================================

module mod03_grade_espacial
    use mod01_constantes_fisicas
    use mod02_parametros_planeta
    implicit none
    
    integer, parameter :: NUM_LAT = 90, NUM_LON = 180
    integer, parameter :: NUM_NIVEIS_ATM = 30, NUM_NIVEIS_OCEANO = 20
    
    real(dp), parameter :: LAT_MIN = -90.0_dp, LAT_MAX = 90.0_dp
    real(dp), parameter :: LON_MIN = -180.0_dp, LON_MAX = 180.0_dp
    
    real(dp), allocatable :: latitude(:), longitude(:)
    real(dp), allocatable :: nivel_atm(:), altitude_atm(:)
    real(dp), allocatable :: area_celula(:,:), peso_latitude(:)
    integer, allocatable :: mascara_terra_oceano(:,:)
    real(dp) :: delta_lat, delta_lon
    logical :: grade_inicializada = .false.
    
contains

    subroutine inicializar_grade()
        integer :: i, j
        real(dp) :: lat_rad, sigma, p_topo, p_sup, H_escala
        
        if (grade_inicializada) return
        
        allocate(latitude(NUM_LAT), longitude(NUM_LON))
        allocate(nivel_atm(NUM_NIVEIS_ATM), altitude_atm(NUM_NIVEIS_ATM))
        allocate(area_celula(NUM_LAT, NUM_LON), peso_latitude(NUM_LAT))
        allocate(mascara_terra_oceano(NUM_LAT, NUM_LON))
        
        delta_lat = (LAT_MAX - LAT_MIN) / real(NUM_LAT, dp)
        delta_lon = (LON_MAX - LON_MIN) / real(NUM_LON, dp)
        
        do i = 1, NUM_LAT
            latitude(i) = LAT_MIN + (real(i, dp) - 0.5_dp) * delta_lat
        end do
        do j = 1, NUM_LON
            longitude(j) = LON_MIN + (real(j, dp) - 0.5_dp) * delta_lon
        end do
        
        p_sup = PRESSAO_SUPERFICIE_MEDIA
        p_topo = 1.0_dp
        H_escala = CONSTANTE_GAS_AR_SECO * TEMPERATURA_SUPERFICIE_MEDIA / GRAVIDADE_SUPERFICIE
        
        do i = 1, NUM_NIVEIS_ATM
            sigma = 1.0_dp - real(i-1, dp) / real(NUM_NIVEIS_ATM-1, dp)
            nivel_atm(i) = p_topo * exp(log(p_sup/p_topo) * sigma)
            altitude_atm(i) = -H_escala * log(nivel_atm(i) / p_sup)
        end do
        
        do i = 1, NUM_LAT
            lat_rad = graus_para_radianos(latitude(i))
            peso_latitude(i) = cos(lat_rad)
            do j = 1, NUM_LON
                area_celula(i,j) = RAIO_TERRA**2 * abs(sin(graus_para_radianos(latitude(i)+delta_lat/2)) &
                                 - sin(graus_para_radianos(latitude(i)-delta_lat/2))) * graus_para_radianos(delta_lon)
            end do
        end do
        peso_latitude = peso_latitude / sum(peso_latitude)
        
        mascara_terra_oceano = 0
        call gerar_mascara_continentes()
        grade_inicializada = .true.
    end subroutine inicializar_grade
    
    subroutine gerar_mascara_continentes()
        integer :: i, j
        real(dp) :: lat, lon
        do i = 1, NUM_LAT
            lat = latitude(i)
            do j = 1, NUM_LON
                lon = longitude(j)
                if (lat >= -55 .and. lat <= 10 .and. lon >= -80 .and. lon <= -35) mascara_terra_oceano(i,j) = 1
                if (lat >= 15 .and. lat <= 70 .and. lon >= -170 .and. lon <= -55) mascara_terra_oceano(i,j) = 1
                if (lat >= 35 .and. lat <= 70 .and. lon >= -10 .and. lon <= 60) mascara_terra_oceano(i,j) = 1
                if (lat >= -35 .and. lat <= 35 .and. lon >= -20 .and. lon <= 50) mascara_terra_oceano(i,j) = 1
                if (lat >= 5 .and. lat <= 75 .and. lon >= 60 .and. lon <= 180) mascara_terra_oceano(i,j) = 1
                if (lat >= -45 .and. lat <= -10 .and. lon >= 110 .and. lon <= 155) mascara_terra_oceano(i,j) = 1
                if (lat <= -60) mascara_terra_oceano(i,j) = 1
            end do
        end do
    end subroutine gerar_mascara_continentes
    
    subroutine finalizar_grade()
        if (allocated(latitude)) deallocate(latitude)
        if (allocated(longitude)) deallocate(longitude)
        if (allocated(nivel_atm)) deallocate(nivel_atm)
        if (allocated(altitude_atm)) deallocate(altitude_atm)
        if (allocated(area_celula)) deallocate(area_celula)
        if (allocated(peso_latitude)) deallocate(peso_latitude)
        if (allocated(mascara_terra_oceano)) deallocate(mascara_terra_oceano)
        grade_inicializada = .false.
    end subroutine finalizar_grade

end module mod03_grade_espacial
