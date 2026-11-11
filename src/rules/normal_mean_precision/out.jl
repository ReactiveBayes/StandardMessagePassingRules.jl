@define_message_update_rule(
    node = NormalMeanPrecision, target = :out,
    args = (m[:μ]::PointMass, m[:τ]::PointMass),
    logscale = 0,
    body = (args) -> NormalMeanPrecision(mean(args.m[:μ]), mean(args.m[:τ])),
)

@define_message_update_rule(
    node = NormalMeanPrecision, target = :out,
    args = (m[:μ]::UnivariateNormalDistributionsFamily, m[:τ]::PointMass),
    logscale = 0,
    body = (args) -> through_noise(args.m[:μ], inv(mean(args.m[:τ])), (m, v) -> ((μ, s) = mean_var(m); NormalMeanPrecision(μ, inv(s + v)))),
)

@define_message_update_rule(
    node = NormalMeanPrecision, target = :out,
    args = (q[:μ]::PointMass, q[:τ]::PointMass),
    logscale = 0,
    body = (args) -> NormalMeanPrecision(mean(args.q[:μ]), mean(args.q[:τ])),
)

@define_message_update_rule(
    node = NormalMeanPrecision, target = :out,
    args = (q[:μ]::Any, q[:τ]::Any),
    body = (args) -> NormalMeanPrecision(mean(args.q[:μ]), mean(args.q[:τ])),
)

@define_message_update_rule(
    node = NormalMeanPrecision, target = :out,
    args = (m[:μ]::PointMass, q[:τ]::Any),
    body = (args) -> NormalMeanPrecision(mean(args.m[:μ]), mean(args.q[:τ])),
)

@define_message_update_rule(
    node = NormalMeanPrecision, target = :out,
    args = (m[:μ]::UnivariateNormalDistributionsFamily, q[:τ]::Any),
    body = (args) -> through_noise(args.m[:μ], inv(mean(args.q[:τ])), (m, v) -> ((μ, s) = mean_var(m); NormalMeanPrecision(μ, inv(s + v)))),
)
