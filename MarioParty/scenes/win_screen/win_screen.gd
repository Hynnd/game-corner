extends Node

@onready var container: HBoxContainer = %Container


func _ready() -> void:
	if Multiplayer.id == 1:
		get_tree().create_timer(10).timeout.connect(func():
			GameState.return_to_board.rpc()
			)
	
	for id in GameState.players.keys():
		var new_status = preload("player_status_winner_card/player_status_winner_card.tscn").instantiate()
		new_status.id = id
		container.add_child(new_status)
	
	var num_players = GameState.player_nodes.size()
	for i in num_players:
		var id = GameState.players.keys()[i]
		var node = GameState.player_nodes[id]
		node.walk_to_point(Vector2(-(num_players-1) + i * 2, 0), 3)
		node.movement_board.display_num = false
	
	for id in get_winners():
		GameState.players[id].unsecured_balloons += 1
	
	for i:int in container.get_child_count():
		var node = container.get_child(i)
		node.modulate.a = 0
		create_tween().tween_property(node, "modulate:a", 1, 0.).set_delay(2.9 + i * 0.15)


func get_winners() -> Array[int]:
	var winner_ids:Array[int] = [GameState.players.keys()[0]]
	var highest_score:int = GameState.players[winner_ids[0]].minigame_coins
	for next_id in GameState.players.keys():
		var next_score = GameState.players[next_id].minigame_coins
		if next_score > highest_score:
			highest_score = next_score
			winner_ids = [next_id]
		elif next_score == highest_score:
			winner_ids.append(next_id)
	return winner_ids
