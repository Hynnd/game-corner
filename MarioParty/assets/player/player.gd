extends CharacterBody3D

var id:int = 0

var current_tile_name:String:
	get:
		return GameState.players[id].tile
	set(value):
		GameState.players[id].tile = value

@export var can_jump:bool = true
@export var can_move:bool = true
@export_group("Stats")

@onready var movement_normal: Node = %MovementNormal
@onready var movement_board: Node = %MovementBoard
@onready var body_manager: Node3D = %BodyManager
@onready var visuals: Node3D = %Visuals
@onready var health: Health = %Health

@onready var synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer


func _enter_tree() -> void:
	GameState.player_nodes[id] = self


func _ready() -> void:
	set_multiplayer_authority(id)
	
	await get_tree().current_scene.ready
	
	# Place player on tile when returning to board
	if current_tile_name != "":
		var tile = GameState.find_tile(current_tile_name)
		if is_instance_valid(tile):
			var pos = tile.get_pos()
			global_position = Vector3(pos.x, 0, pos.y)


func _physics_process(delta: float) -> void:
	%DebugLabel.text = ""
	%DebugLabel.text += str("ID: ", id, "\n")
	%DebugLabel.text += str("move_input: ", movement_normal.move_input, "\n")
	%DebugLabel.text += str("move_dir: ", movement_normal.move_dir, "\n")
	
	$MultiplayerSynchronizer.public_visibility = can_move
	
	if Input.is_action_just_pressed("activate_move"):
		can_move = true
		can_jump = true


func walk_to_point(_point:Vector2, _speed:float = -1) -> void:
	movement_board.target_point = _point
	movement_board.moving = true
	if _speed != -1:
		movement_board.move_speed = _speed
	can_move = false
	can_jump = false


func face_camera():
	var cam = get_viewport().get_camera_3d()
	body_manager.legs.rotation.y = cam.rotation.y + PI
	body_manager.arms.rotation.y = cam.rotation.y + PI
	body_manager.head.rotation.y = cam.rotation.y + PI


func is_owner() -> bool:
	return id == multiplayer.get_unique_id()


@rpc("any_peer", "call_local", "reliable")
func take_damage(atk:Dictionary):
	if atk.owner_id == id: return
	
	health.damage(atk.damage)
	velocity += atk.knockback
