# Explain Scaling and Compare Alternatives

Use for growth, bottlenecks, reliability improvements, pros and cons, or hypothetical
design choices. The outcome is a causal explanation of what a change improves,
what it costs, and what remains limited.

## Find the pressure

Start from the latest adopted design and workload. If there is no baseline and the
request needs one, first use [new-design.md](new-design.md).

Identify the constraint: request rate, hot keys, query cost, storage growth, CPU work,
connection counts, latency, or availability. Ask for a missing target only when it
would change the recommendation. When no measurements exist, label the bottleneck
as a hypothesis and say what observation would confirm it.

Use the user's numbers when available. Label estimates and assumptions, and show a
simple calculation when it explains a decision. For example, expected cache misses
are approximately lookup rate × (1 − hit rate). That estimates database traffic;
it does not establish database capacity or guarantee a speedup.

## Explain the choice

For each significant choice, cover the following with detail proportional to its
effect on the design:

| Question | What to explain |
|---|---|
| What triggers it? | What saturates or fails, and the evidence for that diagnosis. |
| What changes? | Responsibilities, data ownership, connections, and execution order. |
| What improves? | The latency, throughput, reliability, or cost benefit and its mechanism. |
| What does it cost? | Resources and operational work, plus relevant consistency, invalidation, lag, retries, duplicate handling, or ordering concerns. |
| What remains limited? | The next constraint, when to defer this choice, and a simpler or competing option when useful. |
| How would we check? | A metric or experiment that tests the expected benefit. |

Compare options against the same workload and goals. Distinguish stronger guarantees
from better average performance. Avoid presenting an estimate as a measurement.

## Show how the design evolves

Scale from the current stage only as far as the request requires. Replicas, caches,
queues, partitioning, and regions solve different problems; they are not mandatory
steps in a fixed roadmap. Show intermediate stages when the learner needs to see
which change produced which benefit.

For an adopted change, follow [revise-design.md](revise-design.md) so connections,
step order, failure paths, and the decision record stay in sync. For a hypothetical
comparison, keep the current stage intact and put alternatives in separate labeled
views or insets. Clearly identify any recommendation and its assumptions.

When creating or changing a diagram, use [render-diagram.md](render-diagram.md).
For an open learning session, finish with one next question tied to the remaining
constraint. Do not pause after each stage if the requested scope already includes it.

Consult the relevant section of [design-evolution.md](../references/design-evolution.md)
when a worked example would improve the explanation: service replicas for shared
database limits, caching for read traffic estimates, or analytics queues for
buffering and concurrency. These are examples, not architecture templates.
