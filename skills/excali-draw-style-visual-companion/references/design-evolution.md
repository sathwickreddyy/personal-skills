# Worked Design Evolution

This is a teaching example for conversations and revisions. Choose the architecture
and sequence from the actual requirements. All traffic figures below are illustrative
assumptions, not benchmarks or capacity guarantees.

## Starting from scratch

User: "Help me design a URL shortener from scratch. I want to understand how it scales."

Useful opening when these details are unknown:

> Which should we trace first: creating a short link or redirecting a visitor?
> Roughly how many redirects per second should we plan for, and can links be edited
> or expired? If you are unsure, I can start with a small read-heavy workload and
> state the assumptions.

For this example, assume both actions are needed, traffic starts small, and a short
code's destination is immutable. Introduce the baseline:

- **Create:** client → service → database insert → service → client receives code.
- **Redirect:** client → service → database lookup → service → client receives redirect.

Explain the database uniqueness constraint on short codes and the not-found branch.
Keep it to one service and one database while they meet the workload. The benefit
is simple operation and a straightforward read after creation; limits include one
service instance's capacity and availability, and the database's read/write budget.

Useful next prompt: "Should we explore more redirect traffic or surviving a service
instance failure?" If the user already requested both, work through both.

## Follow-up: more service instances

User: "Scale the service horizontally."

Show client → load balancer → service fleet → database, then the return path.
Replace the client-to-single-service connection. Depict fleet membership with
stacked cards and label the shared database. Preserve the create and redirect flows.

Explain that requests can reach different instances, so process-local state cannot
be required for correctness. Service replication can add application capacity and,
with health checks and sufficient remaining capacity, tolerate an instance loss.
It adds routing and deployment work, does not remove the database bottleneck, and
may increase database connection pressure. Check service utilization, error rates,
latency, and database connection saturation before claiming improvement.

## Follow-up: cache redirects

User: "Add Redis. Show exactly how the arrows and steps change."

Use Redis as a cache for immutable code-to-URL lookups in this example. Keep the
current entry path through the load balancer and service fleet. Show the complete
current design plus this focused connection comparison:

| Connection before | Connection after | Reason |
|---|---|---|
| Service → DB lookup for every redirect | Service → Redis GET | Check the cached mapping first. |
| Unconditional service → DB lookup | Service → DB lookup only on a cache miss | Keep the database as the source of truth. |
| No cache-fill connection | Service → Redis SET after a successful DB lookup | Make later reads eligible for a hit. |
| DB insert for creation | DB insert for creation | Creation still commits to the source of truth. |

Number the redirect flow by branch:

| Step | Action |
|---|---|
| 1 | Client request reaches a service instance through the load balancer. |
| 2 | Service reads Redis. |
| 3H — hit | Service returns the redirect using the cached mapping; this branch ends. |
| 3M — miss | Service reads the database. A missing mapping returns not found and ends this branch. |
| 4M — found | Service attempts a bounded cache fill. |
| 5M | Service returns the redirect, even if the cache fill failed. |

The hit and miss branches are alternatives. Draw cache and database responses as
well as requests where their direction is needed to understand the flow. Label a
cache timeout fallback separately from a miss, use a bounded timeout, and explain
the risk of suddenly sending all traffic to the database.

For an assumed 10,000 lookups/s and a 90% hit rate, database lookup traffic is roughly
`10,000 × (1 − 0.90) = 1,000/s`, excluding writes, retries, and other reads. This is a
traffic estimate, not proof that the database can handle the resulting workload.
Benefits are fewer database reads and potentially faster hits. Costs include cache
memory, another dependency, and cold-cache or hot-key pressure. If links can later
be edited or expired, revisit invalidation and freshness before reusing this design.
Check hit rate, database query rate, and tail latency; a low hit rate can make the
extra lookup a poor tradeoff. Query or index improvements may be the simpler option.

## Follow-up: add asynchronous analytics

User: "Record redirect analytics without waiting for the analytics write."

Clarify the delivery requirement if unknown: "Can analytics lose occasional events,
or must each recorded event survive a process failure?" That choice changes when
the redirect can be returned. For this example, assume the requested contract is to
receive durable broker acknowledgment before returning, while deferring the analytics
database write to a worker. State that this still adds broker latency and does not
make the redirect and event atomically successful.

Add service → queue publish → worker → analytics store. Show the acknowledgment
back to the producer separately from worker processing, and keep the existing
lookup/cache path visible. The queue is an additional branch, not a replacement
for the code-to-URL lookup.

- **Request order:** resolve mapping → publish event → broker acknowledgment → return
  redirect. State the chosen behavior if publication fails or times out; for this
  example, fail the request after a bounded timeout to preserve the stated contract.
- **Worker order:** consume event → write analytics → acknowledge processing.
- **Concurrency:** once the broker accepts the event, worker processing and delivery
  of the producer acknowledgment can proceed independently. The worker may finish
  before or after the client receives the redirect, even before the producer
  receives its acknowledgment. Do not force these branches into one total order.
- **Failure path:** retry transient worker failures; route exhausted or nonretryable
  events to a DLQ when that handling is part of the design. Deduplicate by event ID
  so redelivery does not double-count the same event. Define separately whether
  client retries count as new visits. Do not claim global processing order or
  exactly-once delivery from the presence of a queue.

Explain the gain: workers can scale separately, and the queue can buffer bursts.
Compared with writing analytics synchronously, request latency excludes the analytics
database write. Costs include delayed analytics,
broker availability on the request path, duplicate handling, backlog management,
and operating the queue. A queue buffers excess work; it does not raise sustainable
worker throughput by itself. Check queue age, arrival and processing rates, retry
rate, and end-to-end analytics delay.

## Carry the design into the next turn

Keep a concise record with the current artifact, for example:

```text
Current stage: service fleet + redirect cache + asynchronous analytics
Flows: create, redirect hit/miss, cache timeout fallback, publish, analytics worker
Assumptions: immutable mappings; sample traffic and hit rate are estimates
Decisions: DB is source of truth; broker acknowledgment is required before redirect
Current limits: cache outage may overload DB; broker outage blocks redirects
Next question: prioritize protecting the DB or revisiting analytics availability?
```

Update this record when a choice is adopted. A proposed alternative should not
silently become the starting architecture for the next follow-up. Keep previous
stage links and source paths valid when saving a new version.
