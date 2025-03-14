extends Node3D

const BOARD_TILE_LINE = preload("_line.tscn")

@export var is_start:bool = false
@export var next_tile_left:Node3D
@export var next_tile_right:Node3D

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
	for tile in [next_tile_left, next_tile_right]:
		var line = BOARD_TILE_LINE.instantiate()
		var arrow = line.get_node("Arrow")
		add_child(line)
		line.position = global_position.lerp(tile.global_position, 0.5)
		line.scale.z = global_position.distance_to(tile.global_position)
		line.rotation.y = -Swizzler.xz(tile.global_position - global_position).angle()-PI/2
		
		arrow.position = global_position.lerp(tile.global_position, 0.5)
		arrow.rotation.y = -Swizzler.xz(tile.global_position - global_position).angle()-PI/2


func get_pos() -> Vector2:
	return Swizzler.xz(global_position)


func on_player_passed(id:int):
	var player = GameState.player_nodes[id]
	
	player.movement_board.moving = false
	if Multiplayer.id == GameState.current_id:
		SplitPathPrompt.show()
	_player_on_tile = id


func on_player_stopped(id:int):
	pass


@rpc("any_peer", "call_local", "reliable")
func chose_path(path:int):
	if _player_on_tile != -1:
		var next_tile = next_tile_left if path == 0 else next_tile_right
		SplitPathPrompt.hide()
		GameState.player_nodes[_player_on_tile].walk_to_point(next_tile.get_pos())
		GameState.player_nodes[_player_on_tile].current_tile_name = next_tile.name
		_player_on_tile = -1
