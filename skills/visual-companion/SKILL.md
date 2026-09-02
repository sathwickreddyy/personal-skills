---
name: visual-companion
description: Use when explaining any technical flow, architecture, pipeline, DAG, state machine, or system behavior and the reader would understand it faster from a diagram - request lifecycles, microservices, queues, workers, ETL, retries and backoff, dead-letter queues, caching, DB read/write paths, fan-out/fan-in, orchestration, or algorithm execution.
---

# Visual Companion

Produce a visual companion for the technical concept currently being discussed.

Use the conversation as the source of truth. Do not invent components, steps, or behavior that were not established.

## Look at the reference before you draw

**Read `references/video-upload-architecture.png` once, before drawing.** It is the house style, and looking at it is faster and more reliable than reconstructing the style from the rules below. Do not skip it because the rules "sound clear" — the rules are a checklist for a picture you have already seen, not a substitute for seeing it.

There is exactly one reference image, deliberately: it carries the whole vocabulary in a single read — every shape, a curved cross-lane read, a long return edge up the right margin, 12 numbered steps across 3 lanes. Read it once per task, not once per diagram, and never read it twice.

`examples/*.html` are the source for that reference plus a second diagram (`highlight-reel-pipeline`, which adds an amber degraded path and a fan-out/fan-in). They are text — open one **only** to look up an exact number you are about to guess at: gap width, node size, label offset, cylinder path math. Grep for the value; do not read the file whole.

## Core principle

Never produce a generic overview diagram. The visual must explain **behavior**, not just structure:

- what starts the flow
- what happens next
- what runs in parallel
- what is synchronous vs asynchronous
- what state changes, what is read, what is written
- how failures and retries are handled
- how the flow completes

If the diagram would still be correct with the arrows removed, it is the wrong diagram.

## Choose the visual form

| Concept | Form | Show |
|---|---|---|
| Request flow, service interaction, end-to-end behavior | **Runtime flow** | entry point, processing path, downstream calls, async steps, persistence, completion |
| Dependency graph, job pipeline, staged workflow | **DAG / pipeline** | tasks as nodes, dependencies as edges, fan-out/fan-in, parallel branches, terminal outputs |
| Status changes, lifecycle | **State transition** | states, triggers, retry loops, failure and terminal states |
| Two systems or approaches | **Comparison** | system A left, system B right, separate paths, trade-offs annotated near the relevant part |
| Algorithm or process execution | **Step-by-step walkthrough** | ordered steps, decisions, loops, outputs, short "why" annotations |

Route on the verb, not the noun: "walk me through" → flow; "what depends on what" → DAG; "what happens when it fails" → state.

## Canvas — this is not a chat-inline diagram

**Always render as a full-width HTML artifact.** Never the inline chat widget: it caps at ~680px and forces 4–6 nodes, which produces a thin sketch instead of a companion.

- hand-authored inline `<svg>`, `viewBox="0 0 1700 H"`, wrapped in a container with `overflow-x: auto`
- 8–14 nodes and 8–12 numbered steps is the normal size, not the exception
- content margins x=90 to x=1610
- publish it — the reader zooms, revisits, and shares it

## Swimlanes

Divide the canvas into horizontal lanes by **responsibility**, separated by dotted rules. Name each lane with what it is *and* what it carries:

```
CONTROL PLANE · requests + metadata
DATA PLANE · the bytes
COMPLETION PATH · one writer back to the DB
```

Header style: uppercase, `letter-spacing: 0.14em`, 14px, colored to match that lane's flow color, left-aligned at the content margin.

Lanes read left-to-right independently. A lane may start indented, under wherever its input arrives from the lane above — that vertical drop is the transition, and it should be numbered like any other step.

**Routing rule:** a lane header occupies roughly x=90–470. Never route a vertical through that band; drop into a lane either right of x=500, or below the header baseline.

## Color encodes flow, not sequence

Two flow colors maximum, plus structure:

| Role | Use |
|---|---|
| control / metadata flow | steel blue |
| data / byte flow | green |
| structure (box strokes, text, step markers) | near-black navy |
| degraded / failure path | amber, and only that |
| datastore fill | pale blue · storage fill: pale mint · services: white |

Never color by step index. A node's color says which flow it belongs to.

## Numbered step markers

Every meaningful edge carries a filled navy circle (r≈14) with a white number, centered on the arrow. Number in execution order across the whole diagram, lanes included. Side paths get numbers when they are part of the sequence; pure annotations do not.

## Shapes — be consistent, and key them

| Node | Shape |
|---|---|
| service / process | white rect, 2px navy stroke |
| worker pool, N instances | the same rect with 2 offset rects stacked behind it |
| database | **vertical cylinder**, pale blue fill |
| queue / stream / topic | **horizontal cylinder**, white fill |
| blob / object storage | **circle**, pale mint fill |
| file output / artifact | rect, pale mint fill, horizontal rule near the top |
| state | compact labeled block |

The silhouette is what makes the canvas scannable at a glance. Never approximate a cylinder with a rounded rect, and never draw a queue as a rect with tick marks. Three shapes need real arc math — use these:

**Database** — vertical cylinder, lip radius `ry=16`. Body, then the front edge of the top ellipse:

```svg
<path d="M1360 166 v78 a115,16 0 0 0 230,0 v-78 a115,16 0 0 0 -230,0 z" fill="var(--db-fill)" stroke="var(--node-stroke)" stroke-width="2"/>
<path d="M1360 166 a115,16 0 0 0 230,0" fill="none" stroke="var(--node-stroke)" stroke-width="2"/>
```

For a box at `(x, y, w, h)`: start at `x, y+ry` · `v h-2ry` · `a w/2,ry 0 0 0 w,0` · `v -(h-2ry)` · `a w/2,ry 0 0 0 -w,0 z`. Text sits **below the lip** — center it at `y + h/2 + 8`.

**Queue** — horizontal cylinder, cap radius `rx=16`. Body, then the interior curve of the left cap:

```svg
<path d="M576 580 h208 a16,38 0 0 1 0,76 h-208 a16,38 0 0 1 0,-76 z" fill="var(--node-fill)" stroke="var(--node-stroke)" stroke-width="2"/>
<path d="M576 580 a16,38 0 0 0 0,76" fill="none" stroke="var(--node-stroke)" stroke-width="2"/>
```

For a box at `(x, y, w, h)`: start at `x+rx, y` · `h w-2rx` · `a rx,h/2 0 0 1 0,h` · `h -(w-2rx)` · `a rx,h/2 0 0 1 0,-h z`. Center text at `x + w/2 + rx/2` so it clears the cap.

**Blob / object storage** — plain circle, `r≈54`:

```svg
<circle cx="670" cy="620" r="54" fill="var(--store-fill)" stroke="var(--store-stroke)" stroke-width="2"/>
```

A circle holds far less text than a rect: title only, ≤12 characters. The subtitle goes beside it, not inside.

Arrows meet these shapes at the silhouette, not the bounding box — enter a cylinder at its flat side, a circle at `cx ± r`.

## Arrows

- **solid** = synchronous / direct call
- **dashed** = asynchronous, event-driven, or exceptional
- route with L-bends; a line must never cross a box it does not connect to, and crossing another line is a layout failure — reroute
- fan-out and fan-in use a shared riser into a junction, not N independent diagonals

Label the edges that carry information. Use **monospace** for anything that is literally code or a wire format, sans for prose:

```
POST /videos/init          INSERT videos row · status = pending_upload
publish job                UPDATE status=ready
consume message            retry after backoff
```

Multi-line annotations beside an arrow are fine. Sentences on an arrow are not.

## Panels

Below the canvas, add the panels that make it self-contained:

- **SHAPE KEY** — every shape used, with its meaning. Only shapes actually on the canvas.
- **SCHEMA / PROPS** — the data model or type the flow moves around, when one exists.

## Before shipping

- [ ] Does it answer: where it begins, what's next, what's parallel, what's async, where data is written, what happens on failure, how it completes?
- [ ] Does every arrow direction, dash style, and color mean something?
- [ ] Do any two lines cross? Do any lines cross a box they don't connect? Reroute.
- [ ] Does any vertical cut through a lane header?
- [ ] Does the longest label fit its box? (`width = max(title_chars × 8.5, subtitle_chars × 6.6) + 24`)
- [ ] Are the step numbers in true execution order?

## Common mistakes

| Mistake | Fix |
|---|---|
| Rendered inline, 4 boxes, 680px | Full-width artifact, lanes, 8+ nodes |
| Architecture snapshot with no flow | Show what triggers what, in order |
| Rainbow color per step | Color by flow; navy for structure |
| Unlabeled arrows | Label with the actual call, event, or state write |
| Every component in the system | Cut to the mechanisms the explanation needs |
| Lines crossing each other | Reroute with L-bends; move a node if needed |
| Every node drawn as a rounded rect | Cylinders and circles get real arcs — the silhouette is the signal |
| Cycle drawn as a ring | Linear layout with a labeled return arrow |
