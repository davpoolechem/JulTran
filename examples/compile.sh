#/bin/bash

gfortran -O3 -fopenmp -shared -fPIC -o fortran_functions.so hello_fortran.f90 

