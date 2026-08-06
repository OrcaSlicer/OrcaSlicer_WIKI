# Host UI

`orca.host.ui` lets a plugin show host-owned UI: a native message box, a native progress
dialog, a modal HTML dialog, and non-modal interactive windows.

A plugin must never import its own GUI toolkit (PyQt/wxPython/tkinter): a `script` plugin
shares the host's UI thread, so a second toolkit's event loop would clash with wxWidgets, and
a `gcode` / `printer-agent` plugin runs off the main thread where toolkit calls would crash.
These host calls run on the main thread for you and block the calling code until they return.

## Dialogs and Windows

```python
# Native message box -> returns "ok" | "cancel" | "yes" | "no"
choice = orca.host.ui.message("Export finished. Open the folder?",
                              title="My Plugin", buttons="yes_no", icon="question")

# Modal HTML dialog -> returns the orca.submit() payload (dict), or None if dismissed
result = orca.host.ui.show_dialog(html="<h2>Hello</h2> ...", title="Report",
                                  width=820, height=600)

# Non-modal, persistent, interactive window -> returns a UiWindow handle
win = orca.host.ui.create_window(html=PAGE, title="Panel",
                                 on_message=self.on_message, on_close=self.on_close)
win.post({"type": "data", "rows": [...]})   # push a payload to the page
win.is_open()                                # bool
win.close()
```

`message` arguments: `buttons` is `"ok"|"ok_cancel"|"yes_no"|"yes_no_cancel"`; `icon` is
`"info"|"warning"|"error"|"question"`.

## Progress Dialogs

Use `create_progress_dialog()` for host-owned native progress. It returns a `ProgressDialog`
handle and also works as a context manager, so `close()` is called on exit. The default style
is `PD_APP_MODAL | PD_AUTO_HIDE`; add `PD_CAN_ABORT` if the user should be able to cancel.
`maximum` defaults to `100` (values `<= 0` are treated as `100`).

For script plugins, put the dialog inside `execute(self)` and update it between chunks of
work. Do not create the dialog and then run one long uninterrupted operation such as a single
`time.sleep(...)` or blocking network call; the dialog only gets useful repaint/cancel
checkpoints when you call `update()` or `pulse()`.

```python
style = (orca.host.ui.PD_APP_MODAL |
         orca.host.ui.PD_AUTO_HIDE |
         orca.host.ui.PD_CAN_ABORT |
         orca.host.ui.PD_ELAPSED_TIME |
         orca.host.ui.PD_REMAINING_TIME)

with orca.host.ui.create_progress_dialog("My Plugin",
                                         "Preparing...",
                                         maximum=len(items),
                                         style=style) as progress:
    for index, item in enumerate(items, start=1):
        process(item)

        # update() returns False if the dialog was closed or cancelled.
        if not progress.update(index, f"Processed {index}/{len(items)}"):
            return orca.ExecutionResult.skipped("Cancelled by user")
```

For indeterminate work, pulse the dialog instead of setting a numeric value:

```python
with orca.host.ui.create_progress_dialog("My Plugin",
                                         "Waiting for printer...",
                                         style=orca.host.ui.PD_APP_MODAL |
                                               orca.host.ui.PD_CAN_ABORT) as progress:
    while not finished():
        if not progress.pulse("Waiting for printer..."):
            return orca.ExecutionResult.skipped("Cancelled by user")
        wait_for_next_poll()
```

Handle methods:

| Python call | Effect |
|---|---|
| `progress.update(value, message="")` | set the determinate progress value; returns `False` if closed/cancelled |
| `progress.pulse(message="")` | advance an indeterminate progress step; returns `False` if closed/cancelled |
| `progress.start_pulse(interval_ms=100, message="")` | start timer-driven pulsing on the UI thread |
| `progress.stop_pulse()` | stop timer-driven pulsing |
| `progress.close()` | close the dialog |
| `progress.is_open()` | return whether the host still has the dialog registered |

Because `start_pulse()` has no return value, use explicit `update()` or `pulse()` calls at
natural cancellation points if the dialog includes `PD_CAN_ABORT`.

The style constants exposed by `orca.host.ui` mirror `wxProgressDialog`: `PD_APP_MODAL`,
`PD_AUTO_HIDE`, `PD_CAN_ABORT`, `PD_CAN_SKIP`, `PD_ELAPSED_TIME`, `PD_ESTIMATED_TIME`, and
`PD_REMAINING_TIME`. `PD_CAN_SKIP` is available for style parity, but the current Python
handle does not expose a separate "skip" state.

## Page Messaging

The page talks back through `window.orca`, which is injected automatically. The page supplies
raw, self-contained HTML/CSS/JS.

| JS call | Effect |
|---|---|
| `orca.postMessage(obj)` | deliver `obj` to the plugin's `on_message(obj)` |
| `orca.onMessage(cb)` | `cb(data)` runs for each `win.post(data)` (and modal pushes) |
| `orca.submit(obj)` | (modal) close and return `obj` from `show_dialog` |
| `orca.close()` | close the dialog / window |

## Theming

The host injects a stylesheet that matches OrcaSlicer's **current theme** (the active
light/dark mode, fonts, background/foreground, accent and border colors) before your page
renders. An unstyled page already looks native: `<body>`, headings, `button`,
`input` / `select` / `textarea`, `table`, links and scrollbars get sensible themed defaults,
and the theme is also exposed as CSS variables so you can match the rest of the UI:

| Variable | Meaning |
|---|---|
| `--orca-bg` | window/background color |
| `--orca-fg` | primary text color |
| `--orca-muted` | secondary / label text color |
| `--orca-accent` | accent color (buttons, links, focus) |
| `--orca-accent-fg` | text color on the accent |
| `--orca-border` | subtle border / separator / row-hover color |
| `--orca-font` | UI font stack |

The injected rules use only low specificity and never `!important`, so **any CSS your page
ships overrides them**. Prefer the variables (for example,
`border:1px solid var(--orca-border)`) over hardcoded colors so your dialog follows light
and dark mode automatically. The UI sample (`host_ui_panel.py`) relies on this and uses no
fixed colors.

## Threading and Lifecycle

- Host UI calls run on the main thread and **block the calling code** until they return
  (`message` / `show_dialog` when the dialog closes; `create_window` /
  `create_progress_dialog` as soon as the window/dialog is shown; progress updates after the
  host applies them). From a `script` plugin, already on the UI thread, they run inline; from
  a background-thread plugin (`gcode` / `printer-agent`) they marshal to the main thread
  first.
- `on_message(data)` runs on the **UI thread**; keep it quick; offload heavy work to a
  `threading.Thread` and push results back with `win.post(...)`.
- A **modal** dialog (`show_dialog`) fits a one-shot `execute()`. A **persistent** panel
  (`create_window`) is best opened from `on_load()` so it lives for the plugin's lifetime;
  the host closes a plugin's windows automatically when it is unloaded/reloaded or the app
  exits.
- Content is loaded as raw HTML; prefer **self-contained** pages (inline CSS/JS). There is no
  CSP and developer tools are disabled.
