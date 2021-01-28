using TensorOperations
using LinearAlgebra
import Base.*


abstract type MPS end

include("LocalMPS.jl")

MPS(n::Integer, χ::Integer) begin
	A = [zeros(Complex, χ, χ, 2) for _ in 1:n]
	A[:][1,1,1] = 1
	LocalMPS(χ, A)
end

apply_all!(Ψ::MPS, H::Array{N, 2}) where N <: Number = foreach(x -> apply!(x, H), Ψ.A)