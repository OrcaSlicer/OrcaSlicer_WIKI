# Getting Started

Plugins add extra features to OrcaSlicer. They are managed from the Plugins window.

> [!IMPORTANT]
> NEW FEATURE: **Python Plugin System**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

- [Local Plugins](plugins_local)
- [Cloud Plugins](plugins_cloud)
- [Plugin Types](plugins_types)
- [Managing Plugins](plugins_management)

## Open the Plugins Window

1. Open the main menu.
2. Click **Plugins**.

![open-plugins-menu](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/plugins/open-plugins-menu.png?raw=true)

The Plugins window shows installed and available plugins. The upper table lists plugins, and the lower section shows details for the selected plugin.

The details section includes these tabs:

- **Plugin Info** — source, author, version, capabilities, and status.
- **Description** — information supplied by the plugin author.
- **Config** — configuration for the selected plugin's capabilities.
- **Changelog** — available version history.
- **Diagnostics** — loading and error information.

Every capability has a configuration. OrcaSlicer provides a JSON editor by default; a plugin can
provide a custom configuration page instead. See [Plugin configuration](plugin_development#capability-configuration)
for the plugin-author API.

![plugins-dialog-empty](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/plugins/plugins-dialog-empty.png?raw=true)

Use the split **Browse plugins** button to choose how you want to add plugins:

- **Browse plugins** opens the cloud plugin browser.
- **Install local plugin** installs a plugin file from your computer.

![plugins-browse-menu](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/plugins/plugins-browse-menu.png?raw=true)

> [!NOTE]
> Only install plugins from sources you trust. Plugins can interact with your files and print workflow.
