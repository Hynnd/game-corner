extends Node

signal finished_walking

var players:Dictionary[int, Node3D] = {}
var player_tiles:Dictionary[int, String] = {}
var current_player:int = 0
#var num_players:int = 4
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


func return_to_board() -> void:
	get_tree().change_scene_to_file("res://scenes/board_game.tscn")
