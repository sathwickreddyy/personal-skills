# Revise an Existing Design

Use for adding, removing, or replacing components; changing constraints; or changing
connections and execution order. The outcome is an updated design and walkthrough
with an explicit account of what changed and why.

## Recover the current design

Read the latest adopted diagram, its editable source, and its decision notes.
Carry forward the user's constraints and decisions unless the request changes them.
If the referenced design is unavailable, ask for its path or a brief description;
do not reconstruct it from a style reference.

A concrete request such as "add caching" authorizes that revision. Ask only when an
unresolved choice would materially change behavior. Treat a hypothetical "what if"
as a labeled alternative; use [scaling.md](scaling.md) when it needs a comparison of
benefits and costs. An alternative does not become the adopted design automatically.

For a meaningful architecture revision, keep the previous stage available. Preserve
recognizable component names, stable node and edge IDs where supported, and positions
of unaffected groups where possible. Step numbers are not component identities.

## Update connections and order together

1. Identify the requested change and the requirement or bottleneck it addresses.
2. Determine the full topology change: added or removed components, added or removed
   connections, redirected endpoints, and changes to labels, conditions, protocols,
   and synchronous or asynchronous behavior.
3. When inserting a component between A and B, replace A → B with the actual new
   path. Keep the direct connection only if a real fallback or bypass still uses it,
   and label the condition. A new box beside the old arrows is not a completed edit.
4. Trace the affected paths again. Recompute the execution order, data reads and
   writes, failure handling, and response point. Number each named flow by dependency;
   use branch labels for alternatives and mark concurrency explicitly. Do not impose
   one total order across independent requests, workers, or queue partitions.
5. Reroute arrows and adjust nearby groups and boundaries. Update the walkthrough at
   the same time. Distinguish visual relocation from semantic changes such as moving
   work after an early acknowledgment.

## Make the revision understandable

Show the full current design alongside a compact before/after path or connection
table. Include only meaningful changes in the comparison, for example:

| Before | After | Reason |
|---|---|---|
| A → B for every request | A → cache; A → B on a miss | Avoid repeated reads when the value is cached. |

Use text labels and restrained highlighting for additions and changes. Removed
edges belong in the comparison; they must not appear as live connections in the
current view. Explain benefits, costs, new failure modes, remaining limits, and a
metric or experiment that would check whether the change helped.

For several requested changes, show intermediate stages when they clarify cause
and effect. Complete the requested scope without requiring approval after every
teaching step. Use [render-diagram.md](render-diagram.md) to render, check, and save
the current stage and its updated decision record.

If a concrete example would help, read only the relevant replica, cache, or analytics
section in [design-evolution.md](../references/design-evolution.md). The cache example
shows conditional connection changes; the analytics example distinguishes response
timing from worker order.
