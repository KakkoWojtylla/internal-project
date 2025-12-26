# Quake-style Arena Scaffold (Godot 4.5)

This repository scaffolds a Quake III Arena-inspired first-person arena built for Godot **4.5**. It includes a minimal level, a Quake-like player controller, and clear stubs for networking so you can plug in your transport of choice.

## Requirements
- Godot 4.5 editor/engine.

## Project layout
- `project.godot` – preconfigured project file targeting Godot 4.5 with common input actions.
- `default_env.tres` – simple sky/ambient setup.
- `scenes/level.tscn` – boxy graybox arena with spawn markers and walls.
- `scenes/player.tscn` – `CharacterBody3D` with capsule collider, FPS camera, and muzzle marker.
- `scenes/main.tscn` – root scene that wires level, player, UI hints, and the networking stub.
- `scripts/` – gameplay and stub scripts:
  - `player_controller.gd` – Quake-style movement, mouse look, jump, and local-only firing placeholder.
  - `game_manager.gd` – bootstraps level/player, handles mouse capture toggle.
  - `network_stub.gd` – stub signals and methods to replace with your networking layer.
  - `level_manager.gd` – spawn-point helper used by the level scene.

## Getting started
1. Open the folder with Godot 4.5.
2. The main scene is `res://scenes/main.tscn` (also set as the run target).
3. Play the scene to move around the graybox arena:
   - **WASD** to move, **Space** to jump, **Mouse** to look, **Left Click** to fire a local-only debug trace.
   - **Esc** toggles mouse capture.

## Networking hook points
Networking is intentionally stubbed in `scripts/network_stub.gd`:
- `initialize_as_host` / `connect_to_host` – create/join your session (e.g., ENet, WebSocket, Steam).
- `send_player_state` – serialize and broadcast `Transform3D` and velocity each physics tick.
- `broadcast_shot` – send weapon fire events.
- `mock_remote_spawn` / `mock_remote_update` – helpers for local testing without real networking.
- Signals: `remote_player_spawned`, `remote_state_updated`, `mouse_mode_requested` to coordinate with the game manager and remote avatars.

## Extending toward a fuller clone
- Replace `network_stub.gd` with your real multiplayer peer and bind it to remote player instances.
- Add weapon scenes/effects; `player_controller.gd` exposes `_spawn_debug_projectile` as a placeholder.
- Expand `scenes/level.tscn` or import BSP-like geometry to approach Quake III layouts.
- Hook UI into real match state (scoreboard, timers, respawn logic).
