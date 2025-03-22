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
		%Menu.hide()
		deposit_balloons.rpc(GameState.current_id)
		continue_moving.rpc()
		)
	no_button.pressed.connect(func():
		%Menu.hide()
		continue_moving.rpc()
		)
	%Menu.hide()


func _create_lines() -> void:
	if not is_instance_valid(next_tile): return
	
	create_line(next_tile.global_position)


func on_player_passed(id:int):
	if Multiplayer.id == GameState.current_id:
		%Menu.show()


func on_player_stopped(id:int):
	pass


@rpc("any_peer", "call_local", "reliable")
func continue_moving():
	var player = GameState.player_nodes[GameState.current_id]
	player.walk_to_point(next_tile.get_pos())
	player.current_tile_name = next_tile.name


@rpc("any_peer", "call_local", "reliable")
func deposit_balloons(player_id:int):
	GameState.players[player_id].balloons += GameState.players[player_id].unsecured_balloons
	GameState.players[player_id].unsecured_balloons = 0
