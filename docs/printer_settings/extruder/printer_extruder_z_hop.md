# Z Hop

Z-Hop is a feature that lifts the nozzle slightly during travel moves to avoid collisions with the printed object. This is particularly useful for prints with tall, thin features or when printing multiple objects on the build plate.

## On surfaces

Enforce Z-Hop behavior. This setting is impacted by the above settings (Only lift Z above/below).

## Z-hop type

- Auto: Selects automatically between Spiral based on whether the travel move crosses over overhang areas
- Normal Lift: The nozzle is lifted vertically during retraction and lowered back down before resuming printing.
- Slope: The nozzle moves diagonally (at an angle) during retraction, creating a sloped path.
- Spiral: The nozzle moves in a spiral pattern while lifting, which can help reduce stringing and improve print quality.

## Z-hop height

Whenever there is a retraction, the nozzle is lifted a little to create clearance between the nozzle and the print. This prevents the nozzle from hitting the print when traveling more. Using spiral lines to lift z can prevent stringing.

## Traveling angle

Traveling angle for Slope and Spiral Z-hop type. Setting it to 90° results in Normal Lift.

## Only lift Z above

If you set this to a positive value, Z lift will only take place above the specified absolute Z.

## Only lift Z below

If you set this to a positive value, Z lift will only take place below the specified absolute Z.
