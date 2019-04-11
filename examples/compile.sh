#/bin/bash

f95_files=""
for i in *.f95; do
    [ -f "$i" ] || break
    f95_files="${f95_files} ${i%.f95}.o"

gfortran -O3 -fopenmp -fPIC -std=f95 -c $i
done

gfortran -O3 -fopenmp -shared -fPIC -std=f95 -o fortran_functions.so hello_fortran.o  
