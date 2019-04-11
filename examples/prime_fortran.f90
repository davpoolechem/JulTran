FUNCTION is_prime(num)
    LOGICAL :: prime
    INTEGER :: num
    INTEGER :: denominator

	prime = .TRUE.

	!$OMP PARALLEL SHARED(prime) PRIVATE(num,denominator) NUM_THREADS(4)

	   	IF (MOD(num,2) == 0) THEN
			prime = .FALSE.
	    ELSE
			!$OMP DO SCHEDULE(STATIC)
            DO denominator = 3, num-1, 2 
		    	IF (MOD(num,denominator) == 0) THEN
					prime = .FALSE.
				END IF
			END DO
			!$END OMP DO
		END IF

	!$END OMP PARALLEL

    IF (prime == .TRUE.) THEN
		PRINT *, "This number is prime!"
    ELSE
		PRINT *, "This number is not prime!"
	END IF
END
