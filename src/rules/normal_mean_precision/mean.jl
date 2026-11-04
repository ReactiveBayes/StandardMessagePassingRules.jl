@define_message_update_rule(
    node = NormalMeanPrecision, target = :μ,
    args = (m[:out]::PointMass, m[:τ]::PointMass),
    logscale = 0,
    body = (args) -> NormalMeanPrecision(mean(args.m[:out]), mean(args.m[:τ])),
)

@define_message_update_rule(
    node = NormalMeanPrecision, target = :μ,
    args = (m[:out]::UnivariateNormalDistributionsFamily, m[:τ]::PointMass),
    logscale = 0,
    body = (args) -> through_noise(args.m[:out], inv(mean(args.m[:τ])), (m, v) -> ((μ, s) = mean_var(m); NormalMeanVariance(μ, s + v))),
)

@define_message_update_rule(
    node = NormalMeanPrecision, target = :μ,
    args = (q[:out]::PointMass, q[:τ]::PointMass),
    logscale = 0,
    body = (args) -> NormalMeanPrecision(mean(args.q[:out]), mean(args.q[:τ])),
)

@define_message_update_rule(
    node = NormalMeanPrecision, target = :μ,
    args = (q[:out]::Any, q[:τ]::Any),
    body = (args) -> NormalMeanPrecision(mean(args.q[:out]), mean(args.q[:τ])),
)

@define_message_update_rule(
    node = NormalMeanPrecision, target = :μ,
    args = (m[:out]::PointMass, q[:τ]::Any),
    body = (args) -> NormalMeanPrecision(mean(args.m[:out]), mean(args.q[:τ])),
)

@define_message_update_rule(
    node = NormalMeanPrecision, target = :μ,
    args = (m[:out]::UnivariateNormalDistributionsFamily, q[:τ]::Any),
    body = (args) -> through_noise(args.m[:out], inv(mean(args.q[:τ])), (m, v) -> ((μ, s) = mean_var(m); NormalMeanVariance(μ, s + v))),
)
