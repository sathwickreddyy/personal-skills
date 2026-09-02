# personal-skills

Portable [Claude Code](https://claude.com/claude-code) skills. Clone on any machine, link into `~/.claude/skills/`, and they become available in every session.

## Skills

| Skill | Use when |
|---|---|
| [sathwick-se-arch-visual-companion](skills/sathwick-se-arch-visual-companion/SKILL.md) | Explaining a technical flow, architecture, pipeline, DAG, state machine, or system behavior where a diagram lands faster than prose. |

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
skills/                # every directory here ships with the plugin
tools/
```

Adding a skill means adding a directory under `skills/` — no manifest edit needed. Bump `version` in **both** manifests when you want installed copies to pick changes up, then validate before pushing:

```bash
claude plugin validate . --strict
```

## Editing

`skills/<name>/SKILL.md` is the whole skill — YAML frontmatter plus markdown body.

- `name` — letters, numbers, hyphens only; must match the directory name
- `description` — **triggering conditions only**, starting with "Use when…". Do not summarize the skill's workflow here: Claude will follow the description and skip the body.

## About sathwick-se-arch-visual-companion

Produces a full-width, swimlaned architecture diagram as a published HTML artifact — not an inline chat sketch. Lanes by responsibility, numbered step markers in execution order, two-color flow encoding (control vs data), solid/dashed for sync vs async, and a shape key.

Shape vocabulary is fixed so diagrams stay scannable across sessions: vertical cylinder for databases, horizontal cylinder for queues and streams, circle for blob storage, stacked rects for worker pools, plain rect for services. The skill carries copy-pasteable SVG arc paths for the three that need real path math.

**DAGs get a different layout.** Anything that is a workflow, job graph, or state machine is drawn in AWS Step Functions grammar instead — vertical spine, explicit `Start` dot and `Succeed`/`Fail` terminals, split and join dots, dashed `PARALLEL` and `MAP` containers, and dashed amber catch edges labelled with the error. Containers are mandatory: two boxes side by side could be alternatives or concurrent work, and only the container says which.

### The reference image

The skill's first instruction is to look at its reference image before drawing anything. That's what keeps the output from drifting session to session — rules describe the style, but the picture *is* the style.

```
skills/sathwick-se-arch-visual-companion/
├── SKILL.md
├── references/
│   └── video-upload-architecture.png   # the one image Claude looks at
└── examples/                           # text sources, read on demand for exact numbers
    ├── video-upload-architecture.html  # the reference, rendered above
    ├── order-fulfilment-dag.html       # Step Functions grammar, for DAGs
    └── highlight-reel-pipeline.html     # DAG with a recovering catch, parallel-in-map
```

They live *inside* `skills/sathwick-se-arch-visual-companion/` on purpose — a symlinked skill directory has to carry them along, so they can't sit at the repo root.

**Exactly one reference image, on purpose.** Every PNG costs roughly 2.5k tokens each time the skill runs, so the reference is the single diagram that carries the whole vocabulary: every shape, a curved cross-lane read, a long return edge up the right margin, 12 numbered steps across 3 lanes. Extra angles live in `examples/` as HTML, which is text — cheap to grep, and only opened when a specific number is needed.

If you add a diagram worth anchoring on, prefer extending the canonical example over adding a second image.

### Regenerating the reference

After editing the canonical example, re-render so the image stays in sync:

```bash
./tools/render-references.sh
```

Uses headless Chrome. Override the binary with `CHROME=/path/to/chrome` on Linux.
