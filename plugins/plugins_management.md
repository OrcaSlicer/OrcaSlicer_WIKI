# Managing Plugins

Select a plugin to view its information in the lower panel. The tabs show:

| Tab | What it shows |
|---|---|
| **Plugin Info** | Source, type, author, installed version, and latest version |
| **Description** | Information from the plugin author |
| **Config** | JSON or custom configuration for the plugin's capabilities |
| **Changelog** | Version history, if provided |
| **Diagnostics** | Loading or error information |

Right-click a local plugin to manage it.

![local-plugin-context-menu](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/plugins/local-plugin-context-menu.png?raw=true)

Common actions include:

- **Delete/Unsubscribe** removes the plugin if it is local, unsubscribes and removes the plugin if it is from the cloud.
- **Show in folder** opens the plugin location on your computer.
- **Reinstall** installs the plugin again from its source file.

Use **Refresh** if you installed, updated, or subscribed to a plugin and the list has not changed yet.

## Plugin Status

The **Status** column shows one of:

| Status | Meaning |
|---|---|
| **Activated** | The plugin is loaded and ready to use. |
| **Loading** | The plugin is still being installed or loaded. |
| **Inactive** | The plugin is installed but not activated. Check its **Activate** box to load it. |
| **Error** | The plugin could not be loaded and is blocked until the error is fixed. |
| **RuntimeError** | The plugin is loaded, but one of its features reported an error (for example, a printer connection whose ID is already used by another plugin or a built-in connection). The plugin stays activated; the affected feature is turned off. |

The **Activate** box shows whether the plugin is loaded. Deactivating a plugin clears its error.
Open the **Diagnostics** tab for the error details.

## Orphaned and Missing Plugins

A cloud plugin you are no longer subscribed to, or that is no longer available in OrcaCloud,
is shown as **Orphaned**. Its local copy stays installed and can still be used, but it can no
longer be reinstalled or updated from the cloud. Use **Delete** to remove it.

If OrcaSlicer finds installed plugins whose files were deleted from your computer, it lists
them and offers to remove them from OrcaSlicer.

## Permissions

When a plugin tries to access files outside the folders OrcaSlicer allows by default, connect to
the network, or start a program, OrcaSlicer asks for your permission, and remembers most answers for that
plugin. Installing a plugin again, using **Reinstall**, or updating it clears the remembered
permissions, so the new version has to ask again.

Disabling a plugin or one of its capabilities removes it from workflows that use it. Presets that
refer to an inactive or missing capability show a missing-plugin notification and cannot be sliced
until the reference is resolved or the setting is changed.
