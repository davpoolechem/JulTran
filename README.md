# JulTran
A specialized Julia=>Fortran90 transcompiler. By applying simple annotations
to structured Julia functions, JulTran can transcompile the function into OpenMP
code. Through the use of ccall, the OpenMP code can easily be used by Julia
programs. This provides Julia with something of an OpenMP interface.
