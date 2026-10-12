# StandardMessagePassingRules

[![CI](https://github.com/ReactiveBayes/StandardMessagePassingRules.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/ReactiveBayes/StandardMessagePassingRules.jl/actions/workflows/CI.yml)
[![Docs: stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://reactivebayes.github.io/StandardMessagePassingRules.jl/stable/)
[![Docs: dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://reactivebayes.github.io/StandardMessagePassingRules.jl/dev/)
[![Coverage](https://codecov.io/gh/ReactiveBayes/StandardMessagePassingRules.jl/graph/badge.svg)](https://codecov.io/gh/ReactiveBayes/StandardMessagePassingRules.jl)
[![Code style: Runic](https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black)](https://github.com/fredrikekre/Runic.jl)

The message passing rules of the standard factor nodes, written with MessagePassingRulesBase:

- **distributions**: the univariate and multivariate normals in every parametrisation,
  `GammaShapeRate`, `Gamma`, `GammaInverse`, `Beta`, `Bernoulli`, `Categorical`, `Dirichlet`,
  `DirichletCollection`, `Poisson`, `Uniform`, `Wishart`, `InverseWishart`, `MatrixNormal`,
  `MatrixNormalWishart`, `MvNormalGamma`, `MvNormalWishart` and `HalfNormal`;
- **arithmetic**: `+`, `-`, `*` and `dot`, the functions being the nodes;
- **logic**: `AND`, `OR`, `NOT` and `IMPLY` over Bernoulli variables;
- **mixtures**: `NormalMixture`, `GammaMixture` and `Mixture`;
- **expectation propagation**: `Probit`, a binary output through the probit link, under its own
  algorithm `ProbitEP`;
- **helpers**: `StandaloneDistribution`, `Uninformative` and `diageye`.

Most nodes are ExponentialFamily's, Distributions' and Base's own types and functions; loading
the package is enough for an engine to find their rules. The distribution nodes' rules cover
belief propagation, mean field and structured factorisations under one default algorithm.

```julia
using StandardMessagePassingRules, MessagePassingRulesBase, ExponentialFamily, BayesBase

result = @call_message_update_rule(
    node = NormalMeanVariance, target = :out,
    m = (μ = NormalMeanVariance(0.0, 1.0), v = PointMass(2.0)),
)
getresult(result)                                          # NormalMeanVariance(0.0, 3.0)

MessagePassingRulesBase.rule_coverage(NormalMeanVariance)  # which rules exist
```

```julia
import Pkg; Pkg.add("StandardMessagePassingRules")
```

- Documentation: <https://reactivebayes.github.io/StandardMessagePassingRules.jl/stable/>.
  `make docs` builds it locally, into `docs/build`.
- Tests: `make test` runs the suite as CI does, ending with the rule-coverage gate: every rule
  must be selected by some test. `make test test_args="name:rules"` selects items by tag, by
  name or by file; `make help` lists the other targets.
- Depends on MessagePassingRulesBase, MessagePassingRulesApproximations (Probit's Gauss–Hermite
  energy), BayesBase, ExponentialFamily, Distributions and a few numerical packages
  (FastCholesky, MatrixCorrectionTools, SpecialFunctions, StatsFuns, LogExpFunctions,
  DomainSets), not on ReactiveMP. Julia 1.10 or later. MIT licence.
