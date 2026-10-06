# Lifecycle Events

Any capability can observe application lifecycle moments (project open/save, slicing, plate and
object edits, preset changes, printer and job activity) by overriding `on_lifecycle_event()`.
It is defined on the root `orca.PythonPluginBase`, so it is available on every capability type,
and the default does nothing.

The payload is deliberately small and generic: it identifies *what* happened, not the full
state. To learn more, call a targeted API from the handler, such as
`orca.host.plater().model()` after an `ObjectAdded` event (see [Host](host)).

```python
import orca

class ProjectWatcher(orca.script.ScriptPluginCapabilityBase):
    def get_name(self): return "Project Watcher"
    def execute(self): return orca.ExecutionResult.success()

    def on_lifecycle_event(self, event, ctx):
        if event == orca.LifecycleEvent.ProjectAfterSave:
            print("saved", ctx.name)
        elif event == orca.LifecycleEvent.SlicingJobComplete and ctx.code == orca.LifecycleEvtCode.Error:
            print("slicing failed:", ctx.msg)
```

## Events

`orca.LifecycleEvent` values (also exported at module level, e.g. `orca.SliceStarted`):

| Group | Events |
|---|---|
| Project (3MF) | `NewProject`, `ProjectOpened`, `ProjectBeforeSave`, `ProjectAfterSave`, `ProjectClosed`, `ProjectDirtyChanged` |
| Slicing | `SliceStarted`, `SliceGeometryFinished`, `GCodeExportStarted`, `GCodeExportFinished`, `SlicingJobComplete` |
| Plate / model editing | `ObjectAdded`, `ObjectDeleted`, `ObjectTransformed`, `ObjectChanged`, `ObjectRenamed`, `PlateCreated`, `PlateDeleted`, `PlateSelected`, `PlateRenamed` |
| Presets | `PresetSelected`, `PresetSaved` |
| Printer / device | `PrintStateChanged`, `DeviceOnline`, `DeviceOffline`, `DeviceDiscovered`, `DeviceSelected`, `UploadStarted`, `UploadFinished` |
| Print / send jobs | `PrintJobStarted`, `PrintJobFinished`, `SendJobStarted`, `SendJobFinished` |

## Payload

`ctx` is an `orca.LifecycleEventContext` with read-only fields. Fields an event does not use
keep their defaults (empty string, `index = -1`, `dirty = False`).

| Field | Meaning |
|---|---|
| `name` | the primary subject: a project/output path, model, object, plate or preset name, device id, upload file name. May be empty |
| `code` | `orca.LifecycleEvtCode`: `Ok`, `Error` or `Warn`. For start and state-change events `Ok` only means the event occurred |
| `msg` | optional human-readable detail; not a stable parsing contract |
| `id` | a stable object/model identifier, when the source has one |
| `previous_name` | the old name, for rename events |
| `device_id` | the device, for print/send job events |
| `job_id` | the job/task identifier, when the originating queue provides one |
| `source` | the originating subsystem or operation, suitable for filtering |
| `index` | a plate, object or volume index, when the source uses one |
| `dirty` | the aggregate project dirty state, for `ProjectDirtyChanged` |

What the current sources fill in:

| Event | Payload |
|---|---|
| `NewProject` | no subject; only `code` |
| `ProjectOpened`, `ProjectBeforeSave`, `ProjectAfterSave`, `ProjectClosed` | `name` = project file / project name |
| `ProjectDirtyChanged` | `dirty`, `source` |
| `SliceStarted`, `SliceGeometryFinished` | `id` = model id, `name` = model name |
| `GCodeExportStarted`, `GCodeExportFinished` | `id`, `name`, `msg` = output path; on failure `code = Error` and `msg` also carries the error |
| `SlicingJobComplete` | `id`, `name`; `code` is `Warn` with `msg = "cancelled"` when cancelled, `Error` with the error text on failure |
| `ObjectAdded`, `ObjectDeleted` | `name` = object name |
| `ObjectTransformed` | `msg` = `moved`, `rotated`, `scaled`, `arranged` or `auto_oriented`; `name` for interactive moves/rotations/scales |
| `ObjectChanged` | `name`, `id`, `source = "geometry"` (and `index` when known) |
| `ObjectRenamed` | `name`, `previous_name`, `id`, `index`, `source` = `object` or `volume` |
| `PlateCreated`, `PlateDeleted`, `PlateSelected` | `name` = plate name, `index` = plate index |
| `PlateRenamed` | `name`, `previous_name`, `index` |
| `PresetSelected` | `name` = preset, `msg` = preset type (`print`, `filament`, `printer`, ...) |
| `PresetSaved` | `name` = preset, `msg` = `new` or `overwrite` |
| `PrintStateChanged` | `name` = device id, `msg` = new print status |
| `DeviceOnline`, `DeviceOffline`, `DeviceDiscovered`, `DeviceSelected` | `name` = device id |
| `UploadStarted`, `UploadFinished` | `name` = uploaded file name; on failure `code = Error`, `msg` = error |
| `PrintJobStarted`, `PrintJobFinished`, `SendJobStarted`, `SendJobFinished` | `name` = project name, `device_id`, `source` (`print_job`, `send_job` or `task_manager`), `job_id` for task-manager jobs; a finished job reports `Warn`/`cancelled` or `Error` |

Use the table as a guide, not a contract: rely on `event` and `code`, and treat a missing
field as "not provided".

## Delivery Rules

- Every **loaded and enabled** capability of every plugin receives every event, regardless of
  capability type. Disabled capabilities are skipped.
- Events are delivered **synchronously on the thread that raised them**: typically the UI
  thread for editing, project and preset events, the slicing worker for the slicing and G-code
  export events, and job/upload worker threads for job and upload events. Do not assume the UI
  thread, keep handlers short, and never block: the slicer waits for your handler to return.
  A print task's `PrintJobStarted` and `PrintJobFinished` arrive on the same worker thread.
- Once a slice is cancelled, dispatch of its slicing and G-code export events stops before the
  next capability is called.
- An exception raised by a handler is logged (with the event and payload) and swallowed; it
  does not affect OrcaSlicer or the other plugins.
- Handlers run inside an audit context like any other plugin call, so filesystem, network and
  process access prompts the user. See [Plugin Audit Hook](plugin_audit_hook).
- When plugins shut down, OrcaSlicer stops accepting new events and waits for handlers already
  running to finish before unloading plugin code.

See [Registry](registry) for the other members every capability inherits.
