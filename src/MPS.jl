using TensorOperations
using LinearAlgebra
import Base.*


abstract type MPS end

include("LocalMPS.jl")

MPS(χ::Integer, n::Integer) = LocalMPS(χ)

apply_all!(Ψ::MPS, H::Array{N,2}) where N <: Number = foreach((i, x) -> apply!(x, H, i), enumerate(Ψ.A))