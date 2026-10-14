---
name: create-spec
description: Create or refine a feature specification in this repository using independent requirements proposals, user decisions, and separate consistency, focus, and technical reviews. Use when the user asks to specify a feature or turn an idea into requirements.
---

# Create a specification

Convert the user's request into a focused specification of required behavior.
The user makes the decisions about requirements.

## Read the context

- Load the `sdd:locations` skill and resolve the locations.
- Keep technical implementation choices in the design.
- Read [assets/template-spec.md](assets/template-spec.md). If the user
  approves recording unresolved questions, also read
  [assets/template-spec-todo.md](assets/template-spec-todo.md).
- Inspect related specifications and their TODO files. Do not read source
  code or designs. The `sdd:spec-technical-reviewer` agent checks the
  specification against them.

Resolve repository paths from the repository root and template links from
this skill's directory. Resolve links in generated documents from their
destination, not from the template's location.

## Establish the requirements

Use independent agents to explore the user's input before drafting the
specification.

### Generate candidate requirements

Start three `sdd:spec-proposer` agents. Give each agent only the original request
and subsequent user decisions, in the user's words. Do not add your
interpretation or repository context.

Do not share an agent's output with the other agents before all agents
finish.

Agent proposals are candidates, not agreed requirements.

### Reconcile with the user

Compare all proposals with each other and with the original request.
Identify every disagreement, ambiguity, unsupported assumption, and
difference in scope or behavior. Agreement between agents does not
establish user intent.

Present one decision at a time. Explain the question, available
alternatives, and their practical consequences. You can recommend an
option, but the user chooses.

Wait for the user's answer before presenting the next decision. If the
answer is ambiguous, clarify that same decision before you continue.
Do not combine multiple decisions into one question.

Preserve decisions already explicit in the user's input. Obtain explicit
user agreement before adopting inferred or suggested requirements.
Do not treat silence as agreement. Use each answer to update the remaining
questions. The user must not need to decide the same issue twice.

Repeat clarification until the user agrees to the requirements or
explicitly defers specific decisions. Continue work on the agreed parts.
Do not decide unresolved behavior.

### Handle deferred decisions

Resolve each question with the user, or obtain explicit user approval to
record it in `<feature>_todo.md` in the specifications location. Do not
finish while a question
exists only in the conversation.

A deferred question remains unresolved and blocks the behavior that
depends on its answer. Do not present the specification as fully agreed
while such questions remain unresolved.

Apply this rule to questions discovered at any stage, including review.

## Write the specification

Use `<feature>.md` in the specifications location, with a lowercase
kebab-case feature name.
Keep one specification per feature. Update the existing specification when
it already owns the behavior. Describe current required behavior and keep
the document small and focused.

Follow the specification template. Remove irrelevant sections and replace
all placeholders.

- Describe purpose and scope concisely.
- Write observable acceptance criteria under `### AC-NN: Behavior name`.
- Use the same `AC-NN` numbering scheme for normal operation, boundary
  cases, and failures. Group criteria into sections only when it helps
  readability.
- State relevant initial conditions, actions, and expected results.
- Include boundary and failure behavior where it is relevant.
- Make measurable constraints explicit when agreed requirements support
  them.
- Keep architecture, implementation tasks, and completion status out of
  acceptance criteria.
- Keep test references in tests, not in the specification.

Acceptance criterion IDs describe the current specification. You can
renumber, replace, or remove them. When you change IDs or behavior, identify
the affected requirement references in tests.

Record questions in `<feature>_todo.md` in the specifications location
only with explicit user
approval. Follow the specification TODO template and link the specification.
Replace placeholders. For each question, explain the context, the necessary
decision, and the affected behavior or acceptance criteria. Keep
implementation task lists out of TODO files. When the user resolves a
question, update the specification and remove the question. Delete empty
TODO files.

Update documents in place. Use Git for history.

## Independent review

After drafting, request these independent reviews. The reviewers work
separately and do not see each other's findings.

- Start three `sdd:spec-consistency-reviewer` agents. Give each agent the path of
  the specification and the original request and subsequent user decisions,
  in the user's words.
- Start one `sdd:spec-technical-reviewer` agent. Give it the path of the
  specification.
- Start one `review:focus-reviewer` agent. Give it the original request and
  subsequent user decisions as the task, the path of the specification as the
  output, and [assets/template-spec.md](assets/template-spec.md) as a rule.

### Resolve findings

Merge the findings that describe the same problem. Correct supported
consistency and focus findings that preserve agreed requirements. Present
changes to requirements, unresolved questions, and reviewer disagreements
to the user, one decision at a time. Reviewers do not decide requirements.

A technical finding is a risk, not a defect. Present each technical finding
to the user, one at a time. Do not change a requirement because of a
technical finding without a user decision. Do not give the technical
findings to the other agents.

Record unresolved questions in the specification TODO file only with
explicit user approval. Do not silently expand scope or modify another
feature's requirements.

Ask the reviewer that reported a finding to recheck its substantive
correction. If a finding remains unresolved, report it explicitly. Do not
claim that the review passed.

If independent agents are unavailable, report that limitation. Do not
present a self-review as an independent review.

## Final check and report

Check these points:

- The specification contains every agreed requirement.
- Each criterion is testable.
- Related specifications are consistent.
- Unresolved decisions remain explicit.

Every specification requires a corresponding design. Identify each missing
or affected design and the work necessary before implementation. Identify
the tests and requirement references that the specification changes affect.
Implementation must update the affected tests and requirement references in
the same change as the requirements. It must follow the test rules of the
project. Do not expand a specification-only request into
implementation work.

When the user asks for a proposal, present the proposed content without
modifying files. Otherwise, create or update the requested specification
documents.

Report the resulting specification, all review outcomes, unresolved
questions, and necessary follow-up work. Distinguish specification
completion from implementation and verification.

## Commit

After the user approves the result, start one `sdd:committer` agent. Give it
the files that this skill created, changed, or deleted. Wait for its
report. Do not change a file before the commit exists. Report the commit.
