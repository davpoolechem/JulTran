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
  !$OMP PARALLEL SHARED(i) NUM_THREADS(4)
  !$OMP DO SCHEDULE(STATIC)
  DO i = 1,OMP_GET_NUM_THREADS()
      print *, "Hello from Fortran thread ", OMP_GET_THREAD_NUM()
  END DO
  !$OMP END DO
  !$OMP END PARALLEL

  hello_fortran = 0
  return
end
