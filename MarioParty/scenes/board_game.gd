extends Node

@export var base_player:Node3D


func _ready() -> void:
	GameState.finished_walking.connect(func():
		if multiplayer.is_server():
			if GameState.players[GameState.current_id].index == GameState.players.size() - 1:
				GameState.play_minigame.rpc()
			else:
				GameState.increment_current_player.rpc()
		)
	GameState.current_player_incremented.connect(func():
		if GameState.current_id == multiplayer.get_unique_id():
			%DoNextMenu.get_node("DoNextMenu").show()
		)
	
	GameState.current_id = 1
	
	if GameState.current_id == multiplayer.get_unique_id():
		%DoNextMenu.get_node("DoNextMenu").show()
	
	#_initialize_players()
	
	if GameState.player_tiles.size() == 0:
		for id in GameState.players.keys():
			GameState.player_tiles[id] = GameState.start_tile.name
	
	for id in GameState.players.keys():
		var node = GameState.players[id].node
		node.face_camera()
		node.can_move = false
		node.can_jump = false


func _process(delta: float) -> void:
	$Label.text = ""
	$Label.text += str("id: ", multiplayer.get_unique_id(), "\n")
	$Label.text += str("current_id: ", GameState.current_id, "\n")
	$Label.text += str("current_index: ", GameState.players[GameState.current_id].index, "\n")
	$Label.text += str("num: ", GameState.players.size(), "\n")


#func _initialize_players() -> void:
	#var player_ids:Array = []
	#player_ids.append(multiplayer.get_unique_id())
	#player_ids.append_array(multiplayer.get_peers())
	#player_ids.sort()
	#
	#for i in player_ids.size():
		#var id = player_ids[i]
		#
		#var new_player = preload("res://assets/player/player.tscn").instantiate()
		#new_player.global_position = Vector3(i,3,0)
		#new_player.collision_mask -= 2
		#new_player.player_id = id
		#new_player.sync_movement = false
		#add_child(new_player)
		#
		#GameState.players[id] = {"index": i, "node": new_player}
