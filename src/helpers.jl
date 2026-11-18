# Whether `vec` has exactly one entry approximately equal to one and all others approximately
# zero, to within `sqrt(eps)` of its element type.
function isonehot(vec::AbstractVector{T}) where {T}
    ones_seen = 0
    atol = sqrt(eps(T))
    for e in vec
        if isapprox(e, one(e); atol)
            ones_seen += 1
        elseif !isapprox(e, zero(e); atol)
            return false
        end
    end
    return ones_seen == 1
end

# The Gaussian message `m` through Gaussian noise of precision `Λ_f`.
function series_precision(m, Λ_f)
    μ, Λ = mean_precision(m)
    return MvNormalMeanPrecision(μ, gaussian_series_precision(Λ, Λ_f))
end

# A Gaussian message through Gaussian noise of variance `v` or covariance `Σ`, what a Gaussian node
# sends between its two Gaussian edges given a known noise. A message in weighted-mean form may be
# improper, a site of cavity propagation with a singular or indefinite precision, so it goes in
# natural parameters, `W' = (I + W Σ)⁻¹ W` and `ξ' = (I + W Σ)⁻¹ ξ`, which never invert `W`. Any
# other message goes through `otherwise(m, noise)`, the rule's own moment form.
function through_noise(m::NormalWeightedMeanPrecision, v::Real, otherwise)
    ξ, w = weightedmean_precision(m)
    k = 1 + w * v
    return NormalWeightedMeanPrecision(ξ / k, w / k)
end
function through_noise(m::MvNormalWeightedMeanPrecision, Σ::AbstractMatrix, otherwise)
    ξ, W = weightedmean_precision(m)
    K = LinearAlgebra.I + W * Σ
    W′ = K \ W
    return MvNormalWeightedMeanPrecision(K \ ξ, (W′ + W′') / 2)
end
through_noise(m, noise, otherwise) = otherwise(m, noise)
