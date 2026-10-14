# Implement feature name

## Brief

Implement [specific outcome] according to the linked specification and
design.

Specification: `path/to/specs/feature-name.md`
Design: `path/to/designs/feature-name.md`

## Checklist

- [ ] [Step 1: Implement the behavior](#step-1-implement-the-behavior)
- [ ] [Step 2: Connect the runtime entry point](#step-2-connect-the-runtime-entry-point)

## Step 1: Implement the behavior

Files: [Concrete files to change]
Requirements: `feature-name/AC-01`

1. Add [test] asserting [required observable behavior].
2. Run [command] and confirm failure because [behavior is missing or incorrect].
3. Implement [specific change] in [owning module].
4. Run [command] and confirm the test passes.
5. Refactor [specific area, if needed] and rerun affected checks.

Verify: [Affected test, formatting, and lint commands with expected results]
Result: Pending.

## Step 2: Connect the runtime entry point

Depends on: Step 1.
Files: [Concrete files to change]
Requirements: `feature-name/AC-01`, `feature-name/AC-02`

1. Add an integration test exercising [runtime entry point] and asserting
   [required observable behavior].
2. Run [command] and confirm failure because [runtime integration is missing].
3. Connect [operation] to [runtime entry point] in [required execution order].
4. Run [command] and confirm the integration test passes.
5. Refactor [specific area, if needed] and rerun affected checks.

Verify: [Integration test, formatting, lint, and build commands with expected results]
Result: Pending.
