using TensorOperations
using LinearAlgebra
import Base.*

struct MPS
    χ::Integer
    A::Vector{Array{Complex{AbstractFloat},3}}
end

function MPS(n::Integer, χ::Integer)
    A = zeros(Complex, χ, χ, 2)
    A[1,1,1] = 1
    MPS(χ, [copy(A) for _ in 1:n])
end

apply!(ψ::MPS, U::Array{N,2}, target::Integer) where N <: Number = @tensor ψ.A[target][i,j,k] := ψ.A[target][i,j,l] * U[l,k]

function apply!(ψ::MPS, U::Array{N,4}, targets::Tuple{Integer,Integer}) where N <: Number
    A₁ = ψ.A[targets[1]]
    A₂ = ψ.A[targets[2]]
    χ = ψ.χ

    # Contract MPS nodes and operator
    # i,j are remaining virtual bond
    # n,o are physical bonds
    # m is contracted virtual bond
    # k,l are contracted physical bonds
    @tensor A[i,n,j,o] := A₁[i,m,k] * A₂[m,j,l] * U[l,k,o,n]

    # SVD
    dims = (2 * χ, 2 * χ)
    A = reshape(A, dims)
    U, S, V = svd(A)

    # Truncate SVD
    # SVD generates 2×χ singular values
    f = sum(S[1:χ]) / sum(S)
    S = S[1:χ]
    U = U[:,1:χ]
    V = V[1:χ,:]

    S = convert(typeof(U), Diagonal(S))
    U = reshape(U, (χ, χ, 2))
    @tensor ψ.A[targets[1]][i,j,k] = U[i,l,k] * S[l,j]
    ψ.A[targets[2]] = reshape(V, (χ, χ, 2))

    return f
end


×(α::MPS, β::MPS) = inner(α::MPS, β::MPS)
*(α::MPS, β::MPS) = inner(α::MPS, β::MPS)
function inner(α::MPS, β::MPS)
    N = length(α.A)
    χ = α.χ

    @tensor C[i,j,l,m] := α.A[1][i,j,k] * β.A[1][l,m,k]

    for node in 2:N
        @tensor C[i,o,l,p] = C[i,j,l,m] * α.A[node][j,o,n] * β.A[node][m,p,n]
    end

    @tensor D[] := C[i,o,l,p] * C[i,o,l,p]
    D[1]
end