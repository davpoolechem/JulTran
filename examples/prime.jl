function is_prime(num)
    prime::Bool
	num::Int64
	denominator::Int64

	prime = true

	#OMP PARALLEL SHARED(prime) PRIVATE(num,denominator) NUM_THREADS(4)

	    if (num%2 == 0)
			prime = false
	    else
			#OMP DO SCHEDULE(STATIC)
			for denominator in 3:2:num-1
		    	if (num%denominator == 0)
					prime = false
				end#if
			end#do
			#OMP END DO
		end#if

	#OMP END PARALLEL

    if (prime == true)
		println("This number is prime!")
    else
		println("This number is not prime!")
	end#if
end#fxn

function prime_julia()
	int::Array{Int32} =  [ 2147483647 ]
	pint = pointer_from_objref(int)

	#int::Array{Int32} =  [ 2147483647 ]
	#pint = Ref(int[1])

	#ccall((:is_prime_,"examples/fortran_functions.so"),Int32,(Base.RefValue{Int32},),pint)
    ccall((:is_prime_,"examples/fortran_functions.so"),Int32,(Base.RefValue{Array{Int32,1}},),pint)
	#ccall((:hello_impl_,"examples/fortran_functions.so"),Int32,())
end

prime_julia()
