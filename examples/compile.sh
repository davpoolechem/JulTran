#/bin/bash

gfortran -O3 -fopenmp -shared -fPIC -o fortran_functions.so prime_fortran.f90 

