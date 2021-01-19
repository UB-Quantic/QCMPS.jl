using TensorOperations

struct MPS
    A::Vector{Array{Complex{AbstractFloat},3}}
end

# TODO how do yo initialize an MPS to |0..0⟩?
MPS(n::Integer,χ::Integer) = MPS([complex(rand(χ,χ,2)) for _ in 1:n])

function apply!(ψ::MPS, U::Array{F,2}, target) where F
    A = ψ.A[target]
    @tensor A[i,j,k] = A[i,j,l] * U[l,k]
end

