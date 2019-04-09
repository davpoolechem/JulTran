function julia90(filename_jl)
    #**********************#
    #* read in julia file *#
    #**********************#
    filename_regex = match(r"(.*).jl",filename_jl)
    filename = filename_regex[1]

    f_jl::IOStream = open(filename*".jl")
        file::Array{String,1} = readlines(f_jl)
    close(f_jl)

    file_start = 1
    file_end = 1

    #****************************************#
    #* extract function to be transcompiled *#
    #****************************************#
    for i in 1:length(file)
        if (occursin("function hello_julia_impl",file[i]))
            file_start = i
        end
        if (occursin("#endfxn",file[i]))
            file_end = i
        end
    end

    #***********************#
    #* handle type setting *#
    #***********************#
    for i in 1:length(file[file_start:file_end])
        if (occursin(r"[ *](.*)\:\:Int64",file[i]))
            variable = match(r"[ *](.*)\:\:Int64",file[i])[1]
            file[i] = replace(file[i],file[i]=>"    INTEGER :: $variable ")
        end
    end

    #******************#
    #* handle do loop *#
    #******************#
    for i in 1:length(file[file_start:file_end])
        if (occursin(r"\#OMP PARALLEL DO",file[i]))
            file[i] = replace(file[i],r"\#OMP PARALLEL DO"=>"!\$OMP PARALLEL DO")
        end
        if (occursin(r"for (.*) in (.*)",file[i]))
            regex = match(r"for (.*) in (.*)",file[i])

            variable = regex[1]
            do_range = regex[2]

            do_range_regex = match(r"for i in (.*):(.*):(.*)",file[i])

            first = do_range_regex[1]
            second = do_range_regex[2]
            third = do_range_regex[3]

            file[i] = replace(file[i],file[i]=>"    DO $variable = $first, $third, $second ")
        end
        if (occursin("lock(mutex)",file[i]) && !occursin("unlock(mutex)",file[i]))
            file[i] = replace(file[i],"lock(mutex)"=>"!\$OMP CRITICAL")
        end
        if (occursin("unlock(mutex)",file[i]))
            file[i] = replace(file[i],"unlock(mutex)"=>"!\$OMP END CRITICAL")
        end
        if (occursin(r"\#END OMP PARALLEL DO",file[i]))
            file[i] = replace(file[i],r"\#END OMP PARALLEL DO"=>"!\$END OMP PARALLEL DO")
        end
    end

    #*************************#
    #* write to fortran file *#
    #*************************#

    f_f90::IOStream = open(filename*"_fortran.f90","w")
        for i in 1:length(file[file_start:file_end])
            write(f_f90,file[i]*"\n")
        end
    close(f_f90)
end

julia90("examples/hello.jl")
