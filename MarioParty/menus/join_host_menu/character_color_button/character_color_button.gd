extends Button

@export var color:Color = Color.WHITE


func _ready() -> void:
	pressed.connect(on_pressed)
	modulate = color


func on_pressed() -> void:
	set_color.rpc(multiplayer.get_unique_id(), color)


@rpc("any_peer", "call_local", "reliable")
func set_color(id:int, col:Color) -> void:
	GameState.players[id].color = col
