extends Node

@onready var container: HBoxContainer = %Container


func _ready() -> void:
	if Multiplayer.id == 1:
		get_tree().create_timer(10).timeout.connect(func():
			GameState.return_to_board.rpc()
			)
	
	for id in GameState.players.keys():
		var new_status = preload("winner_screen_panel/winner_screen_panel.tscn").instantiate()
		new_status.id = id
		container.add_child(new_status)
	
	for i in GameState.player_nodes.size():
		var id = GameState.players.keys()[i]
		var node = GameState.player_nodes[id]
		node.walk_to_point(Vector2(-3 + i * 2, 0), 3)
		node.movement_board.display_num = false
