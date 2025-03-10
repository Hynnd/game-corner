extends Node

signal finished_walking
signal current_player_incremented
signal player_added

var players:Dictionary[int, Dictionary] = {} # ID, Dict
var current_id:int # ID

var player_tiles:Dictionary[int, String] = {} # ID, Tile name
var player_nodes:Dictionary[int, Node3D] = {} # ID, Node
var start_tile:Node3D


func find_tile(tile_name:String) -> Node3D:
	var tiles = get_tree().get_nodes_in_group("board_tile")
	for tile in tiles:
		if tile.name == tile_name:
			return tile
	return null


@rpc("any_peer", "call_local", "reliable")
func return_to_board() -> void:
	get_tree().change_scene_to_file("res://scenes/board_game.tscn")


@rpc("any_peer", "call_local", "reliable")
func play_minigame() -> void:
	get_tree().change_scene_to_file("res://scenes/3d_test.tscn")


@rpc("any_peer", "call_local", "reliable")
func increment_current_player() -> void:
	var player_ids = players.keys()
	var index = players[current_id].index
	current_id = get_id_by_index((index+1) % players.size())
	
	current_player_incremented.emit()


func get_id_by_index(index:int) -> int:
	for id in players.keys():
		if players[id].index == index:
			return id
	return -1


@rpc("any_peer", "call_local", "reliable")
func add_player(id:int) -> void:
	if not players.has(id):
		players[id] = {}
	players[id]["color"] = Color.WHITE
	
	player_added.emit()


@rpc("any_peer", "call_local", "reliable")
func get_state() -> Dictionary:
	var state = {}
	state["players"] = players
	state["current_id"] = current_id
	return state


@rpc("any_peer", "call_local", "reliable")
func set_state(state:Dictionary) -> void:
	players = state["players"]
	current_id = state["current_id"]


@rpc("any_peer", "call_local", "reliable")
func clear_state() -> void:
	players = {}
	current_id = NAN
