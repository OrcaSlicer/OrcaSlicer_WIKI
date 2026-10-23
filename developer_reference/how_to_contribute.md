# How to Contribute

This page explains what makes a clear issue, and what reviewers need from each kind of pull request (PR). The short version, and the rules for using AI tools, are in [CONTRIBUTING.md](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/CONTRIBUTING.md) in the main repository.

Review is the slowest part of getting a PR merged. A small group of reviewers works through hundreds of open PRs in their spare time. If a PR has what they need, it is reviewed sooner and is more likely to be merged.

For questions about using OrcaSlicer, please ask on [Discord](https://discord.gg/P4VE9UY9gJ) or in [Discussions](https://github.com/OrcaSlicer/OrcaSlicer/discussions), not in an issue or PR.

- [Opening an Issue](#opening-an-issue)
- [Before You Start a PR](#before-you-start-a-pr)
- [What Every PR Needs](#what-every-pr-needs)
    - [Keep It Focused](#keep-it-focused)
    - [Write a Description Reviewers Can Use](#write-a-description-reviewers-can-use)
    - [Build and Test It Yourself](#build-and-test-it-yourself)
- [What Each Kind of PR Needs](#what-each-kind-of-pr-needs)
    - [Bug Fixes](#bug-fixes)
    - [New Features and Settings](#new-features-and-settings)
    - [Performance](#performance)
    - [Refactors](#refactors)
    - [GUI Changes](#gui-changes)
    - [Printer Profiles](#printer-profiles)
    - [Translations](#translations)
    - [Build, CI and Dependencies](#build-ci-and-dependencies)
    - [Tests](#tests)
    - [Documentation](#documentation)
- [After You Open the PR](#after-you-open-the-pr)
    - [CI Checks](#ci-checks)
    - [Waiting for Review](#waiting-for-review)
    - [If Your PR Is Closed](#if-your-pr-is-closed)
- [Other Ways to Help](#other-ways-to-help)

## Opening an Issue

A clear issue is easier to reproduce and fix. The issue forms ask for most of this.

- **Search existing issues first**, including closed ones. If the problem is already reported, add your details there.
- **Check the latest nightly build.** The problem may already be fixed.
- **Report one problem per issue.**
- **Add screenshots**, even when the description seems clear.
- **Attach the project file (`.3mf`) and the log.** The bug report form explains where to find them.
- **For a feature request, describe the problem** you want to solve, not only the solution.
- **Reply to questions** from people who try to reproduce it.

## Before You Start a PR

- **Search open PRs, not only issues.** Search for the issue number, the function name and the file you plan to change. PRs are often closed without merging because another PR already fixed the same thing. If a PR already exists, test it and comment there.
- **Claim an issue** by commenting `/assign-me` on it, so others know you are working on it.
- **Work on a branch**, not on your fork's `main`.
- **If this is your first PR, start with something small**, like a bug fix. Small PRs are merged more often and sooner.
- **Don't open many PRs at once.** If you already have several open, wait until some are merged before you open more. Review comments on one PR often apply to the others too. While you wait, see [Other Ways to Help](#other-ways-to-help).

## What Every PR Needs

### Keep It Focused

- **One topic per PR.** Put changes that belong together in one PR, such as a fix and its test, or the same fix in several places. Put unrelated changes, such as a refactor and a new feature, in separate PRs, so each one can be reviewed and approved on its own.
- **Don't split one change into many small PRs.** Reviewers then have to piece them back together, and PRs that depend on each other are hard to merge in the right order.
- **Don't reformat existing code.** `.clang-format` is for new files. In existing files, match the style of the code around your change. [AGENTS.md](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/AGENTS.md) describes the code style. With formatting changes in the diff, the real change is hard to find, and `git blame` is harder to use.
- **No unrelated edits.** Leave out typo fixes, renames and whitespace changes in code you are not otherwise changing.
- **Split large work into a series of PRs** when each part works and is useful on its own. Code PRs under 50 lines are merged about three times as often as PRs over 1,000 lines, and much sooner.

### Write a Description Reviewers Can Use

Use the [PR template](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/.github/pull_request_template.md), and keep its "How to Download Pull Requests Artifacts" link as the last line. Testers use that link. Every description should answer these questions. The section for each kind of PR lists what else reviewers need.

- **What does this change, and why is it needed?** If it fixes an issue, write `Fixes #1234` in the description, so GitHub closes the issue when the PR is merged. For several issues, repeat the word for each one, as in `Fixes #1234, fixes #1235`. If it fixes only part of an issue, mention `#1234` without `Fixes`, so the issue stays open.
- **Are there related PRs or issues?** If another PR touches the same code or bug, explain how yours is different.
- **How did you test it?** Give the OS, the printer profile and the steps. Attach a project file if the result depends on a model or settings. Name any automated tests you added.
- **What could you not test?** For example another OS, or a printer you don't own. Then someone who has it can check.

Write the title and description so they could be used in the release notes. Use short, plain sentences without idioms, because many reviewers read English as a second language. Your own English is fine, and so is a translation tool.

### Build and Test It Yourself

- **Build and run your change on your own platform before you open the PR.** CI then builds it on the other platforms. See [How to build OrcaSlicer](how_to_build).
- **Add an automated test when the code can be tested.** The best test fails without your change and passes with it. Run the tests before you push. See [Tests](#tests) and [How to run tests](how_to_test).
- **Read through your own diff** before you ask for review.

## What Each Kind of PR Needs

| Kind of PR | Label | Reviewers need to see |
| --- | --- | --- |
| [Bug fix](#bug-fixes) | `bug-fix`, `crash` | The cause, before and after, a test if possible |
| [Security fix](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/SECURITY.md) | `SECURITY` | A private report to the maintainers first |
| [New feature or setting](#new-features-and-settings) | `enhancement`, `QoL` | Why users need it, that it is off by default, real results |
| [Performance](#performance) | `optimization` | Measurements, and proof the output did not change |
| [Refactor](#refactors) | `optimization` | That behavior and output did not change |
| [GUI change](#gui-changes) | `UI/UX` | Screenshots before and after, on each platform you tested |
| [Printer profile](#printer-profiles) | `profile` | The validator passing, the version bump, real print results |
| [Translation](#translations) | `Localization` | Glossary terms used, placeholders unchanged |
| [Build, CI or dependencies](#build-ci-and-dependencies) | `build`, `dependencies` | Which platforms you built on |
| [Tests](#tests) | `test` | That the test fails when the behavior breaks |
| [Documentation](#documentation) | `documentation` | That it matches the current code |

### Bug Fixes

- **Reproduce the bug on the latest nightly build first.** It may already be fixed.
- **Explain why the bug happens** and why your change fixes it. Reviewers can't judge a fix without knowing the cause.
- **Show before and after** with the steps or project file from the issue. If there is no issue, put the steps in the PR.
- **Turn the steps from the issue into an automated test** when the code can be tested. See [Tests](#tests).
- **Keep the fix narrow.** If the same mistake exists in other places, fixing them in the same PR is fine. Put a larger rework of the code around the bug in a separate PR.
- **For a crash,** check that your fix matches the crash log or stack trace in the report. If your fix is for a similar-looking crash in other code, the issue stays open.
- **For a regression,** name the PR or commit that caused it if you can find it. Reviewers will check that the purpose of that change still works with your fix.

### New Features and Settings

- **Explain who needs it** and what problem it solves for them. If another slicer has it, say why OrcaSlicer users need it too.
- **Explain how users should choose a value** for each new setting, and whether OrcaSlicer could choose one by itself.
- **New behavior is off by default**, unless it was agreed otherwise. When the new option is off, existing output must not change.
- **Put new settings in Advanced or Expert mode**, not Simple mode.
- **Link each new setting to the wiki.** Pass the wiki page anchor as the second argument of `append_single_option_line`, and document the setting in the wiki. See [How to contribute to the wiki](how_to_wiki).
- **Avoid hard-coded limits** and special cases for one vendor or printer model in shared code. Make it a setting, or read it from the printer config.
- **Keep old projects and profiles working.** Many people have project files and profiles that we never see.
    - Never change what an existing setting means. Add a new key, and convert old values in `handle_legacy`.
    - Renaming a preset breaks user presets that inherit from it. Use `renamed_from` to keep the old name working.
- **Show real results.** For print quality, photos of real prints are best, because the preview does not show everything. For anything visible in the app, add screenshots.
- **Large features can be split.** Merge a working first part. Keep unfinished parts disabled by an option, or move them to a later PR.

`QoL` is for small usability improvements. Add screenshots of the before and after.

### Performance

- **Measure before and after** on the same machine. Name the models and settings you used and how you measured, and repeat each measurement a few times.
- **Show that the output did not change.** Compare the G-code from before and after your change, or explain every difference.
- **Be careful with shared state.** Much of the slicing code runs in parallel with TBB.

### Refactors

- **Say what the refactor makes possible.**
- **Don't change behavior.** Say how you checked, for example by comparing G-code from before and after.
- **Keep refactors separate** from fixes and features, and keep each step small.

### GUI Changes

- **Post before and after screenshots early**, and say which platforms you tested on. Reviewers decide from the screenshots whether they want the change, often before they read the code. Windows, macOS and Linux often behave differently. GUI code has no automated tests, so screenshots or a short recording are the evidence.
- **Use OrcaSlicer's own widgets**, such as `TextInput`, `ComboBox`, `SpinInput`, `CheckBox`, `RadioGroup` and `DialogButtons`, so the UI looks the same everywhere.
- **Scale sizes for high-DPI screens**, and check that your change looks right in dark mode.
- **Write each message as one translatable string** with placeholders, never as joined fragments. See "Writing translatable strings in the source" in [AGENTS.md](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/AGENTS.md).
- **Add the `UI/UX` label.** GUI testers watch this label. Add it to any change they should try, even if the layout does not change.

The [orca-wxwidgets skill](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/.claude/skills/orca-wxwidgets/SKILL.md) has detailed notes on how wxWidgets behaves in OrcaSlicer on each platform.

### Printer Profiles

Read [How to create profiles](how_to_create_profiles) first. The most common problems:

- **Bump the `version` in `resources/profiles/<Vendor>.json`** for every vendor you change. Without it, users don't receive your update. CI does not check this, so reviewers have to.
- **Run `scripts/check_profile.sh`** (or `.bat`) before you push.
- **Inherit instead of copying.** Base filament profiles on the existing generic or OrcaFilamentLibrary profiles. A vendor filament that only repeats the generic values won't be merged, so use the vendor's real values.
- **Keep the existing format.** Profile JSON uses tabs for indentation. Edit files in place and keep the key order.
- **Say how you tested it.** CI doesn't build test versions for PRs that change only profiles, so describe what you sliced and printed with the profile.

The [orca-profiles skill](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/.claude/skills/orca-profiles/SKILL.md) has notes on creating and changing profiles, and on fixing profile check failures.

### Translations

Read the [Localization and translation guide](localization_guide) and use the [Localization glossary](localization_glossary) for recurring terms. The editing rules are in the "Localization & translations" section of [AGENTS.md](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/AGENTS.md). The most important ones:

- **Only edit `msgstr`.** To fix the English text, change the string in the source code, not in a `.po` file.
- **Keep every placeholder** (`%s`, `%d`, `%1%`) and every `\n` exactly as in the `msgid`.
- **Don't re-wrap or reorder entries** you didn't change.
- **If you change a term, change it everywhere** in the language, so a setting and its tooltip use the same word.

The [orca-translations skill](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/.claude/skills/orca-translations/SKILL.md) has scripts to find untranslated entries and check a catalog.

### Build, CI and Dependencies

- **Say which platforms you built on.** CI doesn't cover every local build script and option.
- **Explain why a new third-party library is needed.** Credit it in the About dialog's copyright list. If it needs a new Linux system package, add it to `scripts/linux.d/debian` in the same PR.
- **For workflow changes,** run the workflow in your fork's Actions first, and link the run in the PR.

### Tests

Test-only PRs are welcome. [tests/AGENTS.md](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/tests/AGENTS.md) explains where a test goes and how to write it, and [How to run tests](how_to_test) explains how to build and run the tests.

- **Show that the test can fail.** Break the behavior it checks, or revert the fix it was written for, and confirm that the test fails.
- **Keep tests fast and reliable.** They run on every platform for every PR, so a slow or flaky test slows down everyone.

### Documentation

- **User documentation is in this wiki**, which has its own repository. See [How to contribute to the wiki](how_to_wiki).
- **Put design documents for developers in `docs/HLSD/`** in the main repository. Describe the design as it is now, not the history of how it got there.

## After You Open the PR

- **Add labels.** A bot will comment with instructions. Reply with `/bot add-label bug-fix`, or several labels separated by commas, such as `/bot add-label bug-fix, UI/UX`. Labels help the right reviewers and testers find your PR.
- **Leave "Allow edits by maintainers" turned on**, so a reviewer can push small fixes directly.
- **Mark the PR ready for review when it's finished.** Draft PRs are not merged.
- **Push new commits to the same PR.** Please don't close it and open a new one, because the review history is lost.
- **Don't force-push once a reviewer has commented.** Add new commits instead, so reviewers can see what changed since they last looked. PRs are usually squash-merged, so extra commits are fine.
- **Keep it up to date.** Fix merge conflicts by merging `main` into your branch, so that testers can download a working build.
- **Reply to every review comment**, including automated ones. You don't have to agree, but please say why.
- **Read the comments, not only the review status.** Most reviews here happen in comments, so a PR can be well reviewed even if it shows no approvals.

### CI Checks

Fixing a failing check is part of the PR, so please read the errors. If you're stuck, ask in the PR.

- **clang-tidy checks "include what you use".** Include the header for every symbol you use. Because of the precompiled header, a local build can succeed with a missing include. Run `scripts/run_clang_tidy.sh` (`scripts\run_clang_tidy.ps1` on Windows) to find them. See [How to run the clang-tidy check](clang_tidy).
- **CI builds treat compiler warnings as errors.** A clean build with one compiler doesn't mean the others are clean.
- **If this is your first PR,** CI waits until a maintainer approves the run. If the review asks for changes, a maintainer may approve the run only after you push them.

### Waiting for Review

Reviewers are volunteers, and a first response can take a while. While you wait, there are [other ways to help](#other-ways-to-help).

A reviewer may ask for changes, push a fix to your branch, or prefer a different approach, sometimes another PR. This is a normal part of review, and it happens to maintainers too. Maintainers have the final say, because they keep maintaining the code after it is merged. Likes and reactions on a PR are not a reason to merge it.

If you can't continue with a PR, please say so in a comment. Someone else may be able to finish it and credit your work.

### If Your PR Is Closed

We may close a PR that doesn't meet this guide. You're welcome to open a new one once it does. See [If your PR is closed](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/CONTRIBUTING.md#if-your-pr-is-closed) in CONTRIBUTING.md.

## Other Ways to Help

- **Test open PRs.** For PRs that change code, CI builds test versions you can download. See [Download Pull Requests Artifacts for Testing](how_to_download_pr_artifacts). Post what you tested, on which OS and printer, and whether it worked. Reporting that something fails is just as useful as reporting that it works.
- **Report bugs.** See [Opening an Issue](#opening-an-issue).
- **Reproduce bug reports.** Confirm the bug on the latest nightly build, and attach screenshots and a project file (`.3mf`) that reproduces it.
- **Review PRs.** You don't need write access to review. Read the change, try it, and say what you checked.
- **Translations, profiles and the wiki.** See [Printer Profiles](#printer-profiles), [Translations](#translations) and [How to contribute to the wiki](how_to_wiki).
