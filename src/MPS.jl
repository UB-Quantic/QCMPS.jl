using TensorOperations

struct MPS
    A::Vector{Array{Complex{AbstractFloat},3}}
end

# TODO how do yo initialize an MPS to |0..0⟩?
MPS(n::Integer,χ::Integer) = MPS([complex(rand(χ,χ,2)) for _ in 1:n])

apply!(ψ::MPS, U::Array{N,2}, target::Integer) where N <: Number = @tensor ψ.A[target][i,j,k] := ψ.A[target][i,j,l] * U[l,k]

