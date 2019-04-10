# JulTran
A specialized Julia=>Fortran90 transcompiler. By applying simple annotations
to structured Julia code, JulTran can transcompile it into OpenMP Fortran90
code. Through the use of ccall, the OpenMP code can easily be used by Julia
programs. This gives Julia an easy route to using OpenMP code.
