@tool
extends BoardTile

@export var next_tile_left:Node3D
@export var next_tile_right:Node3D

var _player_on_tile:int = -1

@onready var split_path_prompt: Control = %SplitPathPrompt


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return


func _ready() -> void:
	_create_lines()
	if Engine.is_editor_hint(): return
	
	
	split_path_prompt.path_chosen.connect(func(path:int):
		chose_path.rpc(path)
		)


func _create_lines() -> void:
	for tile in [next_tile_left, next_tile_right]:
		if not is_instance_valid(tile): continue
		
		create_line(tile.global_position)


func get_pos() -> Vector2:
	return Swizzler.xz(global_position)


func on_player_passed(id:int):
	var player = GameState.player_nodes[id]
	
	player.movement_board.moving = false
	if Multiplayer.id == GameState.current_id:
		split_path_prompt.show()
	_player_on_tile = id


func on_player_stopped(id:int):
	pass


@rpc("any_peer", "call_local", "reliable")
func chose_path(path:int):
	if _player_on_tile != -1:
		var next_tile = next_tile_left if path == 0 else next_tile_right
		split_path_prompt.hide()
		GameState.player_nodes[_player_on_tile].walk_to_point(next_tile.get_pos())
		GameState.player_nodes[_player_on_tile].current_tile_name = next_tile.name
		_player_on_tile = -1
