module QCMPS

include("Operator.jl")
export I,X,Y,Z,Rx,Ry,Rz,S,Sᵀ,T,Tᵀ,H,SqrtX
export C,CX,CY,CZ,CNOT,Swap,SqrtSwap,XX,YY,ZZ

include("MPT.jl")

include("MPS.jl")
export MPS,LocalMPS,DistributedMPS
export apply!,apply_all!

end # module
