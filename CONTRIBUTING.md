# Contributing

Conventions for this repository. They apply to everyone, humans and AI agents alike.

The [README](README.md) documents *how* alerts, tests and linting work. This file documents what we
expect from a contribution.

## Changelog, PR body and comments

Each of these answers a different question. Keep them in their lane:

- **`CHANGELOG.md` — what changed.** One short line under `## [Unreleased]`, in the right
  `Added` / `Changed` / `Fixed` / `Removed` section. No root cause, no mechanism, no rationale.
- **PR body — why it changed.** The problem, the reasoning, the alternatives you dropped.
- **Code comments — why it is written this way.** Context on technical choices a future reader
  would otherwise have to guess at. Not a restatement of the query.

Two things must never appear in the changelog or in comments, since both are published with the
Helm chart:

- **No real cluster, installation or customer information.** Describe the alert, not the incident
  it came from.
- **No links to private repositories.** Public links (`docs.giantswarm.io`, upstream projects) are
  fine. `runbook_url` annotations pointing at the intranet are an established exception.

Keep a PR to a single purpose. A bugfix PR fixes the bug; unrelated gaps you spot along the way
belong in their own issue or PR.

## Alerts

See [Alert structure](README.md#alert-structure) and [Best practices](README.md#best-practices) for
the full picture. The points that get missed most often:

- **`severity: page` pages someone, day or night.** Pick the out-of-hours behaviour deliberately
  with `cancel_if_outside_working_hours`:
  - `"true"` — never pages outside working hours, on any installation. The right default, and what
    most alerts here use.
  - `{{ include "workingHoursOnly" . }}` — pages outside working hours on `stable` installations
    only; on `stable-testing` the alert is muted out of hours. Use this when a real production
    outage warrants waking on-call at 3am, but a testing installation does not.
  - `"false"`, or leaving the label out — pages outside working hours everywhere, testing
    installations included. Rarely what you want; say why in the PR body.

  See [Alert routing](README.md#alert-routing) and [Inhibitions](README.md#inhibitions).
- `area`, `team` and `severity` are mandatory labels — see
  [Mandatory labels](README.md#mandatory-labels).
- Before adding an alert, consider whether an
  [SLO rule](https://github.com/giantswarm/sloth-rules#how-to-create-a-slo) fits better. It usually
  means better signal and less noise.

## Tests

New and modified alerts need unit tests — see [Testing](README.md#testing).

When you change an existing alert, grep for the alert name first: there is probably a test that
asserts on it. Changing a `runbook_url` means updating the test that checks it.

## Opening the PR

- Use a [conventional commit](https://www.conventionalcommits.org/) title (`feat:`, `fix:`,
  `docs:`, …) — the `semantic-pull-request` check enforces it.
- Work through the checklist in the PR template, including requesting review from the oncall area
  as well as your team.
