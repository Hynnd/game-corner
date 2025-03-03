extends Node3D

const BOARD_TILE_LINE = preload("board_tile_line.tscn")

@export var is_start:bool = false
@export var next_tiles:Array[Node3D]


func _enter_tree() -> void:
	if is_start:
		GameState.start_tile = self


func _ready() -> void:
	_create_lines()


func _create_lines() -> void:
	for tile in next_tiles:
		var line = BOARD_TILE_LINE.instantiate()
		add_child(line)
		line.position = global_position.lerp(tile.global_position, 0.5)
		line.scale.z = global_position.distance_to(tile.global_position)
		line.rotation.y = -Swizzler.xz(tile.global_position - global_position).angle()-PI/2


func get_pos() -> Vector2:
	var offsets = [Vector2(0,-1),Vector2(0,1),Vector2(1,0),Vector2(-1,0)]
	var players_on_tile = 0
	#for tile_name in GameState.player_tiles.values():
	for id in GameState.player_tiles.keys():
		var tile_name = GameState.player_tiles[id]
		if tile_name == name and global_position.distance_to(GameState.players[id].global_position) < 2:
			players_on_tile += 1
	
	return Swizzler.xz(global_position) + offsets[players_on_tile]
