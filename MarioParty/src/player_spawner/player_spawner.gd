extends Node3D

## Pick spawn position randomly
@export var pick_random:bool = false
@export var item:PackedScene

@export_group("Player Parameters")
@export var sync_movement:bool = true
@export var move_mode := Player.MoveMode.NORMAL
@export var camera_mode := Player.CameraMode.TOP
@export var can_jump:bool = true
@export var can_move:bool = true
@export var player_collision:bool = true
@export var MOVE_SPEED:float = 6
@export var JUMP_FORCE:float = 8
@export var GRAVITY:float = 22



func _ready() -> void:
	var ordered_ids:Array = []
	ordered_ids.resize(GameState.players.size())
	for id in GameState.players.keys():
		var index:int = GameState.players[id].index
		ordered_ids[index] = id
	
	var points = get_children()
	for i in ordered_ids.size():
		var point = points[i]
		if pick_random: point = points.pick_random()
		
		var id = ordered_ids[i]
		var new_player = preload("res://assets/player/player.tscn").instantiate()
		new_player.global_position = point.global_position
		if not player_collision:
			new_player.collision_mask -= 2
		new_player.player_id = id
		new_player.can_jump = can_jump
		new_player.can_move = can_move
		new_player.camera_mode = camera_mode
		new_player.move_mode = move_mode
		add_child(new_player)
		
		if is_instance_valid(item):
			var new_item = item.instantiate()
			new_player.add_child(new_item)
		
		GameState.player_nodes[id] = new_player
	
	for point in points:
		point.hide()


func get_random_point() -> Vector3:
	return get_children().pick_random().global_position
