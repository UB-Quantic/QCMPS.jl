struct LocalMPS{F <: AbstractFloat} <: MPS
	χ::Integer
    A::Vector{MPT{F}}
end

LocalMPS(χ,n::Integer) = LocalMPS(Float32, χ, n)
LocalMPS(::Type{T},χ,n) where T = LocalMPS(χ, [MPT(T, χ) for _ in 1:n])
