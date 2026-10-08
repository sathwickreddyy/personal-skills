# personal-skills

Portable [Claude Code](https://claude.com/claude-code) skills for designing and explaining system architecture, packaged as a self-hosted plugin marketplace. Install on any machine with two commands and they're available in every session.
The current plugin release is **1.3.0**. It contains two complementary skills: one for building and evolving a system design, and one for explaining an established technical flow with a detailed visual.

## Skills

| Skill | Use when |
|---|---|
| [system-architecture-visual-companion](skills/system-architecture-visual-companion/SKILL.md) | Explaining a technical flow, architecture, pipeline, DAG, state machine, or system behavior where a diagram lands faster than prose. |
| [excali-draw-style-visual-companion](skills/excali-draw-style-visual-companion/SKILL.md) | Starting a high-level system design, revising an existing architecture, exploring scaling choices, or refining an Excalidraw-style diagram. |

## Install on a new machine

This repo is its own marketplace, so there's nothing to clone:

```bash
claude plugin marketplace add sathwickreddyy/personal-skills
claude plugin install sathwick-skills@sathwick-marketplace
```

Restart Claude Code and every skill under `skills/` is live. Confirm with `claude plugin list`.

Pull later changes with:

```bash
claude plugin update sathwick-skills
```

The same two steps work from inside a session as `/plugin marketplace add …` and `/plugin install …`.

### Or clone and symlink

Use this when you want to edit the skills in place and see changes without a plugin update:

```bash
git clone https://github.com/sathwickreddyy/personal-skills.git ~/personal-skills
mkdir -p ~/.claude/skills
for d in ~/personal-skills/skills/*/; do
  ln -sfn "$d" ~/.claude/skills/"$(basename "$d")"
done
```

**Pick one or the other.** Installing the plugin while a symlink of the same skill sits in `~/.claude/skills/` loads it twice.

## Repo layout

```
.claude-plugin/
├── plugin.json        # this repo is the `sathwick-skills` plugin
└── marketplace.json   # …and the `sathwick-marketplace` that serves it
skills/
├── system-architecture-visual-companion/  # flow and DAG explanations
└── excali-draw-style-visual-companion/     # design, revision, and scaling workflows
tools/                 # reference-image rendering helper
```

Adding a skill means adding a directory under `skills/` — the manifests never enumerate them, so there's no list to keep in sync.

## Publishing a change

**1. Edit, bump, validate.** Bump `version` in **both** manifests — `plugin update` compares against it, so a push without a bump is invisible to installed copies.

```bash
claude plugin validate . --strict
```

**2. Push.**

```bash
git push origin main
```

**3. Update each machine.** Two commands, not one:

```bash
claude plugin marketplace update sathwick-marketplace
claude plugin update sathwick-skills@sathwick-marketplace
```

Then restart Claude Code, and confirm with:

```bash
claude plugin details sathwick-skills
```

### Two things that look like failures but aren't

**`plugin update` right after a push reports nothing to do.** It compares against a *cached* copy of the marketplace listing, which doesn't refresh on its own — so it's still reading the old version and is correctly finding no change. Always run `marketplace update` first. That's step 3's first line, and it's the step that's easy to drop.

**Bare `claude plugin update sathwick-skills` fails with `Plugin "sathwick-skills" not found`** even while `plugin list` shows it installed and enabled. Use the qualified `plugin@marketplace` form.

### Renaming a skill

The directory name, the `name:` in the SKILL.md frontmatter, and the id Claude loads it under are all the same string — rename all of them together or the skill won't load. Under the plugin it's addressed as `sathwick-skills:<skill-name>`, so keep the skill name from restating the plugin's. A rename retires the old id, so it always needs a version bump.

## Editing

`skills/<name>/SKILL.md` is the whole skill — YAML frontmatter plus markdown body.

- `name` — letters, numbers, hyphens only; must match the directory name
- `description` — **triggering conditions only**, starting with "Use when…". Do not summarize the skill's workflow here: Claude will follow the description and skip the body.

## About excali-draw-style-visual-companion

This skill starts with a small working architecture, traces a concrete request from entry to response, and explains why each component is present. Follow-up requests can revise the adopted design, compare alternatives, or explore scaling and reliability trade-offs. Its four focused workflows cover new designs, revisions, scaling, and diagram rendering.

It keeps an editable diagram and a decision record so later revisions retain the current stage, assumptions, and earlier design choices. When no output format is requested, it creates a self-contained local HTML file with inline SVG. Its visual grammar and example diagrams are in [`references/`](skills/excali-draw-style-visual-companion/references/); the examples guide drawing conventions without fixing the architecture.

## About system-architecture-visual-companion

Produces a full-width, swimlaned architecture diagram as a published HTML artifact — not an inline chat sketch. Lanes by responsibility, numbered step markers in execution order, two-color flow encoding (control vs data), and solid/dashed for sync vs async. No shape key — the nodes are labelled and the lane headers carry the flow colors, so a legend restating them is noise.

Shape vocabulary is fixed so diagrams stay scannable across sessions: vertical cylinder for databases, horizontal cylinder for queues and streams, circle for blob storage, stacked rects for worker pools, plain rect for services. The skill carries copy-pasteable SVG arc paths for the three that need real path math.

**DAGs get a different layout.** Anything that is a workflow, job graph, or state machine is drawn in AWS Step Functions grammar instead — vertical spine, explicit `Start` dot and `Succeed`/`Fail` terminals, split and join dots, dashed `PARALLEL` and `MAP` containers, and dashed amber catch edges labelled with the error. Containers are mandatory: two boxes side by side could be alternatives or concurrent work, and only the container says which.

### The reference image

The skill's first instruction is to look at its reference image before drawing anything. That's what keeps the output from drifting session to session — rules describe the style, but the picture *is* the style.

```
skills/system-architecture-visual-companion/
├── SKILL.md
├── references/
│   └── video-upload-architecture.png   # the one image Claude looks at
└── examples/                           # text sources, read on demand for exact numbers
    ├── video-upload-architecture.html  # the reference, rendered above
    ├── order-fulfilment-dag.html       # Step Functions grammar, for DAGs
    └── highlight-reel-pipeline.html     # DAG with a recovering catch, parallel-in-map
```

They live *inside* `skills/system-architecture-visual-companion/` on purpose — the skill directory is the unit that travels, whether it ships in the plugin or is symlinked, so they can't sit at the repo root.

**Exactly one reference image, on purpose.** Every PNG costs roughly 2.5k tokens each time the skill runs, so the reference is the single diagram that carries the whole vocabulary: every shape, a curved cross-lane read, a long return edge up the right margin, 12 numbered steps across 3 lanes. Extra angles live in `examples/` as HTML, which is text — cheap to grep, and only opened when a specific number is needed.

If you add a diagram worth anchoring on, prefer extending the canonical example over adding a second image.

### Regenerating the reference

After editing the canonical example, re-render so the image stays in sync:

```bash
./tools/render-references.sh
```

Uses headless Chrome. Override the binary with `CHROME=/path/to/chrome` on Linux.
