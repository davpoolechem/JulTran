#/bin/bash

#gfortran -O3 -fopenmp -shared -fPIC -o fortran_functions.so prime_fortran.f90 
gfortran -O3 -fopenmp -shared -fPIC -std=f95 -o fortran_functions.so prime_fortran.f95 

