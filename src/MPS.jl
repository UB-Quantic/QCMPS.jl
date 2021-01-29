using TensorOperations
using LinearAlgebra
import Base.*


abstract type MPS end

include("LocalMPS.jl")
include("DistributedMPS.jl")

MPS(χ::Integer, n::Integer) = LocalMPS(χ)

apply!(Ψ::MPS, H::Array{N,2}, i::Integer) where N <: Number = apply!(Ψ.A[i], H)
apply_all!(Ψ::MPS, H::Array{N,2}) where N <: Number = foreach(i -> apply!(Ψ, H, i), 1:length(Ψ.A))
