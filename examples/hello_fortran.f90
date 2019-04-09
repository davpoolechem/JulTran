function hello_julia_impl(mutex)
    #*************#
    #* set types *#
    #*************#
    INTEGER ::    i

    #***********************#
    #* perform calculation *#
    #***********************#
    !$OMP PARALLEL DO SCHEDULE(STATIC) PRIVATE(i) NUM_THREADS(4)
    DO i = 1,Threads.nthreads(), 1
        !$OMP CRITICAL
        println("Hello from Julia thread ",Threads.threadid())
        !$OMP END CRITICAL
    end
    !$END OMP PARALLEL DO
    println("")
