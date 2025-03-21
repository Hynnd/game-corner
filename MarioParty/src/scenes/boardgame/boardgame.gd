@icon("boardgame.svg")
extends Node


func _ready() -> void:
	GameState.finished_walking.connect(func():
		if multiplayer.is_server():
			if GameState.players[GameState.current_id].index == GameState.players.size() - 1:
				await get_tree().create_timer(2).timeout
				GameState.play_minigame.rpc()
			else:
				GameState.increment_current_player.rpc()
		)
	GameState.current_player_incremented.connect(func():
		if GameState.current_id == multiplayer.get_unique_id():
			%BoardUI.get_node("DoNextMenu").show()
		)
	%ForceStartMinigame.pressed.connect(func():
		GameState.play_minigame.rpc()
		)
	
	GameState.current_id = 1
	
	if GameState.current_id == multiplayer.get_unique_id():
		%BoardUI.get_node("DoNextMenu").show()
	
	#if GameState.player_tiles.size() == 0:
		#for id in GameState.players.keys():
			#GameState.player_tiles[id] = ""
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	for id in GameState.players.keys():
		var node = GameState.player_nodes[id]
		node.face_camera()
