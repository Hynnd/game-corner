

extends Node3D

@export var max_angle:float = 89
@export var min_angle:float = -89

var mouse_sensitivity:float = 65

var target:Node3D

@onready var cam:Camera3D = %Camera3D


func _ready() -> void:
	await get_tree().process_frame
	
	set_multiplayer_authority(Multiplayer.id)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	target = GameState.player_nodes[Multiplayer.id]
	
	target.visuals.hide()


func _input(event):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED: return
	
	if event is InputEventMouseMotion:
		var screen_size: Vector2 = get_viewport().get_screen_transform().get_scale()
		var mouse_delta: Vector2 = event.relative * mouse_sensitivity / 1000 * screen_size.x
		cam.rotation.y -= deg_to_rad(mouse_delta.x)
		cam.rotation.x -= deg_to_rad(mouse_delta.y)
		cam.rotation.x = clampf(cam.rotation.x, deg_to_rad(min_angle), deg_to_rad(max_angle))


func _process(delta: float) -> void:
	if is_instance_valid(target):
		position = target.global_position
	
	update_head_rot.rpc(Multiplayer.id, cam.global_rotation)


@rpc("any_peer", "call_local", "unreliable")
func update_head_rot(id:int, rot:Vector3):
	GameState.player_nodes[id].body_manager.head.global_rotation = rot
