using LinearAlgebra
using TensorOperations
import Base:eltype

"""
Matrix Product Tensor
"""
mutable struct MPT{F <: AbstractFloat}
    χ::Integer
    A::Array{Complex{F},3}
end

"""
    MPT([::Type{T}], χ::Integer)
"""
MPT(χ::Integer) = MPT(Float32, χ)
MPT(::Type{T}, χ::Integer) where T = begin
    A = zeros(Complex{T}, χ, χ, 2)
    A[1,1,1] = 1

    MPT(χ, A)
end
MPT(A::Array{Complex{F},3}) where F <: AbstractFloat = begin
    @assert size(A, 1) == size(A, 2) "Dimensions 1 and 2 must match"

    χ = size(A, 1)
    MPT(χ, A)
end

"""
    GHZ([::Type{T}], χ::Integer)

Constructs the Greenberger-Horne-Zeilinger state.
"""
GHZ(χ::Integer) = GHZ(Float32, χ)
GHZ(::Type{T}, χ::Integer) where T = begin
    A = zeros(Complex{T}, χ, χ, 2)
    A[1,1,1] = 1 / √2
    A[1,1,2] = 1 / √2

    MPT(χ, A)
end

eltype(ψ::MPT{F}) where F = Complex{F}

"""
    apply(ψ::MPT, b::Bool)
"""
apply(ψ::MPT, b::Bool) = ψ.A[:,:,b + 1]

"""
    apply!(ψ::MPT, U::Array{N,2})

Applies a single-qubit operator `U` to qubit represented by `ψ`.
"""
apply!(ψ::MPT, U::Array{N,2}) where N <: Number = @tensor ψ.A[i,j,k] := ψ.A[i,j,l] * U[l,k]

"""
    apply!(ψ₁::MPT, ψ₂::MPT, U::Array{N,4})

Applies a two-qubit operator `U` to qubits `ψ₁` and `ψ₂`.
"""
apply!(ψ₁::MPT, ψ₂::MPT, H::Array{N,4}) where N <: Number = begin
    @assert ψ₁.χ == ψ₂.χ "χ-parameter of ψ₁ and ψ₂ must match"

    # Contract ψ₁, ψ₂ and H
    # i,j are remaining virtual bonds
    # n,o are physical bonds
    # m is contracted virtual bond
    # k,l are contracted physical bonds
    @tensor A[i,n,j,o] := ψ₁[i,m,k] * ψ₂[m,j,l] * H[l,k,o,n]

    # SVD
    χ = ψ₁.χ
    A = reshape(A, (2 * χ, 2 * χ))
    U, S, V = svd(A)

    # Truncate SVD
    # SVD generates 2×χ singular values
    f = sum(S[1:χ]) / sum(S)
    S = S[1:χ]
    U = reshape(U[:,1:χ], (χ, χ, 2))
    V = reshape(V[1:χ,:], (χ, χ, 2))

    # Renormalize S
    S = S / norm(S)
    S = convert(Array{eltype(U),2}, Diagonal(S))

    @tensor ψ₁.A[i,j,k] = U[i,l,k] * S[l,j]
    ψ₂.A = V

    return f
end