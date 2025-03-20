@tool
extends BoardTile

signal let_player_pass

@export var next_tile:Node3D

var _player_on_tile:int = -1

@onready var yes_button: Button = %YesButton
@onready var no_button: Button = %NoButton


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return


func _ready() -> void:
	_create_lines()
	if Engine.is_editor_hint(): return
	
	yes_button.pressed.connect(func():
		deposit_balloons(GameState.current_id)
		%Menu.hide()
		continue_moving.rpc()
		#let_player_pass.emit()
		)
	no_button.pressed.connect(func():
		%Menu.hide()
		continue_moving.rpc()
		#let_player_pass.emit()
		)
	%Menu.hide()


func _create_lines() -> void:
	if not is_instance_valid(next_tile): return
	
	create_line(next_tile.global_position)


func get_pos() -> Vector2:
	var offsets = [Vector2(0,-1),Vector2(0,1),Vector2(1,0),Vector2(-1,0),Vector2(-5,0)]
	var players_on_tile = 0
	for id in GameState.player_tiles.keys():
		var tile_name = GameState.player_tiles[id]
		if tile_name == name and global_position.distance_to(GameState.player_nodes[id].global_position) < 2:
			players_on_tile += 1
	
	return Swizzler.xz(global_position) + offsets[players_on_tile]


func on_player_passed(id:int):
	if Multiplayer.id != GameState.current_id: return
	
	%Menu.show()
	#await let_player_pass
	#var player = GameState.player_nodes[id]
	#player.walk_to_point(next_tile.get_pos())
	#player.current_tile_name = next_tile.name


@rpc("any_peer", "call_local", "reliable")
func continue_moving():
	var player = GameState.player_nodes[GameState.current_id]
	player.walk_to_point(next_tile.get_pos())
	player.current_tile_name = next_tile.name


func on_player_stopped(id:int):
	pass


func deposit_balloons(player_id:int):
	GameState.players[player_id].balloons += GameState.players[player_id].unsecured_balloons
