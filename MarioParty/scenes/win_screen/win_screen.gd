extends Node

@onready var container: HBoxContainer = %Container


func _ready() -> void:
	if Multiplayer.id == 1:
		get_tree().create_timer(5).timeout.connect(func():
			GameState.return_to_board.rpc()
			)
	
	for id in GameState.players.keys():
		var new_status = preload("winner_screen_panel/winner_screen_panel.tscn").instantiate()
		new_status.id = id
		container.add_child(new_status)
