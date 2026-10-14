---
name: workflow
description: Entry point for spec-driven development. Runs the worktree, specification, design, plan, execution, and integration steps in order, with user approval between steps. Use when the user starts or continues a feature, or asks which spec-driven development step comes next.
---

# Spec-driven development

## Workflow

Use the skill that matches the requested work. Each skill owns its procedure
and templates.

1. Use `sdd:start-worktree` to create a worktree and a branch for the
   feature. Do the next steps in that worktree.
2. Use `sdd:create-spec` to establish required behavior, resolve
   requirements with the user, and review the specification.
3. Use `sdd:create-design` to establish the technical approach, resolve
   design decisions, and review the design.
4. Use `sdd:create-plan` to organize the agreed design into concrete TDD
   steps, resolve unclear decisions, and review the implementation plan.
5. Use `sdd:execute-plan` to execute the reviewed plan one step at a time,
   verify results, and independently review each step.
6. Use `sdd:end-worktree` to merge the feature branch or create a pull
   request.

Reuse existing specifications, designs, and reviewed plans when applicable.

Obtain explicit user approval for each workflow step before proceeding
to the next.

If work reveals a requirement, design, or plan change, present it to the
user. Revise and review the affected document through its owning skill
before continuing dependent implementation.

Present findings and unclear decisions to the user one at a time.
Record deferred questions in TODO files only with explicit user approval.
Deferring a blocking question does not complete the affected work.

When the user requests a proposal, present it without modifying files.
