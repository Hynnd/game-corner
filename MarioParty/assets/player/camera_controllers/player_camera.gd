extends Node3D

@export var follow_player:bool = true
@export var hide_cursor:bool = true
@export var look_around:bool = true
@export var first_person:bool = false
@export var distance:float = 10:
	set(value): distance = value; if get_tree()!=null: cam.position.z = value
@export var height:float = 1.43:
	set(value): height = value; if get_tree()!=null: orbit.position.y = value
@export var angle:float = 0:
	set(value): angle = value; if get_tree()!=null: orbit.rotation_degrees.x = value
@export var fov:float = 75:
	set(value): fov = value; if get_tree()!=null: cam.fov = value
@export var update_to_floor:bool = false

var max_angle:float = 89
var min_angle:float = -89

var mouse_sensitivity:float = 65

var target:Node3D

var _floor_height:float

@onready var cam:Camera3D = %Camera3D
@onready var orbit: Node3D = %Orbit


func _enter_tree() -> void:
	GameState.camera_controller = self


func _ready() -> void:
	await get_tree().process_frame
	
	set_multiplayer_authority(Multiplayer.id)
	if hide_cursor:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	target = GameState.player_nodes[Multiplayer.id]
	
	if first_person:
		target.visuals.hide()
	
	_floor_height = target.global_position.y
	
	cam.fov = fov
	cam.position.z = distance
	orbit.position.y = height
	orbit.rotation_degrees.x = angle


func _input(event):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED: return
	
	if look_around:
		if event is InputEventMouseMotion:
			var screen_size: Vector2 = get_viewport().get_screen_transform().get_scale()
			var mouse_delta: Vector2 = event.relative * mouse_sensitivity / 1000 * screen_size.x
			orbit.rotation.y -= deg_to_rad(mouse_delta.x)
			orbit.rotation.x -= deg_to_rad(mouse_delta.y)
			orbit.rotation.x = clampf(orbit.rotation.x, deg_to_rad(min_angle), deg_to_rad(max_angle))


func _process(delta: float) -> void:
	if not is_instance_valid(target): return
	
	if first_person:
		update_head_rot.rpc(Multiplayer.id, orbit.global_rotation)
	
	if follow_player:
		if update_to_floor:
			position.x = target.global_position.x
			position.z = target.global_position.z
			position.y = lerpf(position.y, _floor_height, 3.5 * delta)
		else:
			position = target.global_position
	
	#cam.fov = fov
	#orbit.position.y = height
	#orbit.rotation_degrees.x = angle
	#cam.position.z = distance
	
	if Input.is_action_just_pressed("right_click"):
		if not Input.mouse_mode == Input.MOUSE_MODE_VISIBLE: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	orbit.rotation.x = clampf(orbit.rotation.x, deg_to_rad(min_angle), deg_to_rad(max_angle))


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target): return
	
	if target.is_on_floor():
		_floor_height = target.global_position.y
	const MARGIN_DOWN = 2
	const MARGIN_UP = 4
	_floor_height = clampf(_floor_height, target.global_position.y-MARGIN_UP, target.global_position.y+MARGIN_DOWN)
	position.y = clampf(position.y, target.global_position.y-MARGIN_UP, target.global_position.y+MARGIN_DOWN)


@rpc("any_peer", "call_local", "unreliable")
func update_head_rot(id:int, rot:Vector3):
	GameState.player_nodes[id].body_manager.head.global_rotation = rot
