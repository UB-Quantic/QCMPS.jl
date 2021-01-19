using TensorOperations
using LinearAlgebra

struct MPS
    χ::Integer
    A::Vector{Array{Complex{AbstractFloat},3}}
end

# TODO how do yo initialize an MPS to |0..0⟩?
MPS(n::Integer,χ::Integer) = MPS(χ, [complex(rand(χ, χ, 2)) for _ in 1:n])

apply!(ψ::MPS, U::Array{N,2}, target::Integer) where N <: Number = @tensor ψ.A[target][i,j,k] := ψ.A[target][i,j,l] * U[l,k]

function apply!(ψ::MPS, U::Array{N,4}, targets::Tuple{Integer,Integer}) where N <: Number
    A₁ = ψ.A[targets[1]]
    A₂ = ψ.A[targets[2]]
    χ = ψ.χ

    # Contract MPS nodes and operator
    @tensor A[i,n,j,o] := A₁[i,m,k] * A₂[m,j,l] * U[k,l,n,o]
    println("A = ", size(A))

    # SVD
    dims = (2 * χ, 2 * χ)
    A = reshape(A, dims)
    println("A = ", size(A))
    U, S, V = svd(A)

    # Truncate SVD
    S = S[1:χ]
    U = U[:,1:χ]
    V = V[1:χ,:]

    S = convert(typeof(U), Diagonal(S))
    U = reshape(U, (χ, χ, 2))
    @tensor ψ.A[targets[1]][i,j,k] = U[i,l,k] * S[l,j]
    ψ.A[targets[2]] = reshape(V, (χ, χ, 2))

    return nothing
end
