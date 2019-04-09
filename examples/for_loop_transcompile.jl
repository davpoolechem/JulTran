function julia90(filename_jl)
    #copy python file to julia array object for manipulation
    f_jl::IOStream = open(filename_jl)
        file::Array{String,1} = readlines(f_jl)
    close(f_jl)

    file_start = 1
    file_end = 1

    for i in 1:length(file)
        println(length(file))
        if (occursin("function hello_julia_impl",file[i]))
            file_start = i
        end
        if (occursin("#endfxn",file[i]))
            file_end = i
        end
    end

    display(file[file_start:file_end])
end

test("examples/hello_julia.jl")
