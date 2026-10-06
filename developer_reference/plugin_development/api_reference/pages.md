# Pages

`orca.pages` lets a plugin add its own **tab to the main window**, next to OrcaSlicer's built-in
tabs (Prepare, Preview, Device, ...). The tab hosts an HTML page supplied by the plugin.
Subclass `orca.pages.PagesPluginCapabilityBase`; its `get_type()` returns `Pages`.

| Method | Required | Purpose |
|---|---|---|
| `get_name()` | yes | the tab label |
| `get_ui()` | yes | return the page's HTML as a string |
| `get_icon()` | no | return the path of an `.svg` / `.png` tab icon; empty (the default) for none |
| `on_message(data)` | no | receives each `orca.postMessage(obj)` from the page, decoded from JSON |
| `post_message(data)` | provided | send a JSON-compatible value to the page's `orca.onMessage` handlers |

```python
import orca

PAGE = """
<h2>Stats</h2><pre id="out">waiting...</pre>
<script>
  orca.onMessage(d => document.getElementById('out').textContent = JSON.stringify(d, null, 2));
  orca.postMessage({type: 'ready'});
</script>
"""

class StatsPage(orca.pages.PagesPluginCapabilityBase):
    def get_name(self): return "Stats"
    def get_ui(self): return PAGE

    def on_message(self, data):
        if data.get("type") == "ready":
            self.post_message({"objects": len(orca.host.model().objects())})

@orca.plugin
class StatsPlugin(orca.base):
    def register_capabilities(self):
        orca.register_capability(StatsPage)
```

## Behavior

- A tab is added when the capability is loaded and enabled, and removed when it is disabled or
  its plugin is unloaded. The page itself is built the first time the tab is shown, so
  `get_ui()` is not called until then.
- The page gets a `window.orca` bridge with `orca.postMessage(obj)` and `orca.onMessage(cb)`
  (there is no `submit()` or `close()`). It is themed like the [Host UI](host_ui#theming)
  dialogs, and if the user reloads it the plugin's HTML is loaded again, so keep the
  authoritative state in the plugin and have the page ask for it on load.
- `post_message()` before the page has been built is dropped; the pattern above (the page asks
  for its data when it loads) avoids that.
- A link that would open a new window is loaded in the page itself.
- If `get_ui()` raises, the error is logged and the tab stays empty.
- The number of plugin tabs shown side by side is set in **Preferences > General > Plugins >
  Visible plugin pages** (1-10, default 5). Further pages collapse into a dropdown on the last
  plugin tab.

See [Registry](registry) for registration and the members every capability inherits.
