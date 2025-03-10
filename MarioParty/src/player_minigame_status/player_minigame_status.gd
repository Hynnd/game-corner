extends Node


func _ready() -> void:
	for id in GameState.players.keys():
		var new_status = preload("minigame_status_icon/minigame_status_icon.tscn").instantiate()
		new_status.id = id
		$HBoxContainer.add_child(new_status)
