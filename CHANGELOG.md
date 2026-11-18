# Changelog

All notable changes to StandardMessagePassingRules.jl are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

The changes below are to be released as 1.1.0.

### Changed

- The belief-propagation rules of `NormalMeanVariance`, `NormalMeanPrecision`,
  `MvNormalMeanCovariance` and `MvNormalMeanPrecision` towards `μ` and `out`, with a known
  noise, compute with a message in weighted-mean form, an `(Mv)NormalWeightedMeanPrecision`, in
  natural parameters: `W' = (I + W Σ)⁻¹ W` and `ξ' = (I + W Σ)⁻¹ ξ`. Such a message may be
  improper. For example, a site of cavity propagation (RxInfer's `LaplacePropagation()` and
  `ExpectationPropagation()`) may have a singular or indefinite precision. The rules now
  propagate it exactly. Before, they went through its moments, which silently replaced an
  indefinite precision with a positive definite one. Other messages are handled as before. The
  same applies to the rules that take the noise as a marginal, `q[:v]`, `q[:τ]`, `q[:Σ]` or
  `q[:Λ]`, since RxInfer passes a constant noise as a marginal.

## [1.0.0] - 2026-10-12

The first release: the standard nodes (the distributions, arithmetic, logic, the mixtures and Probit), developed in the
[ReactiveMP](https://github.com/ReactiveBayes/ReactiveMP.jl) repository, whose history this
repository keeps.

[Unreleased]: https://github.com/ReactiveBayes/StandardMessagePassingRules.jl/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/ReactiveBayes/StandardMessagePassingRules.jl/releases/tag/v1.0.0
