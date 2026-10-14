---
name: engineering-principles
description: Engineering principles for performance, encapsulation, DRY, KISS, YAGNI, and dependency selection. Use when designing, planning, implementing, or reviewing technical changes.
---

# Engineering principles

Apply these principles when designing, planning, implementing, or reviewing
technical changes. Explain concrete consequences where relevant. Do not add
boilerplate sections or abstractions only to satisfy a checklist.

## Performance and resource bounds

Identify expected workload, input scale, execution frequency, and relevant
CPU, memory, allocation, I/O, or network costs.

Account for hot-path complexity and potentially unbounded work or storage.
Handle resource limits, cleanup, and overload as the agreed behavior
requires.

Meet agreed performance requirements and resource budgets. Distinguish
measured facts, estimates, and unknowns. Do not invent numerical budgets or
claim an optimization is necessary without evidence.

When a choice depends on uncertain performance, use a focused measurement
with representative workloads and a decision criterion. Record the workload
and results. Obtain agreement in the specification for user-visible limits
or degraded behavior.

## Encapsulation and ownership

Give state and invariants clear owners. Keep interfaces narrow and expose
only what consumers need. Make mutation, concurrency, and lifecycle
boundaries explicit.

Respect module boundaries. Keep dependency direction explicit and avoid
cycles or access to another feature's internal state.

Interact with neighboring features through their contracts. Include only
the integration changes that the agreed scope needs.

## DRY: avoid duplicated knowledge

Reuse existing behavior and shared invariants where ownership is clear.
Do not maintain the same business rule in more than one place.

Do not introduce a shared abstraction only because code looks similar.
Consider whether the responsibilities change together and whether reuse
would create unnecessary coupling.

## KISS: prefer the simplest sufficient approach

Choose the simplest approach that satisfies the specification and known
constraints. Justify additional layers, indirection, configuration,
dependencies, or concurrency by a concrete need.

Simplicity includes understandable failure handling and maintenance,
not only fewer lines of code.

## YAGNI: implement current needs

Do not introduce speculative extension points, generic frameworks, caching,
configuration, or future features without a current requirement.

Distinguish constraints needed now from hypothetical future needs.
Do not expand the work to include unapproved scope.

## Dependency selection and reuse

Review external dependencies carefully before adding them. Check whether
existing repository code or dependencies already meet the need.

Compare the dependency's benefit with its integration, maintenance, and
runtime costs. Prefer reuse when it fits the feature's responsibilities and
ownership boundaries. Do not couple unrelated features only to share code.
