extends Node


func _ready() -> void:
	GameState.current_player = 0
	
	GameState.finished_walking.connect(func():
		if GameState.current_player == GameState.players.size() - 1:
			get_tree().change_scene_to_file("res://scenes/3d_test.tscn")
		else:
			%DoNextMenu.get_node("DoNextMenu").show()
			GameState.current_player += 1
		)
	
	if GameState.player_tiles.size() == 0:
		for id in GameState.players.keys():
			GameState.player_tiles[id] = GameState.start_tile.name
	
	for player in GameState.players.values():
		player.face_camera()
		player.can_move = false
		player.can_jump = false
