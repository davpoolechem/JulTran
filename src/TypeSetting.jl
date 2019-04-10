module TypeSetting

function set_types(subfile, fortran_type::String, julia_type::String)
    regex_to_check = Regex("[ *](.*)\\:\\:$julia_type")
    for i in 1:length(subfile)
        if (occursin(regex_to_check,subfile[i]))
            variable = match(regex_to_check,subfile[i])[1]
            subfile[i] = replace(subfile[i],subfile[i]=>"    $fortran_type :: $variable ")
        end
    end
end

@inline function run(subfile)
    set_types(subfile,"INTEGER","Int64")

    return subfile
end
export run

end
