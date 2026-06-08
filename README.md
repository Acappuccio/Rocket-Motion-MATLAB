# Rocket Motion Simulation — MATLAB

A physics-based numerical simulation of two-stage rocket flight combined with 
engineering analysis of rocket fuel tank design. Built in MATLAB using 
differential equations, real atmospheric models, and numerical integration.

---

## What It Does

Two separate but related analyses:

**1. Flight Simulation** — models a rocket launching from the ground and tracks 
its behavior every 0.5 seconds accounting for thrust, drag, variable gravity, 
atmospheric density, staging, Mach number, and 2D trajectory.

**2. Fuel Tank Analysis** — models a conical liquid hydrogen fuel tank, computing 
volume via numerical integration and work required to pump fuel out using 
real fluid dynamics parameters.

---

## Flight Simulation Output

Running demo_rocket produces:
- 5 plots: vertical velocity, altitude, mass, Mach number, and 2D trajectory
- Flight summary printed to command window

Flight results:
- Max Altitude: 21,979.63 m (21.98 km)
- Max Velocity: 385.93 m/s
- Max Mach: 1.377 — went supersonic at t=86.5s
- Stage separation at t=40.0s
- Burnout Mass: 28,739.14 kg
- Horizontal Distance: 7,921.56 m (7.92 km)

---

## Fuel Tank Analysis Output

Running rocket_fuel_tank produces:
- 3D visualization of conical tank with lighting and grid
- Volume of liquid hydrogen tank
- Work required to pump fuel out

Tank results:
- Volume: 41.89 m³
- Work to pump: 218,352.78 J
- Fluid: Liquid hydrogen (ρ = 70.85 kg/m³)

---

## How to Run

Flight simulation:
demo_rocket

Fuel tank analysis:
rocket_fuel_tank

---

## Adjustable Parameters — Flight Simulation

| Parameter | Default | Description |
|---|---|---|
| dry_mass | 5000 kg | Rocket body mass without fuel |
| fuel_mass | 45000 kg | Starting fuel mass |
| thrust_max | 600000 N | Maximum engine thrust |
| Isp | 453 s | Specific impulse |
| drag_coeff | 0.5 | Drag coefficient |
| launch_angle | 85° | Launch angle from horizontal |
| stage2_start | 40 s | Time of first stage separation |
| dt | 0.5 s | Time step |
| total_time | 120 s | Total simulation duration |

---

## Adjustable Parameters — Fuel Tank

| Parameter | Default | Description |
|---|---|---|
| rho | 70.85 kg/m³ | Liquid hydrogen density |
| R | 2 m | Base radius of cone |
| y_end | 10 m | Height of cone |

---

## File Structure

| File | Description |
|---|---|
| demo_rocket.m | Main flight simulation entry point |
| rocketmotion.m | Core physics engine |
| rocketthrust.m | Thrust force model |
| rocket_fuel_tank.m | Conical tank volume and work analysis |
| plot_rockettraj.m | Trajectory plotting helper |
| tests_rocketmotion.m | Automated tests for physics functions |

---

## Requirements
MATLAB R2019b or later. No additional toolboxes required.
