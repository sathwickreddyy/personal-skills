# Render, Check, and Save the Diagram

Use whenever creating or editing a diagram, or for a visual-only refinement of an
existing design. For a visual-only request, preserve topology and behavior; follow
[revise-design.md](revise-design.md) if the request also changes the architecture.

## Choose the output and visual reference

Use the user's existing format and destination. If neither is specified, create a
self-contained local HTML file with inline SVG and return its path. Keep the source
editable and the diagram readable at full size. No hosted artifact service is required.

Read [visual-grammar.md](../references/visual-grammar.md), choose the image references
relevant to the layout or drawing vocabulary, and inspect those images before drawing.
Do not load every image by default or reread images already inspected in the task
unless needed. Learn the visual conventions; derive topology and counts from the
user's requirements.

## Show the behavior

Label the components and the calls, events, or data carried by meaningful arrows.
Make synchronous work, asynchronous work, conditions, and parallel branches explicit.
Show response timing and the relevant read/write and failure paths. Keep labels
legible and route long return paths around the outside when appropriate. Arrows must
terminate at their intended shapes and avoid unrelated nodes and labels.

For a staged explanation, show the baseline and current stage with matching labels,
ordered walkthroughs, changed connections, and concise pros and cons. Use separate
labeled views for a small comparison. A stage selector can help when several stages
would otherwise crowd one canvas. Keep comparison annotations distinct from live
connections in the current view.

## Keep enough state for the next follow-up

Keep a concise decision record alongside or within the editable artifact:

- Current adopted stage and links to previous meaningful stages.
- Named flows and stable component identifiers where the format supports them.
- Workload assumptions, constraints, and adopted decisions.
- Alternatives still under discussion and remaining limits or open questions.

Update that record with each architecture revision. Keep source and previous-stage
links valid when saving a new version. A proposed alternative must not silently
become the next turn's baseline. Pure styling edits do not need a new architecture
stage or repeated capacity analysis.

## Verify and deliver

Trace every affected flow end to end. Check endpoints, direction, branch conditions,
step order, read/write targets, response timing, and relevant failure paths against
the explanation. Inspect the rendered diagram with available tools for overlapping
labels, dangling connections, and arrows crossing unrelated nodes. If rendering
cannot be checked, state that limitation.

Return the artifact link and a short explanation of the design or revision, its
benefits and costs, and any material validation limits. Follow the active design
workflow for whether a next learning question is useful.
