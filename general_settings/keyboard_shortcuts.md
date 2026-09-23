# Keyboard Shortcuts

This page lists the keyboard shortcuts available in the application, and how to change them.

> [!IMPORTANT]
> NEW FEATURE: **Assignable keyboard shortcuts**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

- [Customizing Shortcuts](#customizing-shortcuts)
- [Global](#global)
- [Design](#design)
- [Prepare](#prepare)
- [Painting](#painting)
- [Objects list](#objects-list)
- [Preview](#preview)

Shortcuts are grouped by the view they apply to, the same way the in-app list groups them. The same key can mean different things in different views: `C` is the cut tool in Prepare, the G-code window in Preview, and the circle tool while painting. Global keys are the exception — they work anywhere, so nothing else can use them.

## Customizing Shortcuts

Every key on this page is a default, and almost all of them can be changed. Open the editor from:

- **Help → Keyboard Shortcuts**
- **Preferences → Control → Keyboard shortcuts → Edit…**
- `?` while a 3D view has focus, which opens the list on that view's page.

To reassign a shortcut, pick its row and press the new combination. If another shortcut already uses it, the dialog names them and only unbinds them once you confirm. **Reset** restores the default and asks the same question if that default is now held by something else. A shortcut can also be left unbound.

Only your own changes are saved, so a default that improves in a later release still reaches you.

A few rules the editor applies:

- A **Global** shortcut must include `Ctrl` or `Alt`, or use a key that types nothing, such as a function key. A bare letter reserved globally would be swallowed in every text field. `Space` is the one exception — it opens the [Speed Dial](speed_dial), and it is left alone while a text field, button or combo box has focus.
- `Shift` and `Ctrl` are reserved as **step modifiers** on the keys that have steps: 1 mm and camera-space moves of the selection, and 5x slider moves. They cannot be assigned on top of such a key.
- Some rows are fixed and cannot be reassigned: the mouse buttons, `Esc`, the digits that pick a filament, and the step modifiers above.
- Keys are matched by position, not by the letter printed on them, so a layout that moves `Q` still triggers the same shortcut. Numpad digits count as their main-row equivalents. Punctuation means the character your layout produces, wherever it sits.

The mouse drag rows in the list are not keys. They show what each button does while dragging, which is set in **Preferences → Control**: `Left Mouse Drag` (Rotate by default), `Middle Mouse Drag` and `Right Mouse Drag` (both Pan), each of which can be None, Pan or Rotate.

## Global

Available anywhere in the window, even while typing in a text field.

| Key | Action |
| --- | --- |
| `Ctrl + N` | New Project |
| `Ctrl + O` | Open Project |
| `Ctrl + S` | Save Project |
| `Ctrl + Shift + S` | Save Project as |
| `Ctrl + I` | Import geometry data from STL/STEP/3MF/OBJ/AMF files |
| `Ctrl + Shift + E` | Publish 3MF |
| `Ctrl + R` | Slice plate |
| `Ctrl + G` | Export plate sliced file |
| `Ctrl + Shift + G` | Print plate |
| `Ctrl + J` | Print host upload queue |
| `Ctrl + 0` | Camera view - Default |
| `Ctrl + 1` | Camera view - Top |
| `Ctrl + 2` | Camera view - Bottom |
| `Ctrl + 3` | Camera view - Front |
| `Ctrl + 4` | Camera view - Behind |
| `Ctrl + 5` | Camera Angle - Left side |
| `Ctrl + 6` | Camera Angle - Right side |
| `Ctrl + 7` | Camera view - Current plate |
| `Ctrl + E` | Show object labels in 3D scene |
| `Ctrl + P` (Windows/Linux)<br>`Cmd + ,` (macOS) | Preferences |
| `Ctrl + F` | Search |
| `Space` | Open the [Speed Dial](speed_dial) |
| `Alt + 1-9, 0` | Run a speed dial favorite while the dial is open |
| `Ctrl + Tab` | Switch to the next main tab |

## Design

Shortcuts for the [Design tab](design_tab), which is shown once the CAD feature is enabled in Preferences. The tab carries two key maps: while a sketch is open single letters drive the sketch tools, and when no sketch is open `Shift` and a letter drive the modeling tools. Both maps are listed in full in [Design Keyboard Shortcuts](design_keyboard_shortcuts); the keys below are the ones that act on the view and the document. The Design tab's keys are fixed: they are not part of the assignable shortcut set, so they do not appear in the shortcut editor.

| Key | Action |
| --- | --- |
| `Home` | Isometric view, fitted to the model |
| `P` | Show or hide the origin planes |
| `A` | Show or hide the world axes |
| `X` | Section view on or off |
| `Page Up` / `Page Down` | Move the section plane, while the section is on |
| `F` | Flip the section while it is on, otherwise lay the picked face on the bed |
| `Ctrl + Shift + B` | Show or hide the printer bed |
| `Ctrl + Shift + P` | Commit to Plate |
| `Menu` / `Shift + F10` | Open the offer menu on the current selection |
| `F2` | Rename the selected feature |
| `Esc` | Clear the selection |

## Prepare

Available while the 3D view on the Prepare tab has focus.

| Key | Action |
| --- | --- |
| `Ctrl + A` | Select all objects |
| `Ctrl + Shift + A` | Select all objects on all plates |
| `Alt + Left mouse button` | Select a part |
| `Ctrl + Left mouse button` | Select multiple objects |
| `Shift + Left mouse button` | Select objects by rectangle |
| `Esc` | Deselect all |
| `Ctrl + Z` | Undo |
| `Ctrl + Y` | Redo |
| `Ctrl + X` | Cut |
| `Ctrl + C` | Copy to clipboard |
| `Ctrl + V` | Paste from clipboard |
| `Del` (Windows/Linux)<br>`Backspace` (macOS) | Delete Selected |
| `Ctrl + D` | Delete All |
| `Ctrl + K` | Clone Selected |
| `+` | Add instance |
| `-` | Remove instance |
| `V` | Toggle printable for object/part |
| `1-9` | Set filament for object/part |
| `A` | Arrange all objects |
| `Shift + A` | Arrange objects on selected plates |
| `Q` | Auto orient all/selected objects |
| `Shift + Q` | Auto orient all objects on current plate |
| `Arrow Up` | Move selection 10 mm in positive Y direction |
| `Arrow Down` | Move selection 10 mm in negative Y direction |
| `Arrow Left` | Move selection 10 mm in negative X direction |
| `Arrow Right` | Move selection 10 mm in positive X direction |
| `Shift + Any arrow` | Movement step set to 1 mm |
| `Ctrl + Any arrow` | Movement in camera space |
| `Page Up` | Rotate selection 45 degrees counterclockwise |
| `Page Down` | Rotate selection 45 degrees clockwise |
| `M` | Gizmo move |
| `R` | Gizmo rotate |
| `S` | Gizmo scale |
| `F` | Gizmo place face on bed |
| `C` | Gizmo cut |
| `B` | Gizmo mesh boolean |
| `L` | Gizmo FDM paint-on supports |
| `P` | Gizmo FDM paint-on seam |
| `H` | Gizmo FDM paint-on fuzzy skin |
| `N` | Gizmo multi-material painting |
| `T` | Gizmo text emboss/engrave |
| `U` | Gizmo measure |
| `Y` | Gizmo assemble |
| `E` | Gizmo brim ears |
| `I` | Zoom in |
| `O` | Zoom out |
| `Mouse wheel` | Zoom view |
| `Left mouse button` | Rotate view (set in Preferences) |
| `Middle mouse button` | Pan view (set in Preferences) |
| `Right mouse button` | Pan view (set in Preferences) |
| `Ctrl + M` (Windows/Linux)<br>`Cmd + Shift + M` (macOS) | Show/Hide 3Dconnexion devices settings dialog |
| `Ctrl + Shift + Enter` | Show/Hide wireframe |
| `Tab` | Switch between Prepare/Preview |
| `Shift + Tab` | Collapse/Expand the sidebar |
| `F5` | Reload the device page |
| `?` | Show keyboard shortcuts list |

## Painting

Available while a painting gizmo is open: supports, seam, fuzzy skin or color painting.

| Key | Action |
| --- | --- |
| `C` | Circle |
| `S` | Sphere |
| `F` | Fill |
| `G` | Gap Fill |
| `T` | Triangle |
| `H` | Height Range |
| `Esc` | Deselect all |
| `Shift + Left mouse button` | Move: press to snap by 1 mm |
| `Ctrl + Mouse wheel` | Adjust pen radius |
| `Alt + Mouse wheel` | Adjust section position |

## Objects list

Available while the object list has focus.

| Key | Action |
| --- | --- |
| `Ctrl + A` | Select all objects |
| `Esc` | Deselect all |
| `Ctrl + Z` | Undo |
| `Ctrl + Y` | Redo |
| `Ctrl + X` | Cut |
| `Ctrl + C` | Copy to clipboard |
| `Ctrl + V` | Paste from clipboard |
| `Del` (Windows/Linux)<br>`Backspace` (macOS) | Delete Selected |
| `Ctrl + K` | Clone Selected |
| `+` | Add instance |
| `-` | Remove instance |
| `V` | Toggle printable for object/part |
| `D` | Auto Drop |
| `1-9` | Set extruder number for the objects and parts |
| `Space` | Select the object/part and press space to change the name |
| `Mouse click` | Select the object/part and mouse click to change the name |

## Preview

Available while the 3D view on the Preview tab has focus.

| Key | Action |
| --- | --- |
| `Shift + G` | Jump to layer |
| `Arrow Up` | Vertical slider - Move active thumb Up |
| `Arrow Down` | Vertical slider - Move active thumb Down |
| `Arrow Left` | Horizontal slider - Move active thumb Left |
| `Arrow Right` | Horizontal slider - Move active thumb Right |
| `Home` | Horizontal slider - Move to start position |
| `End` | Horizontal slider - Move to last position |
| `Shift + Any arrow`<br>`Ctrl + Any arrow` | Move slider 5x faster |
| `Shift + Mouse wheel`<br>`Ctrl + Mouse wheel` | Scroll slider 5x faster |
| `C` | On/Off G-code window |
| `L` | On/Off one layer mode of the vertical slider |
| `I` | Zoom in |
| `O` | Zoom out |
| `Ctrl + M` (Windows/Linux)<br>`Cmd + Shift + M` (macOS) | Show/Hide 3Dconnexion devices settings dialog |
| `Ctrl + Shift + Enter` | Show/Hide wireframe |
| `Tab` | Switch between Prepare/Preview |
| `Shift + Tab` | Collapse/Expand the sidebar |
| `F5` | Reload the device page |
| `?` | Show keyboard shortcuts list |
