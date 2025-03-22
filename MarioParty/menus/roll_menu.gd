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
	#return randi_range(15, 15)
	#return randi_range(1, 10)
	return 2


@rpc("any_peer", "call_local", "reliable")
func grant_moves(num):
	var player:Node3D = GameState.player_nodes[GameState.current_id]
	var cur_tile_name:String = GameState.players[GameState.current_id].tile
	
	var next:Node3D
	if cur_tile_name != "":
		var cur_tile:Node3D = GameState.find_tile(cur_tile_name)
		next = GameState.find_tile(cur_tile_name).next_tile
	else:
		GameState.players[GameState.current_id].tile = GameState.start_tile.name
		next = GameState.start_tile
	
	player.movement_board.current_moves = num
	player.walk_to_point(next.get_pos())
