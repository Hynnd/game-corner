extends Node

signal finished_walking
signal current_player_incremented

var players:Dictionary[int, Dictionary] = {} # ID, Node
var player_tiles:Dictionary[int, String] = {} # ID, Tile name
var current_id:int # ID
var start_tile:Node3D


func find_tile(tile_name:String) -> Node3D:
	var tiles = get_tree().get_nodes_in_group("board_tile")
	for tile in tiles:
		if tile.name == tile_name:
			return tile
	return null


func find_player(player_id:int) -> Node3D:
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		if player.player_id == player_id:
			return player
	return null


@rpc("any_peer", "call_local", "reliable")
func return_to_board() -> void:
	get_tree().change_scene_to_file("res://scenes/board_game.tscn")


@rpc("any_peer", "call_local", "reliable")
func play_minigame() -> void:
	get_tree().change_scene_to_file("res://scenes/3d_test.tscn")


@rpc("any_peer", "call_local", "reliable")
func increment_current_player():
	var player_ids = players.keys()
	var index = players[current_id].index
	current_id = get_id_by_index((index+1) % players.size())
	
	current_player_incremented.emit()


func get_id_by_index(index:int):
	for id in players.keys():
		if players[id].index == index:
			return id
