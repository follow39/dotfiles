---
name: locations
description: Resolves where spec-driven development stores specifications, designs, and plans in the current repository. Load it at the start of each spec-driven development skill.
user-invocable: false
---

# Locations

Resolve the three locations before other work.

If the project instructions have a "Spec-driven development locations"
section, use the locations that it gives. Use the default for each location
that the section does not give.

| Location | Default |
| --- | --- |
| Specifications | `docs/specs/` |
| Designs | `docs/designs/` |
| Plans | `${CLAUDE_PLUGIN_DATA}/plans/<repository>/` |

- Resolve a relative location from the root of the current worktree.
- `<repository>` is the directory name of the original repository: the
  first entry of `git worktree list`. All worktrees of a repository share
  its plans.
- Create the plans location if it does not exist.

Give each agent that you start all three resolved locations, under the
heading "Locations".
