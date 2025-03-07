extends Control

@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var button: Button = $Button

var num_ready_players:int = 0


func _ready() -> void:
	button.toggled.connect(func(toggled_on:bool):
		if toggled_on:
			ready_up.rpc()
		else:
			unready.rpc()
		)


func _process(delta: float) -> void:
	label.text = ""
	label.text += str("is server: ", multiplayer.is_server(), "\n")
	label.text += str("id: ", multiplayer.get_unique_id(), "\n")
	label.text += str("other id(s): ", multiplayer.get_peers(), "\n")
	
	label_2.text = str(num_ready_players, "/", multiplayer.get_peers().size()+1)


@rpc("any_peer", "call_local", "reliable")
func ready_up():
	num_ready_players += 1
	
	if num_ready_players == multiplayer.get_peers().size() + 1:
		get_tree().change_scene_to_file("res://scenes/board_game.tscn")


@rpc("any_peer", "call_local", "reliable")
func unready():
	num_ready_players -= 1
