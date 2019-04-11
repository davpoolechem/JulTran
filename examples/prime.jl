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
			#END OMP DO
		end#if

	#END OMP PARALLEL

    if (prime == true)
		println("This number is prime!")
    else
		println("This number is not prime!")
	end#if
end#fxn
