extends CharacterBody3D

@export var move_speed := 8.0
@export var air_speed := 6.5
@export var accel := 24.0
@export var air_accel := 4.0
@export var friction := 10.0
@export var gravity := ProjectSettings.get_setting("physics/3d/default_gravity")
@export var jump_impulse := 12.5
@export var mouse_sensitivity := 0.0022
@export var camera_pitch_limit := deg_to_rad(85.0)
@export var weapon_cooldown := 0.25

@export var network: Node = null

var _pitch := 0.0
var _yaw := 0.0
var _cooldown_timer := 0.0

@onready var _camera: Camera3D = $Camera3D
@onready var _muzzle: Marker3D = $Camera3D/Muzzle

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        _yaw -= event.relative.x * mouse_sensitivity
        _pitch = clamp(_pitch - event.relative.y * mouse_sensitivity, -camera_pitch_limit, camera_pitch_limit)
        rotation.y = _yaw
        _camera.rotation.x = _pitch
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        fire_weapon()

func _physics_process(delta: float) -> void:
    _cooldown_timer = maxf(_cooldown_timer - delta, 0.0)
    var dir := Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
    var forward := -global_transform.basis.z.normalized()
    var right := global_transform.basis.x.normalized()
    var wish_dir := (right * dir.x + forward * dir.y)
    var target_speed := move_speed if is_on_floor() else air_speed
    if wish_dir.length() > 1.0:
        wish_dir = wish_dir.normalized()
    var applied_accel := accel if is_on_floor() else air_accel
    velocity.x = move_toward(velocity.x, wish_dir.x * target_speed, applied_accel * delta)
    velocity.z = move_toward(velocity.z, wish_dir.z * target_speed, applied_accel * delta)
    if is_on_floor():
        if Input.is_action_just_pressed("jump"):
            velocity.y = jump_impulse
        else:
            velocity.x = move_toward(velocity.x, 0.0, friction * delta)
            velocity.z = move_toward(velocity.z, 0.0, friction * delta)
    else:
        velocity.y -= gravity * delta
    move_and_slide()
    if network and network.has_method("send_player_state"):
        network.send_player_state(global_transform, velocity)

func fire_weapon() -> void:
    if _cooldown_timer > 0.0:
        return
    _cooldown_timer = weapon_cooldown
    if network and network.has_method("broadcast_shot"):
        network.broadcast_shot(_muzzle.global_transform)
    _spawn_debug_projectile()

func _spawn_debug_projectile() -> void:
    # Placeholder for visuals. Traces a debug ray for now.
    var to := _muzzle.global_transform.origin + (_muzzle.global_transform.basis.z * -1.0 * 10.0)
    get_world_3d().direct_space_state.intersect_ray(
        PhysicsRayQueryParameters3D.create(_muzzle.global_transform.origin, to)
    )
