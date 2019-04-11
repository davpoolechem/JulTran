module GeneralOpenMP

#replace parallel bounds
function replace_parallel(subfile)
    for i in 1:length(subfile)
        if (occursin("#OMP PARALLEL",subfile[i]))
            subfile[i] = replace(subfile[i],"#OMP PARALLEL"=>"!\$OMP PARALLEL")
        end

        if (occursin("#END OMP PARALLEL",subfile[i]))
            subfile[i] = replace(subfile[i],"#END OMP PARALLEL"=>"!\$END OMP PARALLEL")
        end
    end
end

#replaces mutexes with critical regions
function add_critical(subfile)
    for i in 1:length(subfile)
        if (occursin("lock(mutex)",subfile[i]) && !occursin("unlock(mutex)",subfile[i]))
            subfile[i] = replace(subfile[i],"lock(mutex)"=>"!\$OMP CRITICAL")
        end
        if (occursin("unlock(mutex)",subfile[i]))
            subfile[i] = replace(subfile[i],"unlock(mutex)"=>"!\$OMP END CRITICAL")
        end
    end
end

#replace Base.Threads functions with OMP functions
function omp_functions(subfile)
    for i in 1:length(subfile)
        #omp function matching
        if (occursin("Threads.nthreads()",subfile[i]))
            subfile[i] = replace(subfile[i],"Threads.nthreads()"=>"OMP_GET_NUM_THREADS()")
        end
        if (occursin("Threads.threadid()",subfile[i]))
            subfile[i] = replace(subfile[i],"Threads.threadid()"=>"OMP_GET_THREAD_NUM()")
        end
    end
end

#replace booleans
function booleans(subfile)
    for i in 1:length(subfile)
        #omp function matching
        if (occursin("true",subfile[i]))
            subfile[i] = replace(subfile[i],"true"=>".TRUE.")
        end
        if (occursin("false",subfile[i]))
            subfile[i] = replace(subfile[i],"false"=>".FALSE.")
        end
    end
end

@inline function run(subfile)
    add_critical(subfile)
    omp_functions(subfile)
    replace_parallel(subfile)
    booleans(subfile)
    
    return subfile
end
export run

end
