class_name Player extends CharacterBody3D

var player_id:int = 0

var current_tile_name:String:
	get:
		if GameState.player_tiles.has(player_id):
			return GameState.player_tiles[player_id]
		return ""
	set(value):
		GameState.player_tiles[player_id] = value

enum MoveMode { NORMAL, SIDE } 

@export var move_mode := MoveMode.NORMAL
@export var can_jump:bool = true
@export var can_move:bool = true
@export_group("Stats")
@export var MOVE_SPEED:float = 6
@export var JUMP_FORCE:float = 8
@export var GRAVITY:float = 22

@onready var movement_normal: Node = %MovementNormal
@onready var movement_board: Node = %MovementBoard
@onready var body_manager: Node3D = %BodyManager
@onready var visuals: Node3D = %Visuals
@onready var health: Health = %Health

@onready var synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer


func _enter_tree() -> void:
	GameState.player_nodes[player_id] = self


func _ready() -> void:
	set_multiplayer_authority(player_id)
	
	if move_mode == MoveMode.SIDE:
		axis_lock_linear_z = true
	
	await get_tree().current_scene.ready
	
	# Place player on tile when returning to board
	if current_tile_name != "":
		var tile = GameState.find_tile(current_tile_name)
		if is_instance_valid(tile):
			var pos = tile.get_pos()
			global_position = Vector3(pos.x, 0, pos.y)


func _physics_process(delta: float) -> void:
	%DebugLabel.text = ""
	%DebugLabel.text += str("ID: ", player_id, "\n")
	
	$MultiplayerSynchronizer.public_visibility = can_move


func walk_to_point(_point:Vector2, _speed:float) -> void:
	movement_board.target_points.clear()
	movement_board.target_points.append(_point)
	movement_board.move_speed = _speed
	can_move = false
	can_jump = false


func face_camera():
	var cam = get_viewport().get_camera_3d()
	body_manager.legs.rotation.y = cam.rotation.y + PI
	body_manager.arms.rotation.y = cam.rotation.y + PI
	body_manager.head.rotation.y = cam.rotation.y + PI


func is_owner() -> bool:
	return player_id == multiplayer.get_unique_id()


@rpc("any_peer", "call_local", "reliable")
func take_damage(atk:Dictionary):
	if atk.owner_id == player_id: return
	
	health.damage(atk.damage)
	velocity += atk.knockback
	
	global_position = GameState.player_spawner.get_random_point()
