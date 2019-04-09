function hello_julia()
    println("Hello from Julia!")
    ccall((:hello_fortran_,"hello_fortran.so"),Int64,())
end

hello_julia()
