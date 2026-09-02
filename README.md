# personal-skills

Portable [Claude Code](https://claude.com/claude-code) skills. Clone on any machine, link into `~/.claude/skills/`, and they become available in every session.

## Skills

| Skill | Use when |
|---|---|
| [visual-companion](skills/visual-companion/SKILL.md) | Explaining a technical flow, architecture, pipeline, DAG, state machine, or system behavior where a diagram lands faster than prose. |

## Install on a new machine

```bash
git clone https://github.com/<you>/personal-skills.git ~/personal-skills
mkdir -p ~/.claude/skills
ln -s ~/personal-skills/skills/visual-companion ~/.claude/skills/visual-companion
```

Symlinking means `git pull` updates the skill everywhere at once. If you'd rather not link, copy instead — but you'll have to re-copy after every change:

```bash
cp -R ~/personal-skills/skills/visual-companion ~/.claude/skills/
```

Either way, Claude Code picks the skill up on the next session start. Confirm with `/skills`, or just ask for something the description matches.

## Link everything at once

```bash
for d in ~/personal-skills/skills/*/; do
  ln -sfn "$d" ~/.claude/skills/"$(basename "$d")"
done
```

## Editing

`skills/<name>/SKILL.md` is the whole skill — YAML frontmatter plus markdown body.

- `name` — letters, numbers, hyphens only; must match the directory name
- `description` — **triggering conditions only**, starting with "Use when…". Do not summarize the skill's workflow here: Claude will follow the description and skip the body.

## About visual-companion

Produces a full-width, swimlaned architecture diagram as a published HTML artifact — not an inline chat sketch. Lanes by responsibility, numbered step markers in execution order, two-color flow encoding (control vs data), solid/dashed for sync vs async, and a shape key.

Shape vocabulary is fixed so diagrams stay scannable across sessions: vertical cylinder for databases, horizontal cylinder for queues and streams, circle for blob storage, stacked rects for worker pools, plain rect for services. The skill carries copy-pasteable SVG arc paths for the three that need real path math.

[`examples/highlight-reel-pipeline.html`](examples/highlight-reel-pipeline.html) is a reference output in the house style — open it locally to see the target for canvas size, lane headers, marker placement, and routing.
