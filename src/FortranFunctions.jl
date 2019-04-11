module FortranFunctions

#translate modulo function
function translate_modulo(subfile)
    for i in 1:length(subfile)
        #omp function matching
        if (occursin(r"(\w+)%(\w+)",subfile[i]))
            regex = match(r"(\w+)%(\w+)",subfile[i])

            first = regex[1]
            second = regex[2]

            subfile[i] = replace(subfile[i],"$first"*"%"*"$second"=>"MOD($first,$second)")
        end
    end
end

@inline function run(subfile)
    translate_modulo(subfile)

    return subfile
end
export run

end
