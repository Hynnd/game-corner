extends Node3D

@export var sync_movement:bool = true
@export var move_mode := Player.MoveMode.NORMAL
@export var camera_mode := Player.CameraMode.TOP
@export var can_jump:bool = true
@export var can_move:bool = true
@export var player_collision:bool = true
@export_group("Stats")
@export var MOVE_SPEED:float = 6
@export var JUMP_FORCE:float = 8
@export var GRAVITY:float = 22


func _ready() -> void:
	var player_ids:Array = []
	player_ids.append(multiplayer.get_unique_id())
	player_ids.append_array(multiplayer.get_peers())
	player_ids.sort()
	
	var points = [%Point1, %Point2, %Point3, %Point4]
	for i in player_ids.size():
		var id = player_ids[i]
		
		var new_player = preload("res://assets/player/player.tscn").instantiate()
		new_player.global_position = points[i].global_position
		if not player_collision:
			new_player.collision_mask -= 2
		new_player.player_id = id
		new_player.can_jump = can_jump
		new_player.can_move = can_move
		add_child(new_player)
		
		GameState.players[id] = {"index": i, "node": new_player}
