module JulTran

import TypeSetting
import ParallelDo
import GeneralOpenMP

function run(filename_jl)
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
        if (occursin(r"function .*\(mutex",file[i]))
            file_start = i
            file[i] = replace(file[i],"(mutex"=>"(")
        end
        if (occursin("#endfxn",file[i]))
            file_end = i
            file[i] = replace(file[i],"#endfxn"=>"")
        end
    end

    file[file_start:file_end] = TypeSetting.run(file[file_start:file_end])

    file[file_start:file_end] = ParallelDo.run(file[file_start:file_end])

    file[file_start:file_end] = GeneralOpenMP.run(file[file_start:file_end])

    for i in file_start:file_end
        #printing
        if (occursin(r"println\((.*)\)",file[i]))
            regex = match(r"println\((.*)\)",file[i])

            statement = regex[1]
            file[i] = replace(file[i],r"println\((.*)\)"=>"PRINT *, $statement")
        end

        if (occursin("end#do",file[i]))
            file[i] = replace(file[i],"end#do"=>"END DO")
        end
    end

    #*************************#
    #* write to fortran file *#
    #*************************#

    f_f90::IOStream = open(filename*"_fortran.f90","w")
        for i in file_start:file_end
            write(f_f90,file[i]*"\n")
        end
    close(f_f90)
end
export run

end

JulTran.run("examples/hello.jl")
