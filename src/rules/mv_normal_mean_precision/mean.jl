# Belief propagation.

@define_message_update_rule(
    node = MvNormalMeanPrecision, target = :μ,
    args = (m[:out]::PointMass, m[:Λ]::PointMass),
    logscale = 0,
    body = (args) -> MvNormalMeanPrecision(mean(args.m[:out]), mean(args.m[:Λ])),
)

@define_message_update_rule(
    node = MvNormalMeanPrecision, target = :μ,
    args = (m[:out]::MultivariateNormalDistributionsFamily, m[:Λ]::PointMass),
    logscale = 0,
    body = (args) -> through_noise(args.m[:out], cholinv(mean(args.m[:Λ])), (m, Σ) -> ((μ, V) = mean_cov(m); MvNormalMeanCovariance(μ, V + Σ))),
)

# Variational: a `q_Λ` contributes the precision E[Λ].

@define_message_update_rule(
    node = MvNormalMeanPrecision, target = :μ,
    args = (q[:out]::PointMass, q[:Λ]::PointMass),
    logscale = 0,
    body = (args) -> MvNormalMeanPrecision(mean(args.q[:out]), mean(args.q[:Λ])),
)

@define_message_update_rule(
    node = MvNormalMeanPrecision, target = :μ,
    args = (q[:out]::Any, q[:Λ]::Any),
    body = (args) -> MvNormalMeanPrecision(mean(args.q[:out]), mean(args.q[:Λ])),
)

@define_message_update_rule(
    node = MvNormalMeanPrecision, target = :μ,
    args = (m[:out]::PointMass, q[:Λ]::Any),
    body = (args) -> MvNormalMeanPrecision(mean(args.m[:out]), mean(args.q[:Λ])),
)

@define_message_update_rule(
    node = MvNormalMeanPrecision, target = :μ,
    args = (m[:out]::MultivariateNormalDistributionsFamily, q[:Λ]::Any),
    body = (args) -> through_noise(args.m[:out], cholinv(mean(args.q[:Λ])), (m, Σ) -> ((μ, V) = mean_cov(m); MvNormalMeanCovariance(μ, V + Σ))),
)

# A Wishart q_Λ = W(df, S) has E[Λ]⁻¹ = S⁻¹/df, from the factor S already holds.
@define_message_update_rule(
    node = MvNormalMeanPrecision, target = :μ,
    args = (m[:out]::MultivariateNormalDistributionsFamily, q[:Λ]::Wishart),
    body = (args) -> begin
        df, S = params(args.q[:Λ])
        through_noise(args.m[:out], inv(S) ./ df, (m, Σ) -> ((μ, V) = mean_cov(m); MvNormalMeanCovariance(μ, V + Σ)))
    end,
)
