extends Control


func _ready() -> void:
	$Button.pressed.connect(func():
		randomize()
		grant_moves.rpc(get_dice_roll())
		hide()
		)
	hide()


func get_dice_roll() -> int:
	randomize()
	#return randi_range(1, 10)
	return randi_range(15, 15)


@rpc("any_peer", "call_local", "reliable")
func grant_moves(num):
	var player = GameState.player_nodes[GameState.current_id]
	var cur_tile_name = GameState.player_tiles[GameState.current_id]
	var next = GameState.find_tile(cur_tile_name).next_tiles[0]
	player.movement_board.current_moves = num
	player.walk_to_point(next.get_pos())
