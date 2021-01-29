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

apply!(ψ::DistributedMPS, H::Array{N,2}, target::Integer) where N <: Number = begin
	p = DistributedArrays.locate(ψ.A, target)
	remotecall_fetch(apply!, p, ψ.A[target], H)
end

apply!(ψ::DistributedMPS, H::Array{N,4}, target::Tuple{Integer,Integer}) where N <: Number = begin
	# TODO order inverted operators
    @assert (targets[1] == targets[2] - 1) "Only 1-local operators are allowed"

	ψ₁ = ψ.A[targets[1]]
	ψ₂ = ψ.A[targets[2]]

	apply!(ψ₁, ψ₂, H)
end