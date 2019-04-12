module OMPControlFlow

function replace_do(subfile)
    for i in 1:length(subfile)
        if (occursin(r"#OMP.*DO",subfile[i]))
            if (occursin("PARALLEL",subfile[i]))
                subfile[i] = replace(subfile[i],"#OMP PARALLEL DO"=>"!\$OMP PARALLEL DO")
            else
                subfile[i] = replace(subfile[i],"#OMP DO"=>"!\$OMP DO")
            end
        end
        if (occursin(r"for (.*) in (.*)",subfile[i]))
            regex = match(r"for (.*) in (.*)",subfile[i])

            variable = regex[1]
            do_range = regex[2]

            do_range_regex = match(r"for .* in (.*):(.*):(.*)",subfile[i])

            first = do_range_regex[1]
            second = do_range_regex[2]
            third = do_range_regex[3]

            subfile[i] = replace(subfile[i],subfile[i]=>"    DO $variable = $first, $third, $second ")
        end

        if (occursin(r"#OMP END.*DO",subfile[i]))
            if (occursin("PARALLEL",subfile[i]))
                subfile[i] = replace(subfile[i],"#OMP END PARALLEL DO"=>"!\$OMP END PARALLEL DO")
            else
                subfile[i] = replace(subfile[i],"#OMP END DO"=>"!\$OMP END DO")
            end
        end

        if (occursin("end#do",subfile[i]))
            subfile[i] = replace(subfile[i],"end#do"=>"END DO")
        end
    end
end

function replace_if(subfile)
    for i in 1:length(subfile)
        if (occursin(r"elseif(.*)",subfile[i]))
            condition = match(r"elseif(.*)",subfile[i])[1]
            subfile[i] = replace(subfile[i],"elseif $condition"=>"ELSE IF $condition THEN")
        elseif (occursin(r"if(.*)",subfile[i]) && !occursin("end#if",subfile[i]))
            condition = match(r"if(.*)",subfile[i])[1]
            subfile[i] = replace(subfile[i],"if$condition"=>"IF$condition THEN")
        elseif (occursin("else",subfile[i]))
            subfile[i] = replace(subfile[i],"else"=>"ELSE")
        end

        if (occursin("end#if",subfile[i]))
            subfile[i] = replace(subfile[i],"end#if"=>"END IF")
        end
    end
end


@inline function run(subfile)
    replace_do(subfile)
    replace_if(subfile)

    return subfile
end
export run

end
