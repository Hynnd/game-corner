@tool
extends BoardTile

signal let_player_pass

@export var next_tile:Node3D

var _player_on_tile:int = -1


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return


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
	if Multiplayer.id == 1:
		give_rewards.rpc(id, randi_range(5, 15))


@rpc("any_peer", "call_local", "reliable")
func give_rewards(id:int, num:int):
	GameState.players[id].coins += num


@rpc("any_peer", "call_local", "reliable")
func deposit_balloons(player_id:int):
	GameState.players[player_id].balloons += GameState.players[player_id].unsecured_balloons
	GameState.players[player_id].unsecured_balloons = 0
