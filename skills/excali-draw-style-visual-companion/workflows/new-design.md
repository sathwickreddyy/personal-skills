# Start a High Level Design

Use when the user is building a system from scratch or has no baseline architecture.
The outcome is a small working design, a traceable request flow, and a clear reason
for each component.

## Establish the starting point

Use the conversation to identify the main user action, expected workload, and most
important constraint. Ask only for missing information that would change the design.
Group two or three short questions when useful, using ordinary conversation in
Claude Code or the current agent environment.

Example opening when these details are unknown:

> What are we building, and which user action should we trace first? What traffic
> or data volume should we plan for? Is latency, consistency, availability, or cost
> the main constraint? Rough estimates are enough.

If the system and goal are already clear, proceed with labeled assumptions for
unknown numbers. Do not repeat answered questions or make a beginner complete a
capacity questionnaire before seeing a design. If even the system's purpose is
missing, establish that before inventing a topology.

## Build the baseline

Begin with the smallest architecture that meets the stated requirements. Identify
the system boundary, clients, service responsibilities, and necessary stores or
external systems. Add infrastructure when a requirement explains its role.

Trace one concrete action from entry to response, naming the calls and data on each
connection. Show what is read, what is written, and the point at which the user gets
a response. Separate read and write paths when they differ. Identify asynchronous,
conditional, and parallel work without implying every request takes every branch.

Explain each unfamiliar component through its job in that flow. The reader should
be able to follow the request without already knowing terms such as cache, queue,
replica, or partition. Include the main failure behavior and the first likely
capacity or availability limit.

## Deliver and continue

Follow [render-diagram.md](render-diagram.md) to produce the editable diagram and
record its assumptions. Pair it with the ordered walkthrough, why it is sufficient
at this stage, and the main benefits and costs of the chosen design.

For an open learning session, end with one question tied to the remaining limit,
such as "Should the next stage handle more read traffic or a service instance
failure?" Skip this prompt for a finished deliverable. When the user has already
requested a progression, continue through it rather than asking to start each stage.

If scaling is part of the request, continue with [scaling.md](scaling.md). For an
example of a beginner conversation, consult only the "Starting from scratch"
section in [design-evolution.md](../references/design-evolution.md) when needed.
