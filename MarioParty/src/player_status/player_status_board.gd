extends Node


func _ready() -> void:
	for id in GameState.players.keys():
		var new_status = preload("player_status_board_card/player_status_board_card.tscn").instantiate()
		new_status.id = id
		$HBoxContainer.add_child(new_status)
