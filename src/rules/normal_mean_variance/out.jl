@define_message_update_rule(
    node = NormalMeanVariance, target = :out,
    args = (m[:μ]::PointMass, m[:v]::PointMass),
    logscale = 0,
    body = (args) -> NormalMeanVariance(mean(args.m[:μ]), mean(args.m[:v])),
)

@define_message_update_rule(
    node = NormalMeanVariance, target = :out,
    args = (m[:μ]::UnivariateNormalDistributionsFamily, m[:v]::PointMass),
    logscale = 0,
    body = (args) -> through_noise(args.m[:μ], mean(args.m[:v]), (m, v) -> ((μ, s) = mean_var(m); NormalMeanVariance(μ, s + v))),
)

@define_message_update_rule(
    node = NormalMeanVariance, target = :out,
    args = (q[:μ]::PointMass, q[:v]::PointMass),
    logscale = 0,
    body = (args) -> NormalMeanVariance(mean(args.q[:μ]), mean(args.q[:v])),
)

@define_message_update_rule(
    node = NormalMeanVariance, target = :out,
    args = (q[:μ]::Any, q[:v]::Any),
    body = (args) -> NormalMeanVariance(mean(args.q[:μ]), gaussian_variational_variance(args.q[:v])),
)

@define_message_update_rule(
    node = NormalMeanVariance, target = :out,
    args = (m[:μ]::PointMass, q[:v]::Any),
    body = (args) -> NormalMeanVariance(mean(args.m[:μ]), gaussian_variational_variance(args.q[:v])),
)

@define_message_update_rule(
    node = NormalMeanVariance, target = :out,
    args = (m[:μ]::UnivariateNormalDistributionsFamily, q[:v]::Any),
    body = (args) -> through_noise(args.m[:μ], gaussian_variational_variance(args.q[:v]), (m, v) -> ((μ, s) = mean_var(m); NormalMeanVariance(μ, s + v))),
)

@define_message_update_rule(
    node = NormalMeanVariance, target = :out,
    args = (m[:μ]::UnivariateNormalDistributionsFamily, q[:v]::PointMass),
    logscale = 0,
    body = (args) -> through_noise(args.m[:μ], mean(args.q[:v]), (m, v) -> ((μ, s) = mean_var(m); NormalMeanVariance(μ, s + v))),
)
