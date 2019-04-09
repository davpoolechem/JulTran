function julia90(filename_jl)
    #**********************#
    #* read in julia file *#
    #**********************#
    f_jl::IOStream = open(filename_jl)
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
            println(variable)
            file[i] = replace(file[i],file[i]=>"    INTEGER :: $variable ")
        end
    end

    #******************#
    #* handle do loop *#
    #******************#
    display(file[file_start:file_end])
end

julia90("examples/hello_julia.jl")
