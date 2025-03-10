extends Control

@onready var label: Label = $Label
@onready var ready_button: Button = %Ready
@onready var force_start_button: Button = %ForceStart

var num_ready_players:int = 0


func _ready() -> void:
	ready_button.toggled.connect(func(toggled_on:bool):
		if toggled_on:
			ready_up.rpc()
		else:
			unready.rpc()
		)
	force_start_button.pressed.connect(func():
		ready_up.rpc(true)
		)
	if not OS.is_debug_build(): force_start_button.hide()
	
	multiplayer.connected_to_server.connect(func():
		await GameState.player_added
		await get_tree().create_timer(0.1).timeout
		$HBoxContainer.get_child(multiplayer.get_peers().size()).on_pressed()
		)


func _process(delta: float) -> void:
	label.text = ""
	label.text += str("is server: ", multiplayer.is_server(), "\n")
	label.text += str("id: ", multiplayer.get_unique_id(), "\n")
	label.text += str("other id(s): ", multiplayer.get_peers(), "\n")
	for id in GameState.players.keys():
		label.text += str("player_data: ",id,": ", GameState.players[id], "\n")
	
	var id = multiplayer.get_unique_id()
	if GameState.players.has(id) and GameState.players[id].has("color"):
		$TextureRect.modulate = GameState.players[id].color


@rpc("any_peer", "call_local", "reliable")
func start_game(sorted_ids:Array) -> void:
	# Set player indexes
	for i in sorted_ids.size():
		var id = sorted_ids[i]
		GameState.players[id].index = i
	
	get_tree().change_scene_to_file("res://scenes/board_game.tscn")


@rpc("any_peer", "call_local", "reliable")
func ready_up(force_start:bool = false):
	num_ready_players += 1
	if force_start: num_ready_players = multiplayer.get_peers().size() + 1
	
	if num_ready_players == multiplayer.get_peers().size() + 1:
		if multiplayer.is_server():
			var player_ids:Array = []
			player_ids.append(multiplayer.get_unique_id())
			player_ids.append_array(multiplayer.get_peers())
			player_ids.sort()
			start_game.rpc(player_ids)


@rpc("any_peer", "call_local", "reliable")
func unready():
	num_ready_players -= 1
