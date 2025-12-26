extends Node

signal mouse_mode_requested(mode: int)
signal remote_player_spawned(peer_id: int, transform: Transform3D)
signal remote_state_updated(peer_id: int, transform: Transform3D, velocity: Vector3)

var is_host := false
var connected := false

func initialize_as_host(port: int = 28960, max_peers: int = 8) -> void:
    # Stub for hosting networking session. Implement with ENetMultiplayerPeer or your preferred transport.
    is_host = true
    connected = true
    push_warning("Networking host stub called. Replace with ENet setup.")

func connect_to_host(address: String, port: int = 28960) -> void:
    # Stub for joining a session. Implement with your transport layer.
    is_host = false
    connected = true
    push_warning("Networking client stub called. Replace with ENet setup.")

func send_player_state(transform: Transform3D, velocity: Vector3) -> void:
    # Serialize and broadcast player data here.
    if not connected:
        return
    # Implementation placeholder.

func broadcast_shot(muzzle: Transform3D) -> void:
    # Broadcast shot events here.
    if not connected:
        return
    # Implementation placeholder.

func mock_remote_spawn(peer_id: int, transform: Transform3D) -> void:
    # Helper for testing without networking.
    emit_signal("remote_player_spawned", peer_id, transform)

func mock_remote_update(peer_id: int, transform: Transform3D, velocity: Vector3) -> void:
    emit_signal("remote_state_updated", peer_id, transform, velocity)

func request_mouse_release() -> void:
    emit_signal("mouse_mode_requested", Input.MOUSE_MODE_VISIBLE)
