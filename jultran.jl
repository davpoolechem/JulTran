module JulTran

import TypeSetting
import OMPControlFlow
import GeneralOpenMP
import FortranFunctions

macro run(function_name::String, filename_jl::String)
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
        function_name_regex = Regex("function $function_name\\(")
        if (occursin(function_name_regex,file[i]))
            file_start = i

            file[i] = replace(file[i],"function "=>"FUNCTION ")
            if (occursin("(mutex",file[i]))
                file[i] = replace(file[i],"(mutex"=>"(")
            end
        end
        if (occursin("end#fxn",file[i]))
            file_end = i
            file[i] = replace(file[i],"end#fxn"=>"END")
        end
    end

    file[file_start:file_end] = TypeSetting.run(file[file_start:file_end])

    file[file_start:file_end] = OMPControlFlow.run(file[file_start:file_end])

    file[file_start:file_end] = GeneralOpenMP.run(file[file_start:file_end])

    file[file_start:file_end] = FortranFunctions.run(file[file_start:file_end])

    for i in file_start:file_end
        #printing
        if (occursin(r"println\((.*)\)",file[i]))
            regex = match(r"println\((.*)\)",file[i])

            statement = regex[1]
            file[i] = replace(file[i],r"println\((.*)\)"=>"PRINT *, $statement")
        end
    end

    #*************************#
    #* write to fortran file *#
    #*************************#

    f_f95::IOStream = open(filename*"_fortran.f95","w")
        for i in file_start:file_end
            write(f_f95,file[i]*"\n")
        end
    close(f_f95)
end
export run

end

JulTran.@run "is_prime" "examples/prime.jl"
