extends Node3D

const BOARD_TILE_LINE = preload("line/board_tile_line.tscn")

@export var is_start:bool = false
@export var consume_move:bool = true
@export var next_tile_1:Node3D
@export var next_tile_2:Node3D

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
	for tile in next_tiles:
		var line = BOARD_TILE_LINE.instantiate()
		var arrow = line.get_node("Arrow")
		add_child(line)
		line.position = global_position.lerp(tile.global_position, 0.5)
		line.scale.z = global_position.distance_to(tile.global_position)
		line.rotation.y = -Swizzler.xz(tile.global_position - global_position).angle()-PI/2
		
		arrow.position = global_position.lerp(tile.global_position, 0.5)
		arrow.rotation.y = -Swizzler.xz(tile.global_position - global_position).angle()-PI/2


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
	
	if next_tiles.size() == 1:
		var next_tile = next_tiles[0]
		player.walk_to_point(next_tile.get_pos())
		player.current_tile_name = next_tile.name
		player.movement_board.current_moves -= 1
	else:
		player.movement_board.moving = false
		if Multiplayer.id == GameState.current_id:
			SplitPathPrompt.show()
		_player_on_tile = id


func on_player_stopped(id:int):
	pass


@rpc("any_peer", "call_local", "reliable")
func chose_path(path:int):
	print(_player_on_tile)
	if _player_on_tile != -1:
		var next_tile = next_tiles[path]
		SplitPathPrompt.hide()
		GameState.player_nodes[_player_on_tile].walk_to_point(next_tile.get_pos())
		GameState.player_nodes[_player_on_tile].current_tile_name = next_tile.name
		_player_on_tile = -1
