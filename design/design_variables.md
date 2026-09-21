# Variables and Expressions

> [!IMPORTANT]
> NEW FEATURE: **Design tab — parametric CAD inside the slicer**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

<img alt="design_constrain" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_constrain.svg?raw=true" height="22"> Variables are named values that live with the document and drive dimensions across the whole model. Change one variable and everything that references it follows on the next recompute.

- [The Variables card](#the-variables-card)
- [Using a variable](#using-a-variable)
- [Expression syntax](#expression-syntax)

## The Variables card

The **Variables** card sits at the bottom of the [Design tab](design_tab#sidebar) sidebar, under the feature tree and the bodies list. It is a two-column table of **Name** and **Expression**.

| Button | What it does |
| --- | --- |
| `+` | Add a variable |
| **Edit** | Change the selected variable |
| **Del** | Remove the selected variable |

Every change is checkpointed and recomputed, and it is rolled back if the recompute fails — a bad expression cannot leave the model in a broken state.

## Using a variable

**Any numeric field in the tab accepts an expression**, not just a number. A sketch dimension, an extrude depth, a fillet radius, a hole diameter — type `width/2` or `wall*3` and it is stored as the expression, not as the number it evaluated to today.

A variable may also reference another variable. They are evaluated in dependency order on each recompute, so a chain such as `wall = 2`, `boss = wall*3`, `clearance = boss/4` resolves in one pass.

> [!TIP]
> Define the handful of numbers a part is really made of — wall thickness, bore diameter, the mounting pitch — and drive everything else from them. Re-fitting the part to a different screw then takes one edit rather than twenty.

## Expression syntax

| Supported | Details |
| --- | --- |
| Arithmetic | `+`, `-`, `*`, `/`, parentheses, unary minus, decimal literals |
| Identifiers | Any variable defined on the document |
| Functions | `sqrt`, `abs`, `sin`, `cos`, `tan`, `min`, `max` |
| Constant | `pi` |

Trigonometric functions take **degrees**, matching the rest of the tab.

A parse error, an unknown name, a division by zero or a wrong argument count is reported rather than silently substituted.
