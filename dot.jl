import LinearAlgebra

function f90_main()
    #real, dimension(5)
    a = Array{Float64}(undef,5)
    b = Array{Float64}(undef,5)
    #endtype

    #integer
    i::Int64 = 0
    asize::Int64 = 0
    bsize::Int64 = 0
    #endtype

    #start program
    asize = length(a)
    bsize = length(b)

    for i in 1:asize
        a[i] = i
    #endfor
    end

    for i in 1:bsize
        b[i] = 2i
    #endfor
    end

    for i in 1:asize
        println(a[i])
    #endfor
    end

    for i in 1:bsize
        println(b[i])
    #endfor
    end

    println("Vector Multiplication: Dot Product")
    println(LinearAlgebra.dot(a,b))
end
