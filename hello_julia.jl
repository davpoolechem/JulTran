using Base.Threads

function hello_julia()

    mutex = Threads.Mutex()
    Threads.@threads for i in 1:Threads.nthreads()
        lock(mutex)
        println("Hello from Julia thread ",Threads.threadid())
        unlock(mutex)
    end
    println("")

    ccall((:hello_fortran_,"hello_fortran.so"),Int64,())
end

hello_julia()
