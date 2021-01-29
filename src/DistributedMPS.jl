using Distributed
using DistributedArrays

# @everywhere push!(LOAD_PATH, pwd())
# @everywhere using QCMPS

struct DistributedMPS{F <: AbstractFloat} <: MPS
	χ::Integer
	A::DArray{MPT{F},1,Vector{MPT{F}}}
end

DistributedMPS(χ,n::Integer) = DistributedMPS(Float32, χ, n)
DistributedMPS(::Type{T},χ,n::Integer) where T = DistributedMPS(χ, dfill(MPT(T, χ), (n,)))
