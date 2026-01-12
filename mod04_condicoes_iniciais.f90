!===============================================================================
! Módulo 04: Condições Iniciais
! Autor: Luiz Tiago Wilcke
! Descrição: Define o estado inicial da atmosfera e oceano para a simulação.
!===============================================================================

module mod04_condicoes_iniciais
    use mod01_constantes_fisicas
    use mod03_grade_espacial
    implicit none
    
    real(dp), allocatable :: temperatura_inicial(:,:,:)
    real(dp), allocatable :: umidade_inicial(:,:,:)
    real(dp), allocatable :: pressao_inicial(:,:)
    real(dp), allocatable :: vento_u_inicial(:,:,:)
    real(dp), allocatable :: vento_v_inicial(:,:,:)
    real(dp), allocatable :: temp_oceano_inicial(:,:,:)
    
contains

    subroutine inicializar_condicoes()
        integer :: i, j, k
        real(dp) :: lat, T_eq, delta_T, lapse_rate
        
        allocate(temperatura_inicial(NUM_LAT, NUM_LON, NUM_NIVEIS_ATM))
        allocate(umidade_inicial(NUM_LAT, NUM_LON, NUM_NIVEIS_ATM))
        allocate(pressao_inicial(NUM_LAT, NUM_LON))
        allocate(vento_u_inicial(NUM_LAT, NUM_LON, NUM_NIVEIS_ATM))
        allocate(vento_v_inicial(NUM_LAT, NUM_LON, NUM_NIVEIS_ATM))
        allocate(temp_oceano_inicial(NUM_LAT, NUM_LON, NUM_NIVEIS_OCEANO))
        
        T_eq = 300.0_dp
        delta_T = 50.0_dp
        lapse_rate = 6.5e-3_dp
        
        do i = 1, NUM_LAT
            lat = latitude(i)
            do j = 1, NUM_LON
                pressao_inicial(i,j) = PRESSAO_SUPERFICIE_MEDIA
                do k = 1, NUM_NIVEIS_ATM
                    temperatura_inicial(i,j,k) = T_eq - delta_T * (lat/90.0_dp)**2 &
                                                - lapse_rate * altitude_atm(k)
                    temperatura_inicial(i,j,k) = max(temperatura_inicial(i,j,k), 200.0_dp)
                    umidade_inicial(i,j,k) = 0.01_dp * exp(-altitude_atm(k)/8000.0_dp)
                    vento_u_inicial(i,j,k) = 10.0_dp * sin(graus_para_radianos(lat) * 3.0_dp)
                    vento_v_inicial(i,j,k) = 0.0_dp
                end do
                do k = 1, NUM_NIVEIS_OCEANO
                    temp_oceano_inicial(i,j,k) = T_eq - delta_T * (lat/90.0_dp)**2 - 15.0_dp
                end do
            end do
        end do
    end subroutine inicializar_condicoes
    
    subroutine finalizar_condicoes()
        if (allocated(temperatura_inicial)) deallocate(temperatura_inicial)
        if (allocated(umidade_inicial)) deallocate(umidade_inicial)
        if (allocated(pressao_inicial)) deallocate(pressao_inicial)
        if (allocated(vento_u_inicial)) deallocate(vento_u_inicial)
        if (allocated(vento_v_inicial)) deallocate(vento_v_inicial)
        if (allocated(temp_oceano_inicial)) deallocate(temp_oceano_inicial)
    end subroutine finalizar_condicoes

end module mod04_condicoes_iniciais
