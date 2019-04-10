using Base.Threads

function hello_impl(mutex)
    i::Int64 = 0

    #OMP PARALLEL DO SCHEDULE(STATIC) PRIVATE(i) NUM_THREADS(4)
    Threads.@threads for i in 1:1:Threads.nthreads()
        lock(mutex)
        println("Hello from thread ",Threads.threadid())
        unlock(mutex)
    end#do
    #END OMP PARALLEL DO
end
#endfxn

function hello_julia()
    mutex = Threads.Mutex()
    hello_julia_impl(mutex)

    ccall((:hello_fortran_,"hello_fortran.so"),Int64,())
end

hello_julia()
