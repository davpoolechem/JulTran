module TypeSetting

function set_types(subfile, fortran_type::String, julia_type::String)
    regex_to_check = Regex("(\\w+)\\:\\:$julia_type")
    println(regex_to_check)
    for i in 1:length(subfile)
        println(occursin(regex_to_check,subfile[i]))
        if (occursin(regex_to_check,subfile[i]))
            variable = match(regex_to_check,subfile[i])[1]
            subfile[i] = replace(subfile[i],subfile[i]=>"    $fortran_type :: $variable ")
        end
    end
end

@inline function run(subfile)
    set_types(subfile,"INTEGER","Int64")
    set_types(subfile,"LOGICAL","Bool")

    return subfile
end
export run

end
