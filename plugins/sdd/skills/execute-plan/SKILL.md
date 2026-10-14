---
name: execute-plan
description: Execute an existing reviewed implementation plan one step at a time, verify the results, and obtain independent review of each step. Use when the user asks to implement or resume a plan; does not create missing plans.
---

# Execute a plan

Execute the plan's actions in order and record verified results.

## Check the prerequisite

Load the `sdd:locations` skill and resolve the locations.

Use the plan that the user or the current conversation identified. If no
plan is identified, ask which plan to implement. If the plan is missing or
unreviewed, report that to the user and stop before implementation. Do the
same if you cannot establish its review status. Do not invoke `sdd:create-plan`
automatically.

Read the plan, linked specification and design, and related TODO files.
Inspect Git status. Confirm the plan still matches the current documents
and code.
When you resume a plan, verify recorded progress before relying on items
marked as done.

## Execute each step

1. Select the next unfinished step whose dependencies are complete.
2. Start one `sdd:step-implementer` agent. Give it the path of the plan and the
   step.
3. If the implementer stops, find which document has the problem: the plan,
   the design, or the specification. Present the finding to the user. After
   the decision, update the plan if the decision changes it, and send the
   decision to the same implementer.
4. When the implementer reports the step as complete, request these
   independent reviews. The reviewers work separately and do not see each
   other's findings.
   - Start one `sdd:step-correctness-reviewer` agent. Give it the path of the
     plan, the step, and the report of the implementer.
   - Start one `review:quality-reviewer` agent. Give it the changes of the step as
     the output.
   - Start one `review:focus-reviewer` agent. Give it the step as the task and the
     changes of the step as the output.
5. Merge the findings that describe the same problem. Present findings and
   unclear decisions to the user one at a time. Send the user's decisions
   to the same implementer. Ask the reviewer that reported a finding to
   recheck its substantive correction.
6. Update the step's `Result` with actual verification and review outcomes.
   Mark its checklist item as done only when its actions, verification, and
   review are complete and no blocking finding remains.
7. Start one `sdd:committer` agent. Give it the files that the implementer
   changed. Wait for its report. Do not start the next step and do not
   change a file before the commit exists. If the committer reports a
   problem, stop and present it to the user.
8. Continue with the next step.

Only one agent changes files at a time. Do not start the implementer or the
committer while another agent still works on the same step.

A review can report no findings. Passing tests do not replace independent
review. If a reviewer is unavailable, the step remains unfinished. An
expected intermediate failure is a successful verification only when it
matches the plan's stated expectation. Never report an unexecuted or skipped
check as passing.

## Handle gaps and findings

For each finding or unclear decision, explain the evidence, alternatives,
consequences, and recommendation. Wait for the user's answer and clarify it
before presenting the next decision. Do not silently invent missing actions
or verification instructions, change requirements, or expand the design.

Present changes that require the `sdd:create-spec`, `sdd:create-design`, or
`sdd:create-plan` skill to the user. Resume dependent work only after the
revision and review of the affected documents and plan.

Resolve each question, or obtain explicit user approval to record it in the
relevant specification or design TODO file. Use the template of the skill
that owns that file. Recording a blocking question does not complete the
step. Skip required tests only with explicit user approval and report the
resulting verification gap.

## Finish

Confirm that the completed steps cover every acceptance criterion and that
the plan's integration checks pass. Report the code changes, actual check and
review outcomes, and unfinished work. Do not claim overall completion while
required implementation, verification, or independent review is pending.
