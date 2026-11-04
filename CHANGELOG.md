# Changelog

All notable changes to StandardMessagePassingRules.jl are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- The Gaussian nodes' belief-propagation rules between their two Gaussian edges, with a known
  noise (`NormalMeanVariance`, `NormalMeanPrecision`, `MvNormalMeanCovariance` and
  `MvNormalMeanPrecision`, towards `μ` and `out`), take a message in weighted-mean form in
  natural parameters: `W' = (I + W Σ)⁻¹ W`, `ξ' = (I + W Σ)⁻¹ ξ`, an `(Mv)NormalWeightedMeanPrecision`.
  Such a message may be improper, a site of cavity propagation with a singular or indefinite
  precision, which the rules now propagate exactly; through its moments, an indefinite precision
  was silently replaced by a positive definite one. Other messages go as before.

## [1.0.0] - 2026-10-12

The first release: the standard nodes (the distributions, arithmetic, logic, the mixtures and Probit), developed in the
[ReactiveMP](https://github.com/ReactiveBayes/ReactiveMP.jl) repository, whose history this
repository keeps.

[Unreleased]: https://github.com/ReactiveBayes/StandardMessagePassingRules.jl/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/ReactiveBayes/StandardMessagePassingRules.jl/releases/tag/v1.0.0
