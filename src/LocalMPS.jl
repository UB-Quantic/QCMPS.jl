struct LocalMPS <: MPS
	χ::Integer
    A::Array{MPS}
end

LocalMPS(χ,n) = LocalMPS(χ, [MPT(χ) for _ in 1:n])
LocalMPS(::Type{T},χ,n) where T = LocalMPS(χ, [MPT(T, χ) for _ in 1:n])

apply!(ψ::LocalMPS, H::Array{N,2}, target::Integer) where N <: Number = apply!(ψ.A[target], H)

apply!(ψ::LocalMPS, H::Array{N,4}, targets::Tuple{Integer,Integer}) where N <: Number = begin
	# TODO order inverted operators
    @assert (targets[1] == targets[2] - 1) "Only 1-local operators are allowed"

	ψ₁ = ψ.A[targets[1]]
	ψ₂ = ψ.A[targets[2]]

	apply!(ψ₁, ψ₂, H)
end
