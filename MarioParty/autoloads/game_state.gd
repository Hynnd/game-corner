extends Node

signal finished_walking
signal current_player_incremented
signal player_added
signal players_spawned

const PLAYER_STATE:Dictionary = {
	"index": -1,
	"color": Color.WHITE,
	"face": null,
	"coins": 0,
	"tile": "",
	"minigame_coins": 0,
	"balloons": 0,
	"unsecured_balloons": 0,
}
const ATTACK_EVENT:Dictionary = {
	"damage": 0,
	"knockback": Vector3.ZERO,
	"owner_id": -1,
}
const MINIGAME_POOL = [
	#"minigame_2d_race",
	"minigame_shooter",
	#"minigame_bomber",
]

var players:Dictionary[int, Dictionary] = {} # ID, Dict

var player_nodes:Dictionary[int, Node3D] = {} # ID, Node3D
var current_id:int = -1 # ID
var start_tile:Node3D
var player_spawner:Node
var camera_controller:Node3D
var max_rounds:int = 15
var current_round:int = 0
var board_path:String = ""


func find_tile(tile_name:String) -> Node3D:
	var tiles = get_tree().get_nodes_in_group("board_tile")
	for tile in tiles:
		if tile.name == tile_name:
			return tile
	return null


@rpc("any_peer", "call_local", "reliable")
func to_winner_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/win_screen/win_screen.tscn")


@rpc("any_peer", "call_local", "reliable")
func play_minigame() -> void:
	var file_name = MINIGAME_POOL.pick_random()
	var path = "res://scenes/minigames/" + file_name + ".tscn"
	get_tree().change_scene_to_file(path)


@rpc("any_peer", "call_local", "reliable")
func return_to_board() -> void:
	for id in players.keys():
		players[id].coins += players[id].minigame_coins
		players[id].minigame_coins = 0
	current_round += 1
	get_tree().change_scene_to_file(board_path)


@rpc("any_peer", "call_local", "reliable")
func begin_game() -> void:
	current_round = 1
	board_path = "res://scenes/boardgames/boardgame_1.tscn"
	get_tree().change_scene_to_file(board_path)



@rpc("any_peer", "call_local", "reliable")
func increment_current_player() -> void:
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
	if players.has(id): return
	
	players[id] = PLAYER_STATE.duplicate()
	
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
