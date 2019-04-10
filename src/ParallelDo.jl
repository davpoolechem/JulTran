module ParallelDo

function replace_parallel_do(subfile)
    for i in 1:length(subfile)
        if (occursin("#OMP PARALLEL DO",subfile[i]))
            subfile[i] = replace(subfile[i],"#OMP PARALLEL DO"=>"!\$OMP PARALLEL DO")
        end
        if (occursin(r"for (.*) in (.*)",subfile[i]))
            regex = match(r"for (.*) in (.*)",subfile[i])

            variable = regex[1]
            do_range = regex[2]

            do_range_regex = match(r"for i in (.*):(.*):(.*)",subfile[i])

            first = do_range_regex[1]
            second = do_range_regex[2]
            third = do_range_regex[3]

            subfile[i] = replace(subfile[i],subfile[i]=>"    DO $variable = $first, $third, $second ")
        end

        if (occursin("#END OMP PARALLEL DO",subfile[i]))
            subfile[i] = replace(subfile[i],"#END OMP PARALLEL DO"=>"!\$END OMP PARALLEL DO")
        end
    end
end

@inline function run(subfile)
    replace_parallel_do(subfile)

    return subfile
end
export run

end
