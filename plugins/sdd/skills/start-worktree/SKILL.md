---
name: start-worktree
description: Create a Git worktree and a branch for one feature, and move the session into it. Use before create-spec when the user starts work on a feature, or when the user asks for a worktree.
---

# Start a worktree

Create one worktree for one feature. The specification, the design, the
plan, and the code of the feature are made in it.

## Name the feature

Use the feature name that the user gives, in lowercase kebab-case. The
specification file gets the same name. If the user gave no name, ask.

## Check the state

- Find the repository root and the name of its directory.
- Inspect the Git status. Uncommitted changes stay in the current tree and
  are not in the new worktree. List them to the user. Do not commit, stash,
  or move them.
- If a branch or a directory with the target name exists, stop and ask the
  user. Do not reuse or remove it.

## Create the worktree

- Branch: `<feature>`, from the current commit.
- Directory: `<repository>-<feature>`, next to the repository directory.

Run `git worktree add -b <feature> ../<repository>-<feature>` from the
repository root. Then move the session into the new directory. Do all
later work for the feature there.

## Report

Report the directory, the branch, and the base commit. Name the
uncommitted changes that are not in the worktree. The next step is the
`sdd:create-spec` skill.
