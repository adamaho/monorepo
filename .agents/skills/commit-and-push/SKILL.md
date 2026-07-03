---
name: commit-and-push
description: >-
  Stage every change in the working tree, write a Conventional Commits message
  that accurately describes the diff, commit, and push to the current branch.
  Use this whenever the user asks to "commit", "commit and push", "commit my
  changes", "push this up", "save my work to git", "ship it", or otherwise wants
  their working changes committed — even if they don't say the words "conventional
  commit". Trigger it when someone wants a clean, well-formatted commit written
  for them rather than typing the git commands themselves.
---

# Commit and Push

Turn the current working-tree changes into one well-formed Conventional Commits
commit and push it to the current branch. The goal is a commit message a
teammate can read in isolation and understand _what changed and why_, without
opening the diff.

## Workflow

Do these in order. Steps 1–2 are read-only investigation; don't skip them — the
quality of the message depends entirely on understanding the diff first.

### 1. Read the current state

Run these together to understand what you're about to commit:

```bash
git status
git diff --stat
git diff                     # unstaged changes
git diff --staged            # already-staged changes
git branch --show-current
git log -n 5 --oneline       # match the repo's existing message style
```

Look at `git log` output specifically to learn the repo's conventions — the
types and scopes it already uses, whether subjects are capitalized, whether
bodies are common. Matching the surrounding history matters more than any rule
below.

### 2. Understand the change as a whole

Read the actual diff, not just the file names. Ask: what is the _one thing_ this
change accomplishes? The commit message describes intent and effect, not a
file-by-file inventory. "Renamed variable, added import, updated call site" is
three files but one change: "refactor: rename `x` to `y`".

If the working tree contains clearly unrelated changes (e.g. a bug fix _and_ an
unrelated dependency bump), note this to the user and ask whether they want
separate commits — but default to a single commit, since the request is to
commit everything.

### 3. Stage everything

```bash
git add -A
```

This stages new, modified, and deleted files. If `git status` showed files you
suspect shouldn't be committed (secrets, large binaries, `.env`, editor cruft,
debug logging), pause and flag them to the user before staging rather than
committing them silently.

### 4. Write the Conventional Commits message

Format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

- **type** (required): one of
  `feat` · `fix` · `docs` · `style` · `refactor` · `perf` · `test` · `build` ·
  `ci` · `chore` · `revert`. Pick by the change's _intent_:
  - `feat` — a new capability the user can now use
  - `fix` — corrects broken behavior
  - `refactor` — restructures code without changing behavior
  - `chore` — tooling, config, deps, housekeeping with no product impact
  - `docs`/`test`/`build`/`ci` — changes confined to those areas
- **scope** (optional but encouraged): the area of the codebase touched, in
  parentheses — a package, module, or directory (`auth`, `api`, `deps`,
  `infra`). Prefer scopes already used in `git log`. Omit it rather than invent
  a vague one.
- **subject** (required): imperative mood, lowercase start, no trailing period,
  ≤ 50 chars if you can. "add", not "added" or "adds". Describe the effect, not
  the mechanics.
- **body** (optional): when you include one, write it as `-` bullet points —
  one bullet per distinct change or reason, phrased as what the change does and
  why. Bullets scan far faster than a paragraph when a teammate is skimming
  `git log`, so prefer them over prose. Wrap each bullet at ~72 chars. Include a
  body whenever there's more than one notable change or the _why_ isn't obvious
  from the subject; skip it for small, self-explanatory changes, since a forced
  body is worse than none.
- **footer** (optional): issue references (`Closes #142`) or
  `BREAKING CHANGE: <description>` when the change is backward-incompatible. A
  breaking change may also be flagged with `!` after the type/scope, e.g.
  `feat(api)!: ...`.

Write the message to a temp file and commit with it so multi-line bodies and
special characters are preserved exactly:

```bash
git commit -F /path/to/scratchpad/commit-msg.txt
```

Do **not** add a `Co-Authored-By` trailer.

**Examples:**

Input: added a new WorkOS SSO login route and its callback handler
Output:

```
feat(auth): add WorkOS SSO login and callback routes

- add login route that redirects into the AuthKit flow
- add callback route that exchanges the code for a session
```

Input: fixed a crash when the events list is empty, plus a typo in a nearby comment
Output:

```
fix(events): guard against empty event list

- return the empty state instead of dereferencing events[0],
  which threw on an empty timeline
- fix a typo in the nearby add() doc comment
```

Input: bumped effect to the latest beta and updated the lockfile
Output:

```
chore(deps): upgrade effect to v4 beta
```

(The dependency bump is a single self-explanatory change, so it needs no body —
don't invent bullets to pad a one-line commit.)

### 5. Push to the current branch

```bash
git push
```

If the branch has no upstream yet, git will error asking you to set one — push
with the tracking flag:

```bash
git push -u origin "$(git branch --show-current)"
```

Push to whatever branch is currently checked out, as-is. Do not create a new
branch and do not second-guess the target branch — the user has asked to commit
to the current branch.

## After committing

Report back concisely: the commit hash and subject line, and confirmation that
the push succeeded (and to which branch). If the push failed (rejected,
diverged, network), surface the exact git error and stop — don't force-push or
try to reconcile without asking.

## When there's nothing to commit

If `git status` shows a clean tree, say so and stop. Don't create an empty
commit.
