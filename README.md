# Rocket Motion Simulation — MATLAB/Octave

A physics-based numerical simulation of rocket flight, modeling velocity, altitude, mass, and trajectory over time. Built in MATLAB/Octave using differential equations and real atmospheric models.

---

## What It Does

This simulation models a rocket launching from the ground and tracks its behavior every 0.5 seconds, accounting for:

- **Thrust** — engine force based on specific impulse (Isp) and fuel burn rate
- **Drag** — air resistance that varies with altitude and speed
- **Variable gravity** — gravity weakens as the rocket climbs
- **Atmospheric density** — air gets thinner at higher altitudes, reducing drag
- **Staging** — first stage hardware drops at a set time, reducing mass
- **Mach number** — tracks when the rocket goes supersonic
- **2D trajectory** — models both vertical and horizontal motion based on launch angle
- **Coriolis force** — accounts for Earth's rotation

---

## Simulation Output

Running `demo_rocket` produces:

- **5 plots:** Vertical velocity, altitude, mass, Mach number, and 2D trajectory
- **Flight summary** printed to the command window:
  - Max altitude and time reached
  - Max velocity
  - Max Mach number
  - Whether and when the rocket went supersonic
  - Total downrange distance
  - Burnout mass

---

## How to Run

1. Open MATLAB (R2019b+) or GNU Octave (6+)
2. Navigate to the project folder
3. Run in the command window:
```
demo_rocket
```

---

## Adjustable Parameters

All key parameters are at the top of `demo_rocket.m` — no need to touch the physics code:

| Parameter | Default | Description |
|---|---|---|
| `dry_mass` | 5000 kg | Rocket body mass without fuel |
| `fuel_mass` | 45000 kg | Starting fuel mass |
| `thrust_max` | 600000 N | Maximum engine thrust |
| `Isp` | 453 s | Specific impulse (engine efficiency) |
| `drag_coeff` | 0.5 | Drag coefficient |
| `rocket_area` | 1.0 m² | Cross-sectional area |
| `launch_angle` | 85° | Launch angle from horizontal (90° = straight up) |
| `stage2_start` | 40 s | Time of first stage separation |
| `dt` | 0.5 s | Time step (smaller = more accurate) |
| `total_time` | 120 s | Total simulation duration |

---

## File Structure

```
├── demo_rocket.m          # Main entry point — run this
├── rocketmotion.m         # Core physics engine (forces, integration)
├── rocketthrust.m         # Thrust force model
├── demo_rocketthrust.m    # Standalone thrust demo
├── plot_rockettraj.m      # Trajectory plotting helper
├── tests_rocketmotion.m   # Automated tests for physics functions
```

---

## Physics Overview

At each time step, `rocketmotion.m` computes the net force on the rocket:

```
Net Force = Thrust - Weight - Drag - Coriolis
```

Then integrates using the trapezoidal method to update velocity and position. Atmospheric density follows the International Standard Atmosphere (ISA) model.

---

## Requirements

- MATLAB R2019b or later, **or** GNU Octave 6+
- No additional toolboxes required
