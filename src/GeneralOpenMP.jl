module GeneralOpenMP

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
        if (occursin("end#do",subfile[i]))
            subfile[i] = replace(subfile[i],"end#do"=>"END DO")
        end

        #omp function matching
        if (occursin("Threads.nthreads()",subfile[i]))
            subfile[i] = replace(subfile[i],"Threads.nthreads()"=>"OMP_GET_NUM_THREADS()")
        end
        if (occursin("Threads.threadid()",subfile[i]))
            subfile[i] = replace(subfile[i],"Threads.threadid()"=>"OMP_GET_THREAD_NUM()")
        end
    end
end

@inline function run(subfile)
    add_critical(subfile)
    omp_functions(subfile)

    return subfile
end
export run

end
