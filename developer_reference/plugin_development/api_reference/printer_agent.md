# Printer Agent

The `orca.printer_agent` module exposes `PrinterAgentBase` and its data types. A printer agent
is the layer OrcaSlicer talks to for everything on the **Device** side: discovering printers,
connecting to one, sending commands, pushing status back, and sending or starting print jobs.
OrcaSlicer ships built-in agents (Bambu Lab, Moonraker, Qidi, Snapmaker, CrealityPrint, Orca).
A Python capability that subclasses `PrinterAgentBase` adds another one.

| Base class | `get_type()` returns | Required methods | Invoked by |
|---|---|---|---|
| `orca.printer_agent.PrinterAgentBase` | `PrinterConnection` | `get_name()`, `get_agent_info()`, plus the core agent methods listed under [Methods](#methods) | the network / printer-agent layer (`NetworkAgent`) once the agent is selected |

- [Enabling printer agents](#enabling-printer-agents)
- [Registration and agent IDs](#registration-and-agent-ids)
- [Methods](#methods)
- [Data types](#data-types)
- [Host callbacks](#host-callbacks)
- [Threading](#threading)
- [Error handling](#error-handling)
- [Lifecycle](#lifecycle)
- [Minimal example](#minimal-example)

## Enabling printer agents

Two settings decide whether your agent is used:

1. **Preferences -> Developer -> Experimental Features -> Use printer agents instead of print
   hosts** (`use_printer_agents` in the app config, default **off**). When it is off, printers
   that are not Bambu Lab keep the classic print-host upload flow, so a plugin agent is
   never routed print jobs. When it is on, the Device tab, the print button and the sidebar
   switch to agent mode.
2. **Printer settings -> Basic information -> Advanced -> Printer Agent** (`printer_agent`,
   advanced mode). The dropdown lists every registered agent, built-ins first, then plugin
   agents, by their `AgentInfo.name`. The preset stores the `AgentInfo.id` string. An empty
   value means the default: `bbl` for Bambu Lab printers and `orca` for everything else. See
   [Advanced Printer Settings](printer_basic_information_advanced).

Because the preset stores only the agent ID, a preset whose agent comes from a plugin that is
not installed is reported as missing a plugin, like any other plugin-backed setting.

## Registration and agent IDs

Register the capability like any other (see [Registry](registry)):

```python
@orca.plugin
class MyPrinterPlugin(orca.base):
    def register_capabilities(self):
        orca.register_capability(MyAgent)
```

`get_type()` is already implemented by `PrinterAgentBase` and returns
`orca.PluginType.PrinterConnection` (`"printer-connection"`). You do not override it.

When the capability loads or is enabled, OrcaSlicer calls `get_agent_info()` and registers the
agent under `AgentInfo.id`:

- **The ID must not be empty.** An empty ID is logged as a warning and the agent is not registered.
- **The ID must be unique.** The IDs `orca`, `bbl`, `qidi`, `snapmaker`, `crealityprint` and
  `moonraker` belong to the built-in agents. If the ID is already registered by a built-in or
  by another plugin capability, the capability is **rejected**: the plugin is flagged with an
  error (shown as *RuntimeError* in the Plugins dialog, while the plugin stays loaded), the
  capability is disabled, and a warning box shows
  `Printer-agent '<name>' could not be enabled: agent ID '<id>' is already registered by ...`.
  Pick an ID that is unlikely to collide, and keep it stable: it is what users' presets store.
- **Re-registering is allowed.** When the same capability registers again (for example after a
  reload), its entry is refreshed. If it now reports a different ID, the old ID is removed first.
- `get_agent_info()` is called at registration and again whenever the host swaps the live agent,
  so it should return quickly and always return the same value.

The host creates **one** agent per ID and caches it, so the capability instance itself is the
live agent. State you keep on `self` persists for as long as the capability is loaded.

When the capability is disabled or the plugin is unloaded, the agent is deregistered. If it was
cached, `disconnect_printer()` is called. If it was the live agent, the host also clears it,
which detaches the host callbacks (see [Lifecycle](#lifecycle)).

## Methods

Each method returns an `int` status code unless stated otherwise. `0` (`BAMBU_NETWORK_SUCCESS`)
means success and any other value is a failure. Two Orca-specific codes are also understood:
`-7010` (command not supported) and `-7020` (this printer lacks the capability).

### Core methods

There is no fallback for these. If one is missing, raises, or returns the wrong type, the call
is logged as failed and the host receives the failure value in the last column.

| Method | Returns | Called when | Failure value |
|---|---|---|---|
| `get_agent_info(self)` | `AgentInfo` | registration, and whenever the live agent is swapped | empty `AgentInfo` (empty ID: the agent is not registered) |
| `connect_printer(self, params)` | `int` | a machine is selected or reconnected; `params` is a `PrinterConnectionParams` | `-1` |
| `disconnect_printer(self)` | `int` | machine deselected, agent swapped, agent deregistered, networking shut down | `-1` |
| `send_message(self, dev_id, json_str, qos, flag)` | `int` | a command is published through the cloud path | `-1` |
| `send_message_to_printer(self, dev_id, json_str, qos, flag)` | `int` | a command is published over LAN | `-1` |
| `start_discovery(self, start, sending)` | `bool` | after the agent becomes live (`True, False`) and on shutdown (`False, False`) | `False` |
| `bind_detect(self, dev_ip, sec_link, detect)` | `int` | the LAN "bind / connect by IP" flow; fill in the `DetectResult` passed as `detect` | `-1` |
| `get_user_selected_machine(self)` | `str` | the host reads the selected device ID | `""` |
| `set_user_selected_machine(self, dev_id)` | `int` | the selected device changes (`""` means deselected) | `-1` |
| `start_send_gcode_to_sdcard(self, params, update_fn, cancel_fn, wait_fn)` | `int` | **Send** (upload without printing). It is also called with `project_name="verify_job"` and no callbacks to check the IP and access code | `-1` |
| `start_local_print(self, params, update_fn, cancel_fn)` | `int` | **Print** over LAN | `-1` |
| `start_print(self, params, update_fn, cancel_fn, wait_fn)` | `int` | cloud print | `-1` |
| `start_local_print_with_record(self, params, update_fn, cancel_fn, wait_fn)` | `int` | LAN print with cloud record | `-1` |
| `start_sdcard_print(self, params, update_fn, cancel_fn)` | `int` | print a file already on the printer's storage | `-1` |
| `check_cert(self)` | `int` | certificate check | `-1` |
| `ping_bind(self, ping_code)` | `int` | binding flow | `-1` |
| `bind(self, dev_ip, dev_id, dev_model, sec_link, timezone, improved, update_fn)` | `int` | binding flow | `-1` |
| `unbind(self, dev_id)` | `int` | unbinding | `-1` |
| `request_bind_ticket(self)` | `(int, str)` tuple: status and ticket | binding flow | `-1` (ticket left unchanged) |
| `set_server_callback(self, fn)` | `int` | callback registration, see [Host callbacks](#host-callbacks) | `-1` |
| `set_on_ssdp_msg_fn(self, fn)` | `int` | callback registration | `-1` |
| `set_on_printer_connected_fn(self, fn)` | `int` | callback registration | `-1` |
| `set_on_subscribe_failure_fn(self, fn)` | `int` | callback registration | `-1` |
| `set_on_message_fn(self, fn)` | `int` | callback registration | `-1` |
| `set_on_user_message_fn(self, fn)` | `int` | callback registration | `-1` |
| `set_on_local_connect_fn(self, fn)` | `int` | callback registration | `-1` |
| `set_on_local_message_fn(self, fn)` | `int` | callback registration | `-1` |
| `set_queue_on_main_fn(self, fn)` | `int` | callback registration | `-1` |

> [!NOTE]
> `check_cert`, `ping_bind`, `bind`, `unbind` and `request_bind_ticket` have "success" defaults
> on the C++ side, but the Python bridge has no such fallback: an agent that leaves them out
> answers `-1`. Implement them (returning `0`, or `(0, "")` for `request_bind_ticket`) if
> your printers have no binding step.

`bind_detect` writes its result into the `detect` object it receives, which is the host's own
`DetectResult`. Set its fields and return a status code:

```python
def bind_detect(self, dev_ip, sec_link, detect):
    detect.dev_id = dev_ip
    detect.dev_name = "My Printer"
    return 0
```

### Optional methods

If one of these is **not overridden**, the host's default is used. If an override **raises or
returns the wrong type**, the host receives the failure value (`-1`, `False`, `""` or `None_`)
instead of the default.

| Method | Returns | Default when not overridden |
|---|---|---|
| `command_ams_refresh_rfid(self, dev_id, ams_id, slot_id, sequence_id, lan_mode)` | `int` | `-7010` (not supported) |
| `command_ams_calibrate(self, dev_id, ams_id, sequence_id, lan_mode)` | `int` | `-7010` |
| `command_ams_select_tray(self, dev_id, tray_id, sequence_id, lan_mode)` | `int` | `-7010` |
| `command_start_camera(self, dev_id)` | `int` | `-7010` |
| `command_xyz_abs(self, dev_id, sequence_id, lan_mode)` | `int` | sends `G90` as a `gcode_line` command |
| `command_auto_leveling(self, dev_id, sequence_id, lan_mode)` | `int` | sends `G29` |
| `command_go_home(self, dev_id, is_printing, supports_mqtt_homing, sequence_id, lan_mode)` | `int` | sends `back_to_center`, or `G28` / `G28 X` |
| `command_set_bed(self, dev_id, temp, supports_mqtt_bed_ctrl, sequence_id, lan_mode)` | `int` | sends `set_bed_temp`, or `M140 S<temp>` |
| `command_set_nozzle(self, dev_id, temp, sequence_id, lan_mode)` | `int` | sends `M104 S<temp>` |
| `command_axis_control(self, dev_id, axis, unit, input_val, speed, is_core_xy, supports_mqtt_axis_control, sequence_id, lan_mode)` | `int` | sends a relative `G1` (X/Y/Z) or `G0` (E) move; any other axis returns `-1` |
| `get_filament_sync_mode(self)` | `FilamentSyncMode` | `FilamentSyncMode.None_` |
| `fetch_filament_info(self, dev_id, sync_mode)` | `bool` | `False` |
| `get_camera_stream_mode(self)` | `CameraStreamMode` | `CameraStreamMode.None_` |
| `get_camera_url(self)` | `str` | `""` |
| `install_device_cert(self, dev_id, lan_only)` | `None` | no-op |
| `get_hms_snapshot(self, dev_id, file_name, callback)` | `int` | `-1`; when implemented, return `0` and deliver the image with `callback(body, http_status)` |

The default `command_*` implementations build a Bambu-style JSON command
(`{"print": {"command": "gcode_line", "param": "...", "sequence_id": "..."}}`) and pass it to
**your** `send_message_to_printer()` when `lan_mode` is true, or to `send_message()` otherwise.
An agent that translates those JSON commands in `send_message*` gets the printer controls for
free. Override a `command_*` method to speak your printer's protocol directly.

`get_filament_sync_mode()` controls the filament sync. With `Subscription`, the sidebar's
filament list reloads on every LAN message for the selected printer. With `Pull`, OrcaSlicer
calls `fetch_filament_info(dev_id)` when it needs the data.

### Not available to Python

`set_cloud_agent` is managed by the host. `default_lan_username`, `start_subscribe`,
`stop_subscribe`, `add_subscribe`, `del_subscribe`, `to_orca_filament_id` and
`from_orca_filament_id` are part of the C++ interface but are not forwarded to Python: a plugin
agent always uses the defaults. In particular, `PrinterConnectionParams.username` is always
empty for a Python agent.

## Data types

All types live in `orca.printer_agent`. Their fields are read/write.

**`AgentInfo`**: `AgentInfo()` or `AgentInfo(id, name, version, description)`.

| Field | Meaning |
|---|---|
| `id` | unique agent ID, stored in printer presets (see [Registration and agent IDs](#registration-and-agent-ids)) |
| `name` | display name in the Printer Agent dropdown |
| `version` | agent version string |
| `description` | short description |

**`PrinterConnectionParams`**: passed to `connect_printer()`.

| Field | Type | Meaning |
|---|---|---|
| `dev_id` | `str` | device ID of the selected machine |
| `host` | `str` | host address with the `http://` / `https://` prefix stripped |
| `port` | `str` | port from the address, otherwise the preset's `printhost_port`; may be empty |
| `username` | `str` | always empty for Python agents |
| `password` | `str` | the machine's access code. For machines created from the preset this is `printhost_apikey`, or `88888888` when that is empty |
| `use_ssl` | `bool` | `True` when the address starts with `https` |
| `ca_file` | `str` | the preset's `printhost_cafile` |

**`PrintParams`**: passed to the `start_*` methods. Key fields:

| Field | Meaning |
|---|---|
| `dev_id`, `dev_ip`, `dev_name` | target device |
| `filename` | local path of the file to send (the 3MF, or a temporary file for the verify upload) |
| `project_name`, `task_name`, `preset_name`, `plate_index` | job identity; `project_name` is `"verify_job"` for the connection check |
| `password`, `username` | access code and LAN user |
| `connection_type` | for example `"lan"` |
| `use_ssl_for_ftp`, `use_ssl_for_mqtt` | transport flags |
| `dst_file` | destination path on the printer, when set |
| `ams_mapping`, `ams_mapping2`, `ams_mapping_info`, `nozzle_mapping`, `nozzles_info` | filament / nozzle mapping as JSON strings |
| `task_bed_leveling`, `task_flow_cali`, `task_vibration_cali`, `task_layer_inspect`, `task_record_timelapse`, `task_use_ams`, `task_bed_type`, `task_ext_change_assist` | user print options |
| `auto_bed_leveling`, `auto_flow_cali`, `auto_offset_cali` | `int` print options |

The remaining bound fields are `config_filename`, `ftp_folder`, `ftp_file`, `ftp_file_md5`,
`comments`, `origin_profile_id`, `stl_design_id`, `origin_model_id`, `print_type`,
`extra_options` and `try_emmc_print`.

**`DetectResult`**: filled in by `bind_detect()`. All fields are strings: `result_msg`,
`command`, `dev_id`, `model_id`, `dev_name`, `version`, `bind_state`, `connect_type`.

**`FilamentSyncMode`**: `None_`, `Subscription`, `Pull`.

**`CameraStreamMode`**: `None_`, `HTTP`, `HTTPS`, `HTTP_SNAPSHOT`, `RTSP`.

> [!TIP]
> Both enums export their values into `orca.printer_agent`, and both have a member called
> `None_`. Always write the qualified form (`FilamentSyncMode.None_`,
> `CameraStreamMode.None_`) instead of `orca.printer_agent.None_`.

## Host callbacks

When the agent becomes live, the host calls every `set_*_fn` method once and passes in a
callable. Store it and call it to push events into OrcaSlicer. The host marshals each of these
callbacks onto the UI thread itself, so you may call them from any thread, including your own
`threading.Thread`.

| Setter | Callback signature | Use |
|---|---|---|
| `set_on_ssdp_msg_fn` | `fn(dev_info_json: str)` | report a discovered printer (see below) |
| `set_on_local_connect_fn` | `fn(status: int, dev_id: str, msg: str)` | LAN connection state: `0` = OK, `1` = failed, `2` = lost |
| `set_on_local_message_fn` | `fn(dev_id: str, msg: str)` | LAN status push; parsed by the device model as Bambu-style JSON with a `print` object |
| `set_on_message_fn` | `fn(dev_id: str, msg: str)` | cloud status push |
| `set_on_user_message_fn` | `fn(user_id: str, msg: str)` | user-scoped cloud message |
| `set_on_printer_connected_fn` | `fn(topic: str)` | cloud printer connection |
| `set_on_subscribe_failure_fn` | `fn(topic: str)` | subscription failure |
| `set_server_callback` | `fn(url: str, status: int)` | fatal server error |
| `set_queue_on_main_fn` | `fn(task)`, where `task` is a no-argument callable | run `task` on the UI thread |

A discovery message passed to the SSDP callback is a JSON object with the string fields
`dev_id`, `dev_name`, `dev_ip`, `dev_type`, `dev_signal`, `connect_type` (for example `"lan"`)
and `bind_state` (for example `"free"`). `sec_link`, `ssdp_version` and `connection_name` are
optional.

The `start_*` methods receive per-job callables:

| Argument | Signature | Use |
|---|---|---|
| `update_fn` | `update_fn(status: int, code: int, msg: str)` | report progress |
| `cancel_fn` | `cancel_fn() -> bool` | poll for user cancellation |
| `wait_fn` | `wait_fn(status: int, job_info: str) -> bool` | wait step used by cloud flows |

> [!IMPORTANT]
> Any callable may be `None`. The host passes `None` to the setters when it detaches an
> agent or shuts networking down, and some `start_*` calls pass `None` for the job callbacks
> (for example the `verify_job` upload). Check for `None` before every call.

## Threading

There is no dedicated agent thread. Each method runs on whichever thread the host calls it
from. Selection, discovery, connection and callback registration happen on the UI thread.
Print and send jobs (`start_*`) run on background job threads. Every call acquires the Python
GIL for its duration.

- Return quickly from methods called on the UI thread. Do long-running work (polling,
  websockets, uploads that outlive the call) on your own thread, and report back through the
  stored callbacks.
- Do not use your own GUI toolkit. Use `orca.host.ui` if you need UI (see [Host UI](host_ui)).
- Filesystem, network and process access is audited like every other plugin call (see
  [Plugin Audit Hook](plugin_audit_hook)).

## Error handling

The host calls agent methods through the C++ `IPrinterAgent` interface, which reports failure
through return values, and its callers do not catch exceptions. So **no exception from a
Python agent ever reaches the host**. If a method raises, is missing, or returns a value of the
wrong type:

1. The Python traceback (if any) goes to the Python log, and
   `Printer agent plugin '<plugin>': <method> failed: <error>` goes to the OrcaSlicer log.
2. The host receives the same answer it would get with no agent at all: `-1` for an `int`,
   `False`, `""`, an empty `AgentInfo`, `None_`, or nothing.
3. The interpreter and the plugin stay loaded. No dialog is shown.

Report expected failures with a non-zero status code rather than an exception. See
[How Errors Are Surfaced](plugin_development#how-errors-are-surfaced) for the Python log
location.

## Lifecycle

1. **Load**: the plugin loads, `on_load()` runs, and the agent is registered under its
   `AgentInfo.id`.
2. **Selection**: when the active printer preset resolves to your ID, the host makes your
   agent live. It calls `get_agent_info()`, then every `set_*_fn` setter,
   `start_discovery(True, False)`, and finally selects the machine at the preset's print host.
   For a LAN machine, that selection calls `connect_printer()`. Switching between presets that use the
   same agent re-selects the machine only when the print host differs.
3. **Swap away**: when a different agent becomes live, the host deselects the machine
   (`set_user_selected_machine("")`), calls `disconnect_printer()`, and calls every setter
   with `None`.
4. **Disable / unload**: the agent is deregistered (`disconnect_printer()` is called, and the
   live agent is cleared if it was yours), then `on_unload()` runs. Stop your threads there.

Every capability also has `on_lifecycle_event(self, event, ctx)`. Device-related events are
`orca.LifecycleEvent.DeviceDiscovered`, `DeviceSelected`, `DeviceOnline`, `DeviceOffline` and
`PrintStateChanged`. For the device events, `ctx.name` holds the device ID (empty for a
deselection), and for `DeviceOnline` / `DeviceOffline`, `ctx.msg` is `"online"` / `"offline"`. See [Lifecycle Events](lifecycle_events) for the full list.

## Minimal example

This agent reports one fixed LAN printer and accepts uploads. It implements every core method
so that nothing answers `-1` by accident. Replace the bodies marked `TODO` with your
printer's protocol.

```python
# /// script
# [tool.orcaslicer.plugin]
# name = "Example Printer Agent"
# description = "Minimal printer-agent capability."
# author = "Your Name"
# version = "1.0.0"
# ///
import json
import orca

pa = orca.printer_agent


class ExampleAgent(pa.PrinterAgentBase):
    def __init__(self):
        super().__init__()
        self.callbacks = {}
        self.selected = ""
        self.params = None

    def get_name(self):
        return "Example Printer Agent"

    def get_agent_info(self):
        return pa.AgentInfo("example_agent", "Example", "1.0.0", "Example printer agent")

    # Host callbacks: store them, they may be None
    def _store(self, key, fn):
        self.callbacks[key] = fn
        return 0

    def set_on_ssdp_msg_fn(self, fn): return self._store("ssdp", fn)
    def set_on_local_connect_fn(self, fn): return self._store("local_connect", fn)
    def set_on_local_message_fn(self, fn): return self._store("local_message", fn)
    def set_on_message_fn(self, fn): return self._store("message", fn)
    def set_on_user_message_fn(self, fn): return self._store("user_message", fn)
    def set_on_printer_connected_fn(self, fn): return self._store("printer_connected", fn)
    def set_on_subscribe_failure_fn(self, fn): return self._store("subscribe_failure", fn)
    def set_server_callback(self, fn): return self._store("server_error", fn)
    def set_queue_on_main_fn(self, fn): return self._store("queue_on_main", fn)

    def _emit(self, key, *args):
        fn = self.callbacks.get(key)
        if fn is not None:
            fn(*args)

    # Discovery and selection
    def start_discovery(self, start, sending):
        if start:
            self._emit("ssdp", json.dumps({
                "dev_id": "192.168.1.50", "dev_name": "Example", "dev_ip": "192.168.1.50",
                "dev_type": "", "dev_signal": "", "connect_type": "lan", "bind_state": "free",
            }))
        return True

    def get_user_selected_machine(self):
        return self.selected

    def set_user_selected_machine(self, dev_id):
        self.selected = dev_id
        return 0

    # Connection
    def connect_printer(self, params):
        self.params = params   # TODO: open the connection (on your own thread if slow)
        self._emit("local_connect", 0, params.dev_id, "")
        return 0

    def disconnect_printer(self):
        self.params = None     # TODO: close the connection, stop threads
        return 0

    def send_message(self, dev_id, json_str, qos, flag):
        return -7010           # no cloud path

    def send_message_to_printer(self, dev_id, json_str, qos, flag):
        return -7010           # TODO: translate the JSON command

    # Jobs
    def start_send_gcode_to_sdcard(self, params, update_fn, cancel_fn, wait_fn):
        return 0               # TODO: upload params.filename (also used for "verify_job")

    def start_local_print(self, params, update_fn, cancel_fn):
        return 0               # TODO: upload params.filename and start it

    def start_print(self, params, update_fn, cancel_fn, wait_fn):
        return -7010

    def start_local_print_with_record(self, params, update_fn, cancel_fn, wait_fn):
        return self.start_local_print(params, update_fn, cancel_fn)

    def start_sdcard_print(self, params, update_fn, cancel_fn):
        return -7010

    # Binding / certificates: nothing to do for this printer
    def bind_detect(self, dev_ip, sec_link, detect):
        detect.dev_id = dev_ip
        detect.dev_name = "Example"
        detect.connect_type = "lan"
        detect.bind_state = "free"
        return 0

    def check_cert(self): return 0
    def ping_bind(self, ping_code): return 0
    def bind(self, dev_ip, dev_id, dev_model, sec_link, timezone, improved, update_fn): return 0
    def unbind(self, dev_id): return 0
    def request_bind_ticket(self): return (0, "")


@orca.plugin
class ExamplePrinterPlugin(orca.base):
    def register_capabilities(self):
        orca.register_capability(ExampleAgent)
```

To try it, turn on **Use printer agents instead of print hosts**, then pick **Example** under
**Printer Agent** in the printer preset and set its print host to the printer's address.

See [Registry](registry) for registration and naming rules, and
[Plugin Development](plugin_development) for packaging and testing.
