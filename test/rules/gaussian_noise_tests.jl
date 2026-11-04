# A Gaussian node between two Gaussian edges, with a known noise: a message in weighted-mean form
# goes through in natural parameters, so a singular or indefinite one, a site of cavity
# propagation, is propagated exactly. The reference is the Schur complement of the node's joint
# natural parameters with the message added, which never inverts the message's precision.

@testitem "rules:Gaussian nodes: improper weighted-mean messages through the noise" tags = [:rules] begin
    using StandardMessagePassingRules, MessagePassingRulesTestUtils, ExponentialFamily, BayesBase, Distributions
    using LinearAlgebra

    # ∫ N(y | x, Σ) exp(ξᵀy - yᵀWy/2) dy, as natural parameters of x
    function reference(ξ, W, Σ)
        S = inv(Σ)
        A = S + W
        return S * (A \ ξ), S - S * (A \ S)
    end

    Σ = [0.5 0.1; 0.1 0.3]
    cases = (
        ("singular", [1.0, 0.0], [2.0 0.0; 0.0 0.0]),
        ("indefinite", [0.5, -1.0], [1.5 0.2; 0.2 -0.4]),
    )
    for (name, ξ, W) in cases
        h, J = reference(ξ, W, Σ)
        message = MvNormalWeightedMeanPrecision(ξ, W)
        expected = MvNormalWeightedMeanPrecision(h, J)
        @test_message_update_rule(
            node = MvNormalMeanCovariance, target = :μ,
            cases = [(m = (out = message, Σ = PointMass(Σ)),) => ExpectedWithLogScale(expected, 0)],
        )
        @test_message_update_rule(
            node = MvNormalMeanCovariance, target = :out,
            cases = [(m = (μ = message, Σ = PointMass(Σ)),) => ExpectedWithLogScale(expected, 0)],
        )
        @test_message_update_rule(
            node = MvNormalMeanPrecision, target = :μ,
            cases = [(m = (out = message, Λ = PointMass(inv(Σ))),) => ExpectedWithLogScale(expected, 0)],
        )
        @test_message_update_rule(
            node = MvNormalMeanPrecision, target = :out,
            cases = [(m = (μ = message, Λ = PointMass(inv(Σ))),) => ExpectedWithLogScale(expected, 0)],
        )
    end

    # univariate: a negative precision and a zero one
    for (ξ, w) in ((0.4, -0.2), (0.4, 0.0))
        h, J = reference([ξ], fill(w, 1, 1), fill(2.0, 1, 1))
        expected = NormalWeightedMeanPrecision(only(h), only(J))
        @test_message_update_rule(
            node = NormalMeanVariance, target = :μ,
            cases = [(m = (out = NormalWeightedMeanPrecision(ξ, w), v = PointMass(2.0)),) => ExpectedWithLogScale(expected, 0)],
        )
        @test_message_update_rule(
            node = NormalMeanVariance, target = :out,
            cases = [(m = (μ = NormalWeightedMeanPrecision(ξ, w), v = PointMass(2.0)),) => ExpectedWithLogScale(expected, 0)],
        )
        @test_message_update_rule(
            node = NormalMeanPrecision, target = :μ,
            cases = [(m = (out = NormalWeightedMeanPrecision(ξ, w), τ = PointMass(0.5)),) => ExpectedWithLogScale(expected, 0)],
        )
        @test_message_update_rule(
            node = NormalMeanPrecision, target = :out,
            cases = [(m = (μ = NormalWeightedMeanPrecision(ξ, w), τ = PointMass(0.5)),) => ExpectedWithLogScale(expected, 0)],
        )
    end
end

@testitem "rules:Gaussian nodes: a known noise as a marginal, improper messages through it" tags = [:rules] begin
    # RxInfer gives a constant noise as a marginal, `q[:Σ]`: the same messages in natural parameters
    using StandardMessagePassingRules, MessagePassingRulesTestUtils, ExponentialFamily, BayesBase, Distributions
    using LinearAlgebra

    Σ = [0.5 0.1; 0.1 0.3]
    S = inv(Σ)
    ξ, W = [1.0, 0.0], [2.0 0.0; 0.0 0.0]
    A = S + W
    expected = MvNormalWeightedMeanPrecision(S * (A \ ξ), S - S * (A \ S))
    message = MvNormalWeightedMeanPrecision(ξ, W)
    @test_message_update_rule(
        node = MvNormalMeanCovariance, target = :μ,
        cases = [(m = (out = message,), q = (Σ = PointMass(Σ),)) => expected],
    )
    @test_message_update_rule(
        node = MvNormalMeanCovariance, target = :out,
        cases = [(m = (μ = message,), q = (Σ = PointMass(Σ),)) => expected],
    )
    @test_message_update_rule(
        node = MvNormalMeanPrecision, target = :μ,
        cases = [(m = (out = message,), q = (Λ = PointMass(S),)) => expected],
    )
    w = -0.2
    k = 1 + w * 2.0
    @test_message_update_rule(
        node = NormalMeanVariance, target = :μ,
        cases = [(m = (out = NormalWeightedMeanPrecision(0.4, w),), q = (v = PointMass(2.0),)) => ExpectedWithLogScale(NormalWeightedMeanPrecision(0.4 / k, w / k), 0)],
    )
    @test_message_update_rule(
        node = NormalMeanPrecision, target = :out,
        cases = [(m = (μ = NormalWeightedMeanPrecision(0.4, w),), q = (τ = PointMass(0.5),)) => NormalWeightedMeanPrecision(0.4 / k, w / k)],
    )
end
