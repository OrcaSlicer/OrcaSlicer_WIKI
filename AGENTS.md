# Agent Guide — OrcaSlicer Wiki

This repository holds the **source Markdown** for the [OrcaSlicer Wiki](https://www.orcaslicer.com/wiki/).
On push to `main`, the content is published to the GitHub Wiki and deployed to the website automatically — there is no manual build step to run for a docs change. Every pull request is checked by CI validators (see [CI Checks](#ci-checks) below), so follow these rules to keep PRs green.

The authoritative contributor guide is [guides/how_to_wiki.md](guides/how_to_wiki.md). This file is the condensed, must-follow version for automated agents.

## Golden Rules

- **Edit the source Markdown at the repo root**, not the generated `wiki/` folder. `wiki/` is build output (produced by `build.sh`/`mkdocs`) — never hand-edit it.
- **Prefer Markdown over raw HTML.** The only sanctioned HTML is an `<img>` tag when you must constrain image size (see [Images](#images)).
- **Every new page must be linked** from another page (usually `home.md`) — unreferenced pages fail CI.
- **Every image under `images/` must be referenced** by at least one page — unreferenced images fail CI.
- Keep changes minimal and match the surrounding style, tone, and formatting of the page you edit.

## File & Directory Naming

Enforced by CI (`validate_snake_lower_case_markdown_filenames.yml`):

- Markdown filenames must be **lowercase `snake_case`**: `[a-z0-9]` words separated by `_` (e.g. `flow_ratio_calib.md`). `README.md` is the only exception.
- Use descriptive, unique names. Section pages carry a clarifying suffix — e.g. calibration pages end with `_calib.md` (`flow_ratio_calib.md`).
- Place pages in the matching top-level directory: `calibration/`, `printer_settings/`, `material_settings/`, `print_settings/`, `print_prepare/`, `general_settings/`, `user_profiles/`, `developer_reference/`, `guides/`, `releases/`, `web_extras/`.

## Internal Links

Enforced by CI (`validate_internal_link.yml`) — this is the most common source of PR failures:

- Link to a page by its **filename without the `.md` extension and without any directory**: `[Flow Ratio Calibration](flow_ratio_calib)`.
    - GitHub Wiki uses the filename as the page id, so `[text](calibration/flow_ratio_calib)` and `[text](flow_ratio_calib.md)` are both **invalid**.
- The document name in a link must be `snake_case`.
- Anchors point to headings and must be **`kebab-case`**: `[Seam](quality_settings_seam#scarf-joint-seam)`.
    - The anchor is the heading text lowercased, spaces → `-`, punctuation stripped. Duplicate headings get `-1`, `-2` suffixes.
    - A link may contain **at most one `#`**, and the referenced heading must actually exist in the target file.
- External links must include a scheme (`https://…`).

## Images

Enforced by CI (`validate_images.yml` + `unreferenced_images.yml`):

- Store wiki images in `images/`; section-specific images in a subfolder (e.g. `images/calibration/`, `images/InputShaping/`).
- **Always link images with raw GitHub URLs**, never relative paths:

    ```markdown
    ![calibration](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/calibration.png?raw=true)
    ```

- Hard requirements the validator checks for any `github.com/OrcaSlicer/...` image URL:
    - The `?raw=true` query **must** be present on `github.com/.../blob/...` URLs.
    - The **alt text must exactly equal the image filename without its extension** (e.g. file `calibration.png` → alt `calibration`).
    - The referenced file must actually exist in the repo (or remote OrcaSlicer repo).
    - For `<img>` tags, the `alt` attribute must appear **before** `src`.
- Do **not** use: relative paths, `user-content`/user-images/asset URLs, external/temporary hosts, or images that could be plain text (equations, code → use Markdown/Math/Mermaid).
- Only resize when necessary (e.g. thumbnails) using an `<img>` tag with a `height`/`width`; otherwise let the wiki size it:

    ```html
    <img alt="IS_damp_marlin_print_measure" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/IS_damp_marlin_print_measure.jpg?raw=true" height="200">
    ```

- Formats: **SVG** preferred (theme-adaptive), **PNG** for screenshots/transparency, **JPG** for photos. Only use images you have rights to.

To auto-fix these on existing pages, run [`fix-image-links.ps1`](fix-image-links.ps1) (repo root): `pwsh ./fix-image-links.ps1` (add `-DryRun` to preview). It rewrites relative/root-absolute paths (`](/images…`, `](../images…`) to the canonical `…/blob/main/<path>?raw=true` URL, appends a missing `?raw=true`, sets the alt text to the image filename, and moves `alt` before `src` in `<img>` tags. It only touches OrcaSlicer `blob`/`raw` asset URLs and local paths that resolve to a real file — badges, external/`user-attachments` URLs, fenced code blocks, `wiki/`, and `releases/` are left alone; unresolved local paths are reported, not rewritten.

## List Indentation

Enforced by CI (`validate_list_indentation.yml`):

- Nested list items must be indented by **0 or a multiple of 4 spaces**. 2-space indentation fails.

## Alerts / Callouts

Use GitHub alert syntax rather than bold/quote improvisation:

```markdown
> [!NOTE]
> Useful information.

> [!TIP]
> Helpful advice.

> [!IMPORTANT]
> Key information.

> [!WARNING]
> Urgent information.

> [!CAUTION]
> Risk or negative outcome.
```

### New-feature notes

When documenting a feature that is only in nightly/newer builds, add:

```markdown
> [!IMPORTANT]
> NEW FEATURE: **Feature short description**
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **<stable version at merge time>**.
```

Remove the note once a stable release that includes the feature ships.

## Code Blocks

Use fenced triple-backtick blocks and **specify the language** for highlighting (` ```json `, ` ```cpp `, ` ```markdown `, …).

## Structure & Navigation

- Give each page one clear objective; open with a short intro, then either a step-by-step guide (procedures/calibration) or a GUI-ordered reference.
- Add a table-of-contents list at the top of long pages.
- When adding a new page, link it from `home.md` under the correct category, and confirm it doesn't duplicate an existing page.

## Orca → Wiki Redirection

The OrcaSlicer GUI deep-links into these pages from [src/slic3r/GUI/Tab.cpp](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/slic3r/GUI/Tab.cpp) using the same `filename#anchor` scheme (validated weekly by `validate_tab_links.yml`). If you **rename a page or a heading that a Tab.cpp link targets**, that redirect breaks — flag it in the PR so the OrcaSlicer side can be updated. See [how_to_wiki.md](guides/how_to_wiki.md#orca-to-wiki-redirection) for the C++ patterns.

The `[Mode](option_mode)` and `[Variable(s)](built_in_placeholders_variables)` lines under an option's heading are **generated — never hand-edited**. Run [`sync-tab-options-to-wiki.ps1`](sync-tab-options-to-wiki.ps1) (repo root) to import/refresh them: it reads the option→page map from `Tab.cpp` and the option mode from `PrintConfig.cpp`, then inserts the metadata under the matching heading (and prunes it from unreferenced sections). When adding an option's docs, write only the heading + body, then run `pwsh ./sync-tab-options-to-wiki.ps1` (add `-DryRun` to preview). Manual edits to these lines are overwritten. See [how_to_wiki.md](guides/how_to_wiki.md#option-mode-and-variables-metadata).

## CI Checks

PRs touching Markdown run these validators (all must pass):

| Workflow | Checks |
| --- | --- |
| `validate_snake_lower_case_markdown_filenames.yml` | `.md` filenames are lowercase `snake_case` |
| `validate_internal_link.yml` | internal links: no dir/`.md`, snake_case doc, kebab-case existing anchor, ≤1 `#` |
| `validate_images.yml` | OrcaSlicer image URLs: `?raw=true`, alt == filename, alt-before-src, file exists |
| `validate_list_indentation.yml` | list indent is 0 or a multiple of 4 |
| `orphaned_files.yml` | every page is referenced by another page |
| `unreferenced_images.yml` | every `images/` file is referenced by a page |
| `validate_tab_links.yml` | (scheduled) Tab.cpp links resolve to real pages/anchors |

On push to `main`: `publish_docs_to_wiki.yml` mirrors content to the GitHub Wiki, and `deploy-wiki.yml` builds with mkdocs and deploys to the website.
