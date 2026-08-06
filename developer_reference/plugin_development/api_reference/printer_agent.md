# Printer Agent

The `orca.printer_agent` module exposes `PrinterAgentBase` and its data types for plugins
that integrate with the network / printer-agent layer.

| Base class | `get_type()` returns | Required methods | Invoked by |
|---|---|---|---|
| `orca.printer_agent.PrinterAgentBase` | `PrinterConnection` | `get_name()` plus printer-agent methods such as `get_agent_info` and `connect_printer` | the **network / printer-agent** layer on load |

Printer-agent capabilities run on background network threads. Lifecycle hooks `on_load()` /
`on_unload()` are optional and available on every capability (defaults do nothing).

The printer-agent method table is expected to grow as the API is documented in more detail.
Keep capability registration and name rules consistent with [Registry](registry).
