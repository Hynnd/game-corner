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
	return randi_range(1, 3)


@rpc("any_peer", "call_local", "reliable")
func grant_moves(num):
	#GameState.players[GameState.current_id].node.current_moves = num
	GameState.player_nodes[GameState.current_id].current_moves = num
