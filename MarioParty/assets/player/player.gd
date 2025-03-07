class_name Player extends CharacterBody3D

@export var player_id:int = 0
var current_tile_name:String:
	get:
		if GameState.player_tiles.has(player_id):
			return GameState.player_tiles[player_id]
		return ""
	set(value):
		GameState.player_tiles[player_id] = value

var current_moves:int = 0
var moving:bool = false

enum MoveMode { NORMAL, SIDE } 
enum CameraMode { TOP, SIDE, THIRD, FIRST, NONE } 

#@export var sync_movement:bool = true
@export var move_mode := MoveMode.NORMAL
@export var camera_mode := CameraMode.TOP
@export var can_jump:bool = true
@export var can_move:bool = true
@export_group("Stats")
@export var MOVE_SPEED:float = 6
@export var JUMP_FORCE:float = 8
@export var GRAVITY:float = 22

@onready var movement_normal: Node = %MovementNormal
@onready var movement_animated: Node = %MovementAnimated
@onready var body_manager: Node3D = %BodyManager
@onready var visuals: Node3D = %Visuals

@onready var synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer


func _ready() -> void:
	set_multiplayer_authority(player_id)
	
	if move_mode == MoveMode.SIDE:
		axis_lock_linear_z = true
	
	await get_tree().current_scene.ready
	
	# Move player to tile
	if current_tile_name != "":
		var tile = GameState.find_tile(current_tile_name)
		if is_instance_valid(tile):
			var pos = tile.get_pos()
			global_position = Vector3(pos.x, 0, pos.y)
	


func _physics_process(delta: float) -> void:
	_tile_moving()
	
	%DebugLabel.text = ""
	%DebugLabel.text += str("ID: ", player_id, "\n")
	
	$MultiplayerSynchronizer.public_visibility = can_move


func _tile_moving():
	if current_moves > 0 and movement_animated.target_points.size() == 0:
		moving = true
		
		var tile = GameState.find_tile(current_tile_name)
		if tile.has_method("on_player_passed"):
			tile.on_player_passed(player_id)
		
		var next_tile = GameState.find_tile(current_tile_name).next_tiles[0]
		walk_to_point(next_tile.get_pos(), 6)
		current_tile_name = next_tile.name
		
		current_moves -= 1
	if moving and current_moves == 0 and movement_animated.target_points.size() == 0:
		moving = false
		face_camera()
		
		var tile = GameState.find_tile(current_tile_name)
		if tile.has_method("on_player_stopped"):
			tile.on_player_stopped(player_id)
		
		GameState.finished_walking.emit()


func walk_to_point(_point:Vector2, _speed:float) -> void:
	movement_animated.target_points.clear()
	movement_animated.target_points.append(_point)
	movement_animated.move_speed = _speed
	can_move = false
	can_jump = false


func face_camera():
	var cam = get_viewport().get_camera_3d()
	body_manager.legs.rotation.y = cam.rotation.y + PI
	body_manager.arms.rotation.y = cam.rotation.y + PI
	body_manager.head.rotation.y = cam.rotation.y + PI


func is_owner() -> bool:
	return player_id == multiplayer.get_unique_id()
