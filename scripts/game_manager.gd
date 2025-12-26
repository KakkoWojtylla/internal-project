extends Node3D

@export var player_scene: PackedScene
@export var level_scene: PackedScene
@export var network_path: NodePath

var player_instance: CharacterBody3D
var level_instance: Node3D

func _ready() -> void:
    if not level_scene:
        push_warning("Level scene is not assigned")
    else:
        level_instance = level_scene.instantiate()
        add_child(level_instance)
    var network := get_node_or_null(network_path) if network_path != NodePath() else null
    if player_scene:
        player_instance = player_scene.instantiate()
        add_child(player_instance)
        if network:
            player_instance.network = network
        _place_player_at_spawn()
    if network:
        network.connect("mouse_mode_requested", Callable(self, "_set_mouse_mode"))

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_mouse"):
        var mode := Input.get_mouse_mode()
        if mode == Input.MOUSE_MODE_CAPTURED:
            _set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            _set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _set_mouse_mode(mode: int) -> void:
    Input.set_mouse_mode(mode)

func _place_player_at_spawn() -> void:
    if not player_instance or not level_instance:
        return
    if level_instance.has_method("get_spawn_point"):
        player_instance.global_transform = level_instance.get_spawn_point()
    else:
        player_instance.global_transform.origin = Vector3.ZERO
