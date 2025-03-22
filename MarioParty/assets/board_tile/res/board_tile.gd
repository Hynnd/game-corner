@tool
extends BoardTile

@export var is_start:bool = false
@export var next_tile:Node3D

var _player_on_tile:int = -1


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	if is_start:
		GameState.start_tile = self


func _ready() -> void:
	_create_lines()
	if Engine.is_editor_hint(): return


func _create_lines() -> void:
	if not is_instance_valid(next_tile): return
	
	create_line(next_tile.global_position)


func on_player_passed(id:int):
	var player = GameState.player_nodes[id]
	player.movement_board.current_moves -= 1
	if player.movement_board.current_moves > 0:
		player.walk_to_point(next_tile.get_pos())
		player.current_tile_name = next_tile.name


func on_player_stopped(id:int):
	pass
