extends Node3D

const BOARD_TILE_LINE = preload("_line.tscn")

@export var is_start:bool = false
@export var next_tile:Node3D

var _player_on_tile:int = -1


func _enter_tree() -> void:
	if is_start:
		GameState.start_tile = self


func _ready() -> void:
	SplitPathPrompt.path_chosen.connect(func(path:int):
		chose_path.rpc(path)
		)
	_create_lines()


func _create_lines() -> void:
	var line = BOARD_TILE_LINE.instantiate()
	var arrow = line.get_node("Arrow")
	add_child(line)
	line.position = global_position.lerp(next_tile.global_position, 0.5)
	line.scale.z = global_position.distance_to(next_tile.global_position)
	line.rotation.y = -Swizzler.xz(next_tile.global_position - global_position).angle()-PI/2
	
	arrow.position = global_position.lerp(next_tile.global_position, 0.5)
	arrow.rotation.y = -Swizzler.xz(next_tile.global_position - global_position).angle()-PI/2


func get_pos() -> Vector2:
	var offsets = [Vector2(0,-1),Vector2(0,1),Vector2(1,0),Vector2(-1,0),Vector2(-5,0)]
	var players_on_tile = 0
	for id in GameState.player_tiles.keys():
		var tile_name = GameState.player_tiles[id]
		if tile_name == name and global_position.distance_to(GameState.player_nodes[id].global_position) < 2:
			players_on_tile += 1
	
	return Swizzler.xz(global_position) + offsets[players_on_tile]


func on_player_passed(id:int):
	var player = GameState.player_nodes[id]
	player.walk_to_point(next_tile.get_pos())
	player.current_tile_name = next_tile.name
	player.movement_board.current_moves -= 1


func on_player_stopped(id:int):
	pass


@rpc("any_peer", "call_local", "reliable")
func chose_path(path:int):
	if _player_on_tile != -1:
		SplitPathPrompt.hide()
		GameState.player_nodes[_player_on_tile].walk_to_point(next_tile.get_pos())
		GameState.player_nodes[_player_on_tile].current_tile_name = next_tile.name
		_player_on_tile = -1
