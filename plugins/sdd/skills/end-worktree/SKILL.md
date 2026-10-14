---
name: end-worktree
description: Finish the work in a feature worktree. Merge the feature branch or create a pull request, as the user chooses. Use when the user says that a feature is complete or asks to end a worktree.
---

# End a worktree

Bring the result of one feature worktree back to the original repository.

## Find the worktree

Use the worktree of the current session. If the session is in the original
repository, use the feature name that the user gives. If the user gave
none, ask.

The original repository is the first entry of `git worktree list`.

Load the `sdd:locations` skill and resolve the locations.

## Check the state

- If a plan of this feature in the plans location has an unfinished step,
  tell the user and ask if the work ends now.
- Inspect the Git status of the worktree. A merge moves only commits. If
  uncommitted changes exist, list them and ask the user which of them
  belong to the result. Start one `sdd:committer` agent for those files and
  wait for its report.

## Integrate

Use the method that the user named: merge or pull request. If the user
named none, ask. Do not choose a method.

### Merge

The target is the branch that is checked out in the original repository.
Name the target and ask the user to confirm it. Run the merge in the
original repository.

If Git reports a conflict or refuses the merge, stop and report. Do not
resolve a conflict and do not force the merge.

### Pull request

Push the feature branch and create the pull request. Use the feature name
as the title and the purpose of the specification as the description.
Report its address. Keep the worktree.

If the repository has no remote, report that and ask the user again.

## Remove the worktree

Do this only after a successful merge, and only after the user confirms.

1. Move the session to the original repository.
2. Remove the worktree directory with `git worktree remove`.
3. Delete the feature branch with `git branch -d`.

If Git refuses one of these operations, stop and report. Do not force it.

## Report

Report the merge commit or the pull request, and what you removed.
