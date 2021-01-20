Operator{F,N} = Array{Complex{F},N} where F <: AbstractFloat

export I,X,Y,Z,Rx,Ry,Rz,S,Sᵀ,T,Tᵀ,H,SqrtX
I = [1 0; 0 1]
X = [0 1; 1 0]
Y = [0 -1im; 1im 0]
Z = [1 0; 0 -1]
Rx(θ) = exp(-1im * θ / 2 * [0 1; 1 0])
Ry(θ) = exp(-1im * θ / 2 * [0 -1im; 1im 0])
Rz(θ) = [1 0; 0 exp(1im * θ)]
S = Rz(π / 2)
Sᵀ = Rz(- π / 2)
T = Rz(π / 4)
Tᵀ = Rz(- π / 4)
H = 1 / √2 .* [1 1; 1 -1]
SqrtX = 1 / 2 .* [1 + 1im 1 - 1im; 1 - 1im 1 + 1im]

export C,CX,CY,CZ,CNOT,Swap,SqrtSwap,XX,YY,ZZ
C(U) = reshape([
    1 0 0 0;
    0 1 0 0;
    0 0 U[1,1] U[1,2];
    0 0 U[2,1] U[2,2]]
, (2, 2, 2, 2))

CX = C(X)
CY = C(Y)
CZ = C(Z)
CNOT = CX

Swap = reshape([
    1 0 0 0;
    0 0 1 0;
    0 1 0 0;
    0 0 0 1
], (2, 2, 2, 2))
SqrtSwap = reshape([
    1 0 0 0;
    0 1 / 2(1 + 1im) 1 / 2(1 - 1im) 0;
    0 1 / 2(1 - 1im) 1 / 2(1 + 1im) 0;
    0 0 0 1
], (2, 2, 2, 2))

XX(ϕ) = reshape(cos(ϕ) * kron(I, I) - 1im * sin(ϕ) * kron(X, X), (2, 2, 2, 2))
YY(ϕ) = reshape(cos(ϕ) * kron(I, I) - 1im * sin(ϕ) * kron(Y, Y), (2, 2, 2, 2))
ZZ(ϕ) = reshape(cos(ϕ) * kron(I, I) - 1im * sin(ϕ) * kron(Z, Z), (2, 2, 2, 2))
