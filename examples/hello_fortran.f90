FUNCTION hello_fortran()
    INTEGER ::    i 

    !$OMP PARALLEL DO SCHEDULE(STATIC) PRIVATE(i) NUM_THREADS(4)
    DO i = 1, OMP_GET_NUM_THREADS(), 1 
        !$OMP CRITICAL
        PRINT *, "Hello from thread ",OMP_GET_THREAD_NUM()
        !$OMP END CRITICAL
    END DO
    !$END OMP PARALLEL DO
end

