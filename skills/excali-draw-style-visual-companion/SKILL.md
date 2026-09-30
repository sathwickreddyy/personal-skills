---
name: excali-draw-style-visual-companion
description: Use when building a high level system design from scratch, evolving an existing architecture through follow-up requests, explaining scaling choices and their tradeoffs, or refining Excalidraw-style architecture diagrams.
---

# Architecture Design Companion

Help the user build, understand, and evolve an architecture through diagrams and
request walkthroughs. Use this file to select the instructions needed for the task.

## Route the request

Choose by the requested outcome and the current conversation. Read the primary
workflow before starting; do not load all workflows or references by default.

| User's request | Read first |
|---|---|
| Start from scratch; create the first high level design | [New design](workflows/new-design.md) |
| Add, remove, or replace components; change connections or execution order | [Revise a design](workflows/revise-design.md) |
| Handle growth; diagnose a bottleneck; compare options, pros and cons, or "what if" scenarios | [Scaling and alternatives](workflows/scaling.md) |
| Draw an established design; improve layout, shapes, labels, or arrow routing | [Render a diagram](workflows/render-diagram.md) |

For a combined request, start with the first applicable design task and follow its
links as needed. For example, "start small and show how it scales" uses new design
then scaling; "add Redis" uses revision, with scaling guidance if evaluating its
benefits is part of the request. Read the rendering guide whenever producing or
editing a diagram. A discussion without diagram changes need not load it.

The rendering guide routes to visual references. The design workflows link to
optional worked examples. Open only the relevant example sections and images.

## Shared rules

- Use the conversation and current adopted design as the source of truth. Label
  proposed components and workload assumptions explicitly.
- Ask only for missing information that materially changes the design. Use ordinary
  conversation in Claude Code or the current agent; no special question tool is required.
- Follow-ups continue the existing design. Keep hypothetical alternatives distinct
  from adopted revisions, and finish the requested scope without approval at each stage.
- Reference images teach visual grammar. They do not prescribe architecture,
  component counts, or a fixed scaling roadmap.
