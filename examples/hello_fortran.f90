integer function hello_fortran()
  !*************!
  !* set types *!
  !*************!
  implicit none

  integer :: i
  INTEGER :: OMP_GET_THREAD_NUM, OMP_GET_NUM_THREADS

  !***********************!
  !* perform calculation *!
  !***********************!
  !$OMP PARALLEL DO SCHEDULE(STATIC) PRIVATE(i) NUM_THREADS(4)
  DO i = 1,OMP_GET_NUM_THREADS()
      !OMP CRITICAL
        print *, "Hello from Fortran thread ", OMP_GET_THREAD_NUM()
      !OMP END CRITICAL
  END DO
  !$OMP END PARALLEL DO

  hello_fortran = 0
  return
end
